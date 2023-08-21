param([string] $configfile = "..\Configs\ITL-Import.config", [Int32] $debug = 0)

<# ------------------------------------------------------------------------------------------------------------ #>
<# Author: Alexander Skripkin
   Version: 1.05
   Copyright: Copyright (c) 2019 by dSPACE GmbH, Paderborn, Germany. All Rights Reserved.
#>
<# Description:
    Imports folders with CRTITA test results into ITL.
#>
<# Requirements:
    - Logging (v1.05 or higher)
#>
<# Change-Log:
    v1.06:  - Added mutex file for working on new VMs
    v1.05:  - Fixed crash after Merging Repetitions
            - Fixed Updating TestSuite when previous TestTrigger is already the same IB and TestSuite was not updated
	    - robocopy instead of aCopyLatest gives performance
    v1.04:  - Add manuell switch for updating the TestSuite Structure
            - No more copying of TestSuite if TestSuite already exists at given location
    v1.03:  - Edited the log messages due to new Logging-module-update
            - Any error will be logged now, including errors of Excel-Macros
            - Fixed Bug: Create new TestTrigger in a new Excel-Table without previous testtriggers
            - Fixed Bug: Acquiring correct CRTITA-Version when configured from Software at dSPACE
            - Fixed Bug: method MergeRepetitions crashed when deleting Repetition-Rows in Overview-Sheet
            - Fixed Bug: When an error occurs the Dialog was too small to show the OK-Button
    v1.02:  - complied with rules from Powershell Scripting Guideline
            - Rewritten as Class
            - Now all filters and hidden rows & columns will be visible at startup
              to prevent an error when running a makro
            - Attachments to a testtrigger are correct now and have the correct format
            - Log messages rewritten
            - No free driveletter neccessary in the config (mounting IB Path for copy),
              choosing next free driveletter automatically beginning from "Z" backwards.
            - changed method for mounting a path to a driveletter
            - No more message that 'TCMGT_Macros.xls' was not closed correctly when opening excel again,
              which is running in the background of the ITL. Closing both workbooks at the end
            - Fixed issue that Filter-Buttons in the Result-Overview disappeared after import
            - some minor bugfixes during rewritting as class
    v1.01:  - A query in [void] GetTriggerName corrected  which decides if the 
              testtrigger starts with 'RCP_HIL_' or with "Setup_"
            - Getting full TestLabel out of Conf.txt and writing it in the step
              'CreateTestSuites' to the corresponding column of the TestTrigger -
              Attachments, if the column exists.
            - Corrected the reading of Conf.txt
              --> Python Extension, XIL-API and CRTITA are getting the the correct Version (DateTime)
#>
<# ------------------------------------------------------------------------------------------------------------ #>



#*** Import Windows Forms, Logging Class, CopyLatest Class, TestFoleders Class and GUICreator Class
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.Office.Interop.Excel")
Import-Module ($PSScriptRoot + "\Logging.psm1")
Import-Module ($PSScriptRoot + "\CopyLatest.psm1")
Import-Module ($PSScriptRoot + "\TestFolders.psm1")
Import-Module ($PSScriptRoot + "\GUICreator.psm1")

class ITL_Importer{
    [String] $cfgname = ""
    [Hashtable] $config = @{updateTS = "true"}
    [DateTime] $startTime
    [String] $testTrigger = ""
    [Array] $rowTestTrigger = ""
    [Array] $AddonMacros = @("SelectTests_TS_TRCGen", "MergeRepetitions_Silent")
    [Object] $sheet = @{Overview=@{}; Results=@{}}
    [String] $TSRevision = ""
    [String] $TSRevisionPrev = ""
    [Hashtable] $logConst = @{Main="ITL-Importer"}
    [Boolean] $newITL = $false
    [String] $MutexPath = [IO.Path]::Combine("\\dspace.de", "root", "PE", "Build", "_BuildTools", "MPM", "Tools", "ITLImport", "$($env:Computername).txt")
    
    $objTestFolders
    $excel
    $wbITL
    $GUI
    $InfoBox
    $log
    $importer
    
    <# ---- Constructor ----
    Parameters: 
        1. configfile (String) --> Path to a configfile generated with CreateSettings script to ensure correct parameters 
        2. debug (Boolean) --> Debug Modus will only read config and open ITL,
                               to give the possibility to go through functions step by step #>
    ITL_Importer([string] $configfile, [Boolean] $debug){
        $this.Start($configfile)
        if($debug -eq 0){
            $this.ImportToITL()
        }
        $this.importer = $this
    }
    
    <# ---- Init Functions---- #>
    [void] Start($configfile){
        #*** Init variables & acquire Config from configfile
        #$env:USERNAME | Out-File $this.MutexPath
		$this.CreateMutexFile()
        $this.GUI = New-GUICreator
        $this.cfgname = Split-Path $configfile -leaf
        $this.InfoBox = $this.ShowMassage("Acquire Config")
        $this.GetConfig($configfile)
        $this.startTime = Get-Date
        $error.Clear()
        $this.log.WriteInfo(("Import for test suite " + $this.config.TS + " has been started: " + $this.startTime),
                            $this.logConst.Main)
        
        #*** Acquire TestResults, define TestTrigger, create Backup of ITL-Workbook and Open ITL
        $this.AddTestResultFolders()
        $this.GetTestTrigger()
        $this.CreateITLBackup()
        $this.OpenITL()
        $this.ShowAllRowsAndColumns()
    }
	
	<# create mutex file #>
	[void] CreateMutexFile(){
		if ((Test-path $this.MutexPath) -eq $false) {
            New-Item $this.MutexPath -ItemType file
            $env:USERNAME | Out-File $this.MutexPath
        }
    }
	
	<# delete mutex file #>
	[void] DeleteMutexFile(){
		if (Test-path $this.MutexPath) {Remove-Item $this.MutexPath -Force}
    }
	
    <# Converts Config-Text-File to a hashtable and generates additional parameters #>
    [void] GetConfig($configfile){
        # Get gontent of configfile
        $cfgcontent = Get-Content $configfile
        
        # Add all parameters from configfile to the field 'config' (hashtable)
        foreach($content in $cfgcontent){
            if($content.contains("=")){
                $converted = ConvertFrom-StringData $content.replace("\", "\\")
                $this.config[[String] ($converted.keys)] = [String] ($converted.values)
            }
        }
        #*** Key testResultPrefixExclude is an Array and will be splitted with ","
        $this.config.testResultPrefixExclude = [Array] $this.config.testResultPrefixExclude.replace(", ",",").split(",")
        $this.config.testResultPrefixInclude = [Array] $this.config.testResultPrefixInclude
        
        # Get 'IB' if its set to get from aktuell.txt
        if($this.config.IB -like ""){
            $path = $this.config.pathIBRoot + "\aktuell.txt"
            $this.WaitForFile($path)
            $this.config.IB = Get-Content $path
        }
        # Set only the IB date to the key 'IB' if it is a path 
        if($this.config.IB.Contains("\")){
            $this.config.IB = Split-Path $this.config.IB -leaf
        }
        
        # Add the key with the full IB path for later use
        $this.config.pathFullIB = Join-Path ($this.config.pathIBRoot.replace("\aktuell.txt", "")) ($this.config.IB)
        # Add the key with the original 'TS' from the config
        $this.config.TS_cfg = $this.config.TS
        # Change the key 'TS' if it is 'TS_CRTITA' (ResultSheet needs that name)
        if($this.config.TS -eq "TS_CRTITA"){
            $this.config.TS = "CFD_IMPL_IB"
        }
        # Add the key 'pathData' with the path to the Data folder where the TestResults will be copied
        $this.config.pathData = (Split-Path (Split-Path $this.config.pathITL)) + "\Data"
        # Add the time to the logging textfile-name defined in the config
        $logTime = Get-Date -format "dd-MMM-yyyy"
        $logFileExtension = " - " + $logTime + ".txt"
        $this.config.pathLog = $this.config.pathLog -replace ".txt",$logFileExtension
        
        #Create new instants of Logging and log the Logging path and the config
        $this.log = New-Logging $this.config.pathLog
        $this.log.WriteInfo($this.config, ($this.logConst.Main, "Get Config", "Config"))
        $this.log.WriteEmptyLine()
        $this.log.WriteInfo("Logging Path: " + $this.config.pathLog, $this.logConst.Main)
        $this.log.WriteEmptyLine()
    }
    [void] AddTestResultFolders(){ 
        <#******************************************************************************************
        Acquire the TestResult-Folders for the configured ITL-Import by using the Class TestFolders
        ******************************************************************************************#>
        
        $this.log.WriteEmptyLine()
        $this.log.WriteStep("Getting TestResult-Folders", $this.logConst.Main)
        $this.log.WriteSeparatorLine()
        $this.EditGlobalMassage("Getting TestResult-Folders", 300)
        
        if($this.config.TS -like "" -or $this.config.IB -like "" -or $this.config.OS -like ""){
            $this.log.WriteError("CONFIG: TestSuite, IB and/or OS is wrong.", $this.logConst.Main)
            $this.ShowError("CONFIG: TestSuite, IB and/or OS is wrong.", 430)
        }
        
        $pathParent = Join-Path ($this.config.pathFullIB) "TestResults"
        if (!(Test-Path $pathParent)) {
            $this.log.WriteError("No result folders found for config.", $this.logConst.Main)
            $this.ShowError("No result folders for config.")
        }
        
        $this.objTestFolders = GetTestFolders $pathParent $this.config.pathLog
        
        $this.log.WriteEmptyLine()
        $this.log.WriteSeparatorLine()
        $this.log.WriteEmptyLine()
        
        $this.config.ResFolders = $this.objTestFolders.GetFolderNames($this.config.TS,
                                                                   $this.config.OS,
                                                                   $this.config.testResultPrefixExclude,
                                                                   $this.config.testResultPrefixInclude,
                                                                   $this.config.testResultPart) | Sort-Object
        
        if ($this.config.ResFolders.Length -eq 0) {
            $this.log.WriteError("No result folders found for config.", $this.logConst.Main)
            $this.ShowError("No result folders for config.")
        }
        
        $this.log.WriteSeparatorLine()
        $this.log.WriteEmptyLine()
        $this.log.WriteSeparatorLine()
        $this.log.WriteLog($this.config.ResFolders, ($this.logConst.Main, "Matching TestResult-Folders"))
        $this.log.WriteSeparatorLine()
    }
    [void] GetTestTrigger(){
        $this.EditGlobalMassage("Getting TestTrigger Config")
        $this.log.WriteEmptyLine()
        $this.log.WriteStep("Getting TestTrigger Config", $this.logConst.Main)
        $pathConfig = $this.config.pathIBRoot + "\" + $this.config.IB + "\TestResults\" + 
                      $this.config.ResFolders[0] + "\Conf.txt"
        $this.log.WriteInfo($pathConfig, ($this.logConst.Main, "TestTrigger Config-File"))
        $this.GetTriggerConf($pathConfig)
        $this.GetTriggerName($pathConfig)
        $this.log.WriteEmptyLine()
        if($this.testTrigger.Length -eq 0){
            $this.log.WriteError("Can't generate a TestTrigger Name. Define a name in the Config!", $this.logConst.Main)
            $this.ShowError("Can't generate a TestTrigger Name. Define a name in the Config!", 550, 125)
        }
    }
    [void] GetTriggerConf($pathConfig){
        <#**********************************************************************************************
        Get the trigger configuration from the given Conf.txt file  for the attachment to the trigger.
        **********************************************************************************************#>
        
        #*** Matlab, MEX, PyExt, XIL, CRTITA, RTLib, RTPC, TestLabel    
        $this.config.TriggerConfig = @{OS = $this.config.OS}
        foreach($key in @("Matlab", "MEX", "PyExt", "XIL", "CRTITA", "RTLib", "RTPC", "TestLabel")){
            $this.config.TriggerConfig[$key] = ""
        }
        $searchString = "Matlab=20*"
        $lines = Select-String -Path $pathConfig -Pattern $searchString
        if($lines.Length -gt 0){
            $this.config.TriggerConfig.Matlab = [regex]::split($lines[0].ToString(),'Matlab=20')[1].ToUpper()
        }
        
        $searchString = "MEX=*"
        $lines = Select-String -Path $pathConfig -Pattern $searchString
        if($lines.Length -gt 0){
            $this.config.TriggerConfig.MEX = [regex]::split($lines[0].ToString(),'MEX=')[1]
        }
        
        $searchString = "Python Extensions*"
        $lines = Select-String -Path $pathConfig -Pattern $searchString
        if($lines.Length -gt 0){
            $temp = [regex]::split($lines[0].ToString(),'\\')
            $tempindex = 0
            $tempi = 0
            foreach($t in $temp){
                try{
                    $b = [datetime]::ParseExact($t,"yyyy-MM-dd_HHmm",$null)
                    $tempi = $tempindex
                }
                catch{}
                $tempindex = $tempindex + 1
            }
            if($tempi -ne 0){
                $this.config.TriggerConfig.PyExt = $temp[$tempi-1] + "\" + $temp[$tempi]
            }
        }
        
        $searchString = "XILAPI.NET*"
        $lines = Select-String -Path $pathConfig -Pattern $searchString
        if($lines.Length -gt 0){
            $temp = [regex]::split($lines[0].ToString(),'\\')
            $tempindex = 0
            $tempi = 0
            foreach($t in $temp){
                try{
                    $b = [datetime]::ParseExact($t,"yyyy-MM-dd_HHmm",$null)
                    $tempi = $tempindex
                }
                catch{}
                $tempindex = $tempindex + 1
            }
            if($tempi -ne 0){
                $this.config.TriggerConfig.XIL = $temp[$tempi].ToString()
            }
        }
        
        $searchString = "CRTITA_Setup=*"
        $lines = Select-String -Path $pathConfig -Pattern $searchString
        if($lines.Length -gt 0){
            $tempSaD = $lines[0].ToString().split(@("Software_at_dSPACE\Dev\Test_Qual\CRTITA\"),
                                                  [System.StringSplitOptions]::RemoveEmptyEntries)
            if($tempSaD.length -gt 1){
                $this.config.TriggerConfig.CRTITA = [regex]::split($tempSaD[1],'\\')[0].replace("CRTITA_","")
            }
            else{
                $temp = [regex]::split($lines[0].ToString(),'\\')
                $tempindex = 0
                $tempi = 0
                foreach($t in $temp){
                    try{
                        $b = [datetime]::ParseExact($t,"yyyy-MM-dd_HHmm",$null)
                        $tempi = $tempindex
                    }
                    catch{}
                    $tempindex = $tempindex + 1
                }
                if($tempi -ne 0){
                    $this.config.TriggerConfig.CRTITA = $temp[$tempi].ToString()
                }
            }
        }
        
        $searchString = "RTLIB=*"
        $lines = Select-String -Path $pathConfig -Pattern $searchString
        if($lines.Length -gt 0){
            $temp = [regex]::split($lines[0].ToString(),'\\')
            $tempindex = 0
            $tempi = 0
            foreach($t in $temp){
                if($t.startsWith("v") -eq 0){
                    $tempi = $tempindex
                }
                $tempindex = $tempindex + 1
            }
            $this.config.TriggerConfig.RTLib = $temp[$tempi-1].ToString().substring(1)
        }
        
        $searchString = "TestLabel=*"
        $lines = Select-String -Path $pathConfig -Pattern $searchString
        if($lines.Length -gt 0){
            $this.config.TriggerConfig.TestLabel = [regex]::split($lines[0].ToString(),"=")[1]
            if($lines[0].ToString().Contains("RTPC")){
                $this.config.TriggerConfig.RTPC = [regex]::split($lines[0].ToString(),"RTPC")[1].substring(0,3)
            }
            else{
                $this.config.TriggerConfig.RTPC = "3.0"
            }
        }
        $this.log.WriteInfo($this.config.TriggerConfig, ($this.logConst.Main, "TestTrigger Config"))
    }
    [void] GetTriggerName($pathConfig){
        <#****************************************************************************************
        Get the trigger name from the given Conf.txt file. Notecing if there is a TriggerName
        in the ITL-Import-Config or just appending to the generated TriggerName.
        ****************************************************************************************#>

        [String] $this.testTrigger = ""
        if($this.config.triggername.StartsWith("++") -or ($this.config.triggername.length -eq 0)){
            $lines = Select-String -Path $pathConfig -Pattern "ServicePackPath=*"
            if($lines.length -gt 0){
                $lines = Split-Path ([regex]::split($lines[0].ToString(),"=")[1]) -leaf
                $index = $lines.IndexOf('SP')
                if($index -ne -1){
                    $this.testTrigger = [regex]::split($lines.Remove(0, $index), "\.")[0] + "_" + $this.config.OS.replace('-','_')
                }
                else{
                    $index = $lines.IndexOf('_P')
                    if($index -ne -1){
                        $this.testTrigger = [regex]::split($lines.Remove(0, ($index + 1)), "\.")[0] + "_" + $this.config.OS.replace('-','_')
                    }
                }
            }
            if($this.testTrigger -eq ""){
                $lines = Select-String -Path $pathConfig -Pattern "MSISetupPath=*"
                if($lines.length -gt 0){
                    $lsplit = [regex]::split($lines[0].ToString(),"=")
                    if($lsplit.length -gt 1){
                        $lines = $lsplit[1]
                        $lines -match "\d\d\d\d-\d\d-\d\d_\d\d\d\d"    
                        if($matches.length -gt 0){
                            $this.testTrigger = $matches[0].ToString().replace('-','_') + "_" + $this.config.OS.replace('-','_')
                            if($this.config.TS -eq "CFD_IMPL_IB"){
                                $this.testTrigger = "RCP_HIL_" + $this.testTrigger
                            }
                            else{
                                $this.testTrigger = "Setup_" + $this.testTrigger
                            }
                        }
                    }
                }
            }
            if($this.testTrigger -eq ""){
                $lines = Select-String -Path $pathConfig -Pattern "TestLabel=*"
                if($lines.length -gt 0){
                    $lsplit = [regex]::split($lines[0].ToString(),"=")
                    if($lsplit.length -gt 1){
                        $lines = $lsplit[1]
                        $ibshort = [regex]::split($this.config.pathIBRoot,'\\');
                        $ibshort = " IB" + $ibshort[$ibshort.length - 2]
                        $this.testTrigger = $lines -replace $ibshort,""
                        $this.testTrigger = $this.testTrigger -replace "/","_" 
                        $this.testTrigger = $this.testTrigger -replace ":","" 
                        $this.testTrigger = $this.testTrigger -replace "W764","W7" 
                        $this.testTrigger = $this.testTrigger -replace (" ML20" + $this.config.TriggerConfig.Matlab.toLower()),"" 
                        $this.testTrigger = $this.testTrigger -replace ($this.config.year + "_"),"" 
                        $this.testTrigger = $this.testTrigger -replace (" \(" + $this.config.testResultPart + "\)"),"" 
                        $this.testTrigger = $this.testTrigger -replace " ","_"
                    }
                }
            }
            if($this.testTrigger.length -ne 0){
                if($this.config.triggername.StartsWith("++")){
                    $this.testTrigger = $this.testTrigger + $this.config.triggername.substring(2)
                }
                if([convert]::ToInt32($this.config.testResultPart, 10) -gt 1){
                    $this.testTrigger = $this.testTrigger + "_" + $this.config.testResultPart
                }
            }
        }
        else{
            $this.testTrigger = $this.config.triggername
        }
        $this.log.WriteInfo(([Array] $this.testTrigger), ($this.logConst.Main, "Test-Trigger-Name"))
    }
    [void] CreateITLBackup(){
        $this.EditGlobalMassage("Creating ITL-Backup")
        $pathLog = (Split-Path $this.config.pathITL) + "\Backups\Backup - Log.txt"
        $this.log.WriteStep(("Creating ITL-Backup. LogFile: " + $pathLog), $this.logConst.Main)
        $backupDir = (Split-Path $this.config.pathITL) + "\Backups\"
        $backupFile = [regex]::split((Split-Path $this.config.pathITL -leaf),'.xlsb')[0] +
                      " - Backup " + (Get-Date -format "dd-MM HHmm") + ".xlsb"
        if(!(Test-Path $backupDir)){
            New-Item $backupDir -ItemType Directory
        }
        aCopyLatest -Source $this.config.pathITL -Destination ($backupDir + $backupFile) -pathLog $pathLog
    }
    [void] OpenITL(){
        #*** Get Excel Access and open ITL-Worksheet in Write-Mode (Wait for Write-Mode if ReadOnly)
        $this.EditGlobalMassage("Opening Excel and ITL")
        $this.log.WriteStep("Opening Excel and ITL", $this.logConst.Main)
        $this.excel = New-Object -ComObject Excel.Application
        $this.excel.Visible = $true
        $this.wbITL = $this.excel.Workbooks.Open($this.config.pathITL)
        $this.excel.displayAlerts = $false
        $this.WaitForITLAccess()
        $this.sheet.Overview = $this.wbITL.sheets | where {$_.name -eq "TestTriggerOverview"} 
        $this.sheet.Results = $this.wbITL.sheets | where {$_.name -eq ("ResultOverview_" + $this.config.TS)}
        if($this.sheet.Results -eq $null){
            $this.newITL = $true
        }
        $this.sheet.Overview.Activate()
        $this.excel.displayAlerts = $false
        $this.DeleteFilterDatabase()
    }
    [void] ShowAllRowsAndColumns(){
        if(!($this.newITL)){
            $this.EditGlobalMassage("Show all Rows and Columns")
            $this.log.WriteStep("Show all Rows and Columns", $this.logConst.Main)
            $last = $this.GetLastRowAndColumn()
            for($i = 1; $i -lt $last.Results.column; $i++){
                try{
                    $range = "B5:" + $this.sheet.Results.columns($last.Results.column).Address().split(":")[0] + "5"
                    $this.sheet.Results.range($range).AutoFilter()
                    $this.sheet.Results.range($range).AutoFilter(1)
                }
                catch{
                    $this.log.WriteFail("Failed to set AutoFilter", $this.logConst.Main)
                    $this.log.WriteFail($_, $this.logConst.Main)
                }
            }
            try{
                foreach($sheet in $last.keys){
                    for($i=1; $i -le $last[$sheet].row; $i++){
                        $this.sheet[$sheet].rows($i).Hidden = $false
                    }
                    for($i=1; $i -le $last[$sheet].column; $i++){
                        $this.sheet[$sheet].columns($i).Hidden = $false
                    }
                }
            }
            catch{
                $this.log.WriteError("Failed to show hidden Rows and Columns", $this.logConst.Main)
                $this.log.WriteError($_, $this.logConst.Main)
            }
        }
        else{
            $this.log.WriteInfo("This is a new ITL without TestTriggers", $this.logConst.Main)
        }
    }
    
    <# ---- Import Functions ---- #>
    [void] ImportToITL(){
        #*** Normal process for an ITL-Import like manuall with macros
        $this.AppendTestTrigger()
        $this.CreateMissingRepetitions()
        $this.CreateTestSuites()
        $this.CorrectRowTestTriggers()
        $this.log.WriteSeparatorLine()
        for ($repNum=0;$repNum -lt $this.config.ResFolders.Length; $repNum++){
            $this.log.WriteStep(("Assign TestSuite To Test Execution", "Set Test Selection", 
                                "Finish Test Configuration"),
                               ($this.logConst.Main,
                                ("Folder: " + $this.config.ResFolders[$repNum]),
                                ("Repetition-No.: " + $repNum)))
            $this.log.WriteSeparatorLine()
            $this.AssignTestSuiteToRepetition($repNum)
            $this.UpdateTestsuiteStructure($repNum)
            $this.SetTestSelections($repNum)
            $this.FinishTestConfiguration($repNum)
            $this.log.WriteSeparatorLine()
        }
        $this.CopyTestResults()
        $this.UpdateTestResults()
        $this.MergeRepetitions()
        $this.InputTestResponsible()

        $this.LogEnd()
        $this.ExitImporter()
    }
    [void] AppendTestTrigger(){
        <#*********************************************************
        Append new test trigger in ITL overview table with macro 
        *********************************************************#>

        $this.EditGlobalMassage(("Appending TestTrigger:`r`n" + $this.testTrigger), 450, 125)
        $this.log.WriteStep("Append TestTrigger: " + $this.testTrigger, $this.logConst.Main)
        
        $this.sheet.Overview.Activate()
        
        #*** Check if test trigger is alredy present in ITL
        $rowLast = $this.GetLastRowAndColumn().Overview.row
        $found = $this.sheet.Overview.range('C5:C'+$rowLast).find($this.testTrigger)
        if ($found.count -eq 1){
            $this.rowTestTrigger[0] = $found.row
            $this.log.WriteInfo("Test Trigger existing: " + $this.testTrigger, $this.logConst.Main)
        }
        else{
            $path = $this.config.pathData + "\" + $this.testTrigger
            if ((Test-Path -Path $path) -and ($this.testTrigger -ne "")){
                Remove-Item $path -Force -Recurse
            }
            if($this.RunMacro("TestTriggerConfigAppendNewTrigger_Silent", $this.testTrigger)){
                $rowLast = $this.GetLastRowAndColumn().Overview.row
                $this.rowTestTrigger[0] = $this.sheet.Overview.range('C5:C' + $rowLast).find($this.testTrigger).row
                $this.log.WriteInfo("New test trigger was appended: " + $this.testTrigger, $this.logConst.Main)
            }
            else{
                $this.log.WriteError("Error occured while appending TestTrigger", $this.logConst.Main)
                $this.ShowError("Error occured while appending TestTrigger", 430)
            }
        }
    }
    [void] CreateMissingRepetitions(){
        <#****************************************************
        Create Repetitions for all other testresult folders
        ****************************************************#>

        #*** Init
        $this.log.WriteStep("Create Repetitions", $this.logConst.Main)
        $this.log.WriteSeparatorLine()
        
        $this.sheet.Overview.Activate()
        
        $rescount = $this.config.ResFolders.Length - 1
        if($rescount -gt 0){
            $colTestTrigger = 3
            $colRepNum = 7
            $maxRepNum = $rescount
            $rowMarker = $this.GetLastRowAndColumn().Overview.row + 1

            #*** Find last Repetition mumber
            $lastRepNum = 0
            for ($i=1;$i -le $rescount; $i++){
                if ((!($this.sheet.Overview.cells($this.rowTestTrigger[0] + $i, $colTestTrigger).value2 -like "")) -or
                    (($this.rowTestTrigger[0] + $i) -eq $rowMarker)){
                    
                    #*** Either next test trigger or last row marker is reached.
                    $repNum = $this.sheet.Overview.cells($this.rowTestTrigger[0] + $i - 1, $colRepNum).value2
                    if ($repNum -match "\d"){
                        $lastRepNum = $repNum
                    }
                    else{
                        $this.log.WriteFail("Last repetitition number is not a numerical value.", $this.logConst.Main)
                    }
                    break
                }
            }
            #*** Create missing Repetitions
            $missRepNums = $maxRepNum - $lastRepNum
            for ($i=1;$i -le $missRepNums; $i++){
                $this.EditGlobalMassage("Creating Repetition for folder:`r`n" + $this.config.ResFolders[$i])
                $this.log.WriteStep((("Folder: " + $this.config.ResFolders[$i]), ("Repetition-No.: " + $i)), ($this.logConst.Main, "Create Repetition"))
                $this.sheet.Overview.cells($this.rowTestTrigger[0], $colTestTrigger).select()
                if($this.RunMacro("TestTriggerConfigNewRepetition")){
                    $this.log.WriteInfo("Repetition-No.: " + $i, ($this.logConst.Main, "Repetition created"))
                    $this.rowTestTrigger += ($this.rowTestTrigger[($i -1)] + 1)
                }
                else{
                    $this.log.WriteError("Repetition-No.: " + $i, ($this.logConst.Main, "Create Repetition"))
                    $this.ShowError("Error occured while creating Repetition", 430)
                }
            }
            $this.log.WriteSeparatorLine()
        }
    }
    [Int32] GetLastRowOfTestTrigger(){
        <#***************************************************************
        Description : Get last row of actual test trigger
        Output      : $this.rowLast (last row of actual test trigger)
        ***************************************************************#>

        $colTestTrigger = 3
        $rowMarker = $this.GetLastRowAndColumn().Overview.row + 1
        for ($i=1;$i -le 20; $i++){
            if ((!$this.sheet.Overview.cells($this.rowTestTrigger[0] + $i, $colTestTrigger).value2 -like "") -or
                ($this.rowTestTrigger[0] + $i -eq $rowMarker)){
                
                #*** Either next test trigger or last row marker is reached.
                return $this.rowTestTrigger[0] + $i - 1
            }
        }
        return $rowMarker
    }
    [String] GetRevision($pathRevFile){
        <#*********************************************************
        Get the test suite revisision from MKS_REVISION_DATA.txt 
        *********************************************************#>
        $searchString = "ProjectRevision"
        $lines = Select-String -Path $pathRevFile -Pattern $searchString
        $temp = [regex]::split($lines[0].ToString(),': ')
        $revision = [regex]::split($temp[$temp.Length - 1],' \$')[0]
        return $revision
    }
    [void] CreateTestSuites(){
        <#**********************************************************************************************
        Creates TestSuites for each Repetition and inserts the Trigger-Configuration to the attachments
        **********************************************************************************************#>

        $this.EditGlobalMassage("Creating TestSuite for`r`nTrigger and Repetitions")
        $this.log.WriteStep("Creating TestSuite " + $this.config.TS + " for Trigger and Repetitions", $this.logConst.Main)
        
        $this.sheet.Overview.Activate()
        
        #*** Init    
        $colRepNum = 7
        $colRepComment = 8
        $colTSLocation = 10
        $colTSRevision = 11 
        $defs = @{search = @{MIS = @{VM = "VM on vCenter vcsa-crti-ioc2"; OSBuild = "OS Build Version";
                                    MLPref = "MATLAB"; MLBuild = "ML Build"; Duration = "Duration"};
                             CRTITA = @{OS = "OS"; Matlab = "Matlab"; MEX = "MEX"; PyExt = "PyExt"; XIL = "Xil Api";
                                        CRTITA = "CRTITA"; RTLIB = "RTLIB"; RTPC = "RTPC"; TestLabel = "TestLabel"}};
                  columns = @{MIS = @{}; CRTITA = @{}}}
        
        #*** Search in Columns for attachment-names
        $this.log.WriteSeparatorLine()
        $this.log.WriteStep("Search in Columns for attachment-names", $this.logConst.Main)
        foreach($keyTS in $defs.search.keys){
            foreach($key in $defs.search[$keyTS].keys){
                $defs.columns[$keyTS][$key] = $this.sheet.Overview.rows(4).find($defs.search[$keyTS][$key]).column
                if($defs.columns[$keyTS][$key] -ne $null){
                    $this.log.WriteInfo((("Name: " + $key), ("Column: " + $defs.columns[$keyTS][$key])),
                                        ($this.logConst.Main, ("Attachment")))
                }
            }
        }
        $this.log.WriteSeparatorLine()

        #*** Call ITL macro for each test suite to be created
        if (($this.config.TS -like "TS_SIC_COMP") -or ($this.config.TS -like "TS_GLKoppl")){
            $path = $this.config.pathData + "\" + $this.testTrigger + "\0\" + $this.config.TS
            if (!(Test-Path -Path $path)){ #test suite is not yet existing
                $this.sheet.Overview.cells($this.rowTestTrigger[0], $colRepNum).select()
                if($this.RunMacro("TestTriggerConfigNewTestSuite_Silent", $this.config.TS)){
                    #*** Add test suite location
                    $path = $this.config.pathTestStructuresRoot + "\IB_" + $this.config.IB + "\" + $this.config.TS
                    $this.sheet.Overview.cells($this.excel.selection.Row, $colTSLocation).value2 = $path
                    
                    #*** Add test suite revisision
                    $path += "\" + "MKS_REVISION_DATA.txt"
                    $results = $this.GetRevision($path)
                    [string]$rev = $results[1]
                    $this.sheet.Overview.cells($this.excel.selection.Row, $colTSRevision).value2 = $rev

                    #*** Get folder name
                    $folderName = $this.config.ResFolders[0]

                    #*** Add VM name, OS build version, duration time to attachments
                    foreach($key in @("VM", "OSBuild", "Duration")){
                        if($defs.columns.MIS[$key] -ne $null){
                            $this.sheet.Overview.cells($this.excel.selection.Row,
                                                   $defs.columns.MIS[$key]).NumberFormat = "@"
                            $this.sheet.Overview.cells($this.excel.selection.Row,
                                                   $defs.columns.MIS[$key]).NumberFormatLocal = "@"
                            $this.sheet.Overview.cells($this.excel.selection.Row, $defs.columns.MIS[$key]).value2 = 
                                $this.objTestFolders.ResultsFolders[$folderName][$key]
                        }
                    }
                }
                else{
                    $this.log.WriteError("Repetition-No.: 0", ($this.logConst.Main, "Create TestSuite"))
                    $this.ShowError("Error occured while creating TestSuite", 430)
                }
            }
            else {
                $this.log.WriteInfo("No new test suite '" + $this.config.TS + "' for Repetition '0'" + 
                                    " has been created, because it is already existing.")
            }

        }
        elseif ($this.config.TS -eq "TS_TRCGen"){
            [Array] $tempResFolders = ""
            for ($repNum=0;$repNum -le $this.config.ResFolders.Length - 1; $repNum++){
                #*** Get folder name assigned to this Repetition
                $foldername = ""
                foreach ($ResFolder in $this.config.ResFolders){
                    if ($this.objTestFolders.ResultsFolders[$ResFolder].RepNum -eq $repNum){
                        $folderName = $ResFolder
                        break
                    }
                }
                if($repNum -eq 0){
                    $tempResFolders = $folderName
                }
                else{
                    $tempResFolders += $folderName
                }
                
                $path = $this.config.pathData + "\" + $this.testTrigger + "\" + $repNum + "\" + $this.config.TS
                if ((-not (Test-Path -Path $path)) -and ($folderName -ne "")){
                    $this.log.WriteStep("Creating new Test Suite for Repetition: " + $repNum + 
                                        " TestResult-Folder: " + $folderName)
                    #*** Select respective Repetition cell and call TCMGT macro
                    $found = $this.sheet.Overview.range("G" + $this.rowTestTrigger[0] + 
                                                        ":G" + $this.GetLastRowOfTestTrigger().ToString()).find($repNum)
                    if ($found.row -ne $null) {
                        $rowRep = $found.row
                        $this.sheet.Overview.cells($rowRep, $colRepNum).select()
                        if($this.RunMacro("TestTriggerConfigNewTestSuite_Silent", $this.config.TS)){
                            #*** Enter results folder name in Column "Repetition Comment"
                            $this.sheet.Overview.cells($this.excel.selection.Row,$colRepComment).value2 =
                                "TS_TRCGen folder: " + $folderName
                            $this.sheet.Overview.cells($this.excel.selection.Row,$colRepComment).Interior.Pattern = 1 # xlSolid

                            #*** Add test suite location & revision
                            $path = $this.config.pathTestStructuresRoot + "\IB_" + $this.config.IB + "\" + $this.config.TS
                            $this.sheet.Overview.cells($this.excel.selection.Row, $colTSLocation).value2 = $path
                            $path += "\T\" + "MKS_REVISION_DATA.txt"
                            $this.sheet.Overview.cells($this.excel.selection.Row, $colTSRevision).value2 =
                                $this.GetRevision($path)
                        
                            #*** Add VM name, OS build version, preferred MATLAB release,
                            #*** MATLAB build version, duration time to attachments
                            foreach($key in $defs.columns.MIS.keys){
                                if($defs.columns.MIS[$key] -ne $null){
                                    $this.sheet.Overview.cells($this.excel.selection.Row,
                                                           $defs.columns.MIS[$key]).NumberFormat = "@"
                                    $this.sheet.Overview.cells($this.excel.selection.Row,
                                                           $defs.columns.MIS[$key]).NumberFormatLocal = "@"
                                    $this.sheet.Overview.cells($this.excel.selection.Row, $defs.columns.MIS[$key]).value2 = 
                                        $this.objTestFolders.ResultsFolders[$folderName][$key]
                                }
                            }
                        }
                        else{
                            $this.log.WriteError("Repetition-No.: " + $repNum, ($this.logConst.Main, "Create TestSuite"))
                            $this.ShowError("Error occured while creating TestSuite", 430)
                        }
                    }
                    else{
                        $this.log.WriteFail("Cant create new Test Suite '" + $this.config.TS + "' for Repetition: " + $repNum)
                    }
                }
                else {
                    $this.log.WriteInfo("No new test suite '" + $this.config.TS + "' for Repetition '" + $repNum + 
                                        "' has been created, because it is already existing.")
                }
            }
            #*** Reconfigure result folders according to settings of the macro
            for ($repNum=0;$repNum -le $tempResFolders.Length - 1; $repNum++){
                if($repNum -eq 0){
                    [Array] $this.config.ResFolders = $tempResFolders[$repNum]
                }
                else{
                    $this.config.ResFolders += $tempResFolders[$repNum]
                }
            }
        }
        elseif (($this.config.TS -eq "CFD_IMPL_IB") -or ($this.config.TS -eq "CFD_TS")){
            for ($ttNum=0;$ttNum -le $this.config.ResFolders.Length - 1; $ttNum++){
                $path = $this.config.pathData + "\" + $this.testTrigger + "\"+ $ttNum + "\" + $this.config.TS
                if ((-not (Test-Path -Path $path))){
                    $this.log.WriteStep((("Folder: " + $this.config.ResFolders[$ttNum]), ("Repetition-No.: " + $ttNum)),
                                        ($this.logConst.Main, "Create TestSuite"))
                    $this.sheet.Overview.cells($this.rowTestTrigger[$ttNum], $colRepNum).select()
                    if($this.RunMacro("TestTriggerConfigNewTestSuite_Silent", $this.config.TS)){
                        $this.log.WriteStep("Setting location, revision and attachments to Repetition: " + $ttNum,
                                            ($this.logConst.Main, "Create TestSuite"))
                        #*** Add test suite location
                        $this.sheet.Overview.cells($this.excel.selection.Row,
                                                   $colTSLocation).value2 = $this.config.pathTestStructuresRoot +
                                                                            "\IB_" + $this.config.IB
                        #*** Add test suite revisision
                        $this.sheet.Overview.cells($this.excel.selection.Row,
                                                   $colTSRevision).value2 = "IB_" + $this.config.IB

                        #*** Add Test Trigger Config to attachments:
                        foreach($key in $defs.columns.CRTITA.keys){
                            if($defs.columns.CRTITA[$key] -ne $null){
                                $this.sheet.Overview.cells($this.excel.selection.Row,
                                                           $defs.columns.CRTITA[$key]).NumberFormat = "@"
                                $this.sheet.Overview.cells($this.excel.selection.Row,
                                                           $defs.columns.CRTITA[$key]).NumberFormatLocal = "@"
                                $this.sheet.Overview.cells($this.excel.selection.Row,
                                                           $defs.columns.CRTITA[$key]).value2 = $this.config.TriggerConfig[$key]
                            }
                        }
                        $this.log.WriteSeparatorLine()
                    }
                    else{
                        $this.log.WriteError("Repetition-No.: " + $ttNum, ($this.logConst.Main, "Create TestSuite"))
                        $this.ShowError("Error occured while creating TestSuite", 430)
                    }
                }
                else {
                    $this.log.WriteInfo("No new test suite '" + $this.config.TS + "' for Repetition '" + $ttNum + 
                                        "' has been created, because it is already existing.", $this.logConst.Main)
                }
            }
        }
        else {
            $this.log.WriteError("No or unknown test suite as input parammeter given.", $this.logConst.Main)
            $this.ShowError("No or unknown test suite as input parammeter given.", 500)
        }
        $this.log.WriteSeparatorLine()
    }
    [void] CorrectRowTestTriggers(){
        <#****************************************************************************************************************
        For MIS-TestSuites the position of the actual Repetition can move, because all TestSuites are in one TestTrigger.
        Because of this the positions saved in $this.rowTestTrigger have to be corrected.
        ****************************************************************************************************************#>
        if($this.config.TS -ne "CFD_IMPL_IB"){
            $this.log.WriteStep("Correct TestTrigger rows", $this.logConst.Main)
            for($i=0;$i -lt $this.rowTestTrigger.Length; $i++){
                $tempRep = ""
                for($j=0;$j -le ($this.GetLastRowOfTestTrigger() - $this.rowTestTrigger[0] + 1); $j++){
                    if($this.sheet.Overview.cells($this.rowTestTrigger[0]+$j,7).value2 -ne $null){
                        $tempRep = $this.sheet.Overview.cells($this.rowTestTrigger[0]+$j,7).value2
                    }
                    if(($tempRep -eq $i.ToString()) -and 
                       ($this.sheet.Overview.cells($this.rowTestTrigger[0]+$j,9).value2 -eq $this.config.TS)){
                            $this.rowTestTrigger[$i] = $j + $this.rowTestTrigger[0]
                    }
                }
            }
            $this.log.WriteInfo($this.rowTestTrigger, ($this.logConst.Main, "Test Trigger rows after correction"))
        }
        else{
            $this.log.WriteInfo($this.rowTestTrigger, ($this.logConst.Main, "Test Trigger rows"))
        }
    }
    [void] AssignTestSuiteToRepetition($repNum){
        <#********************************************************************
        Assign TestSuite selected in user inputs dialog to given Repetition
        ********************************************************************#>

        $colTS = 9
        $colTSStatus = 17
        
        #*** Activate TestTriggerOverview sheet
        $this.sheet.Overview.Activate()
                
        #*** Check if the Repetition for the TestTrigger is free to assign
        if (($this.sheet.Overview.cells($this.rowTestTrigger[$repNum],$colTS).value2 -eq $this.config.TS) -and 
            ($this.sheet.Overview.cells($this.rowTestTrigger[$repNum],$colTSStatus).value2 -eq "FREE")){
                $this.EditGlobalMassage("Assign TestSuite To Test Execution:`r`n" + $this.config.ResFolders[$repNum])
                
                #*** Select the TestSuite for correctly Run of the Macro and run the macro
                $this.sheet.Overview.cells($this.rowTestTrigger[$repNum], $colTS).select()
                
                if($this.RunMacro("TestTriggerConfigAssignTestSuiteToTestExecConfig")){
                    #*** Write finish message to console and log file
                    $this.log.WriteInfo("Repetition: " + $repNum, ($this.logConst.Main, "Test suite assigned"))
                }
                else{
                    $this.log.WriteError("Repetition: " + $repNum, ($this.logConst.Main, "Assign Test suite"))
                    $this.ShowError("Error occured while assigning Test Suite", 430)
                }
        }
        
        #*** After this Step there will be an ResultOverview 
        if($this.newITL){
            $this.sheet.Results = $this.wbITL.sheets | where {$_.name -eq ("ResultOverview_" + $this.config.TS)}
        }
        $this.newITL = $false
    }
    [void] GetTestSuiteRevision(){
        <#*************************************************************************************************
        Description : Get revision of test suite as is documented for actual test trigger.
        Output      : $this.TSRevision (revision of actual test suite)
        *************************************************************************************************#>
        $this.TSRevision = $this.sheet.Overview.cells($this.rowTestTrigger[0], 11).value2
        $this.log.WriteInfo($this.TSRevision, ($this.logConst.Main, "TS Revision"))
    }
    [void] GetTestSuiteRevisionPrevious(){
        <#*****************************************************************************************************
        Description : Read revision of test suite as is documented for previous test trigger.
        Output      : $this.TSRevisionPrev (revision of prvious test suite)
        *****************************************************************************************************#>
        
        #*** Init
        $rowFirst = 5
        $this.TSRevisionPrev = ""
        
        $rowLast = $this.rowTestTrigger[0] - 1
        if ($rowLast -lt $rowFirst) {
            $this.log.WriteFail("No previous TS Revision found", ($this.logConst.Main, "TS Revision Previous"))
            return
        }
        $rangeSearch = $this.sheet.Overview.range("I" + ($rowFirst - 1) + ":I" + $rowLast.ToString())
        
        $SearchOrder = New-Object Microsoft.Office.Interop.Excel.XlSearchOrder
        $SearchOrder = $SearchOrder::xlByRows
        $XlSearchDirection = New-Object Microsoft.Office.Interop.Excel.XlSearchDirection
        $XlSearchDirection = $XlSearchDirection::xlPrevious
        
        $default = [Type]::Missing
        $found = $rangeSearch.find($this.config.TS, $default, $default, $default, $SearchOrder, $XlSearchDirection)
        if ($found.row -ne $null){
            $this.TSRevisionPrev = $this.sheet.Overview.cells($found.row, 11).value2
        }
        $this.log.WriteInfo($this.TSRevisionPrev, ($this.logConst.Main, "TS Revision Previous"))
    }
    [String] getFreeDrive(){
        $letters = @("X", "W", "V", "U", "T", "S", "R", "Q", "P", "O", "N",
                     "M", "L", "K", "J", "I", "H", "G", "F", "E", "D", "C", "B", "A")
        foreach($letter in $letters){
            if(!(Test-Path ($letter + ":\"))){
                return $letter
            }
        }
        return ""
    }
    [void] ProvideTestStructure(){
        <#***********************************************************************************************
        Provide selected test suite in user inputs dialog with tests on special file system path for
        the selected IB in user inputs dialog. This file system repository is used for the
        build-up/update of the test structure of this test suite in respective ITL ResultOverview sheet. 
        ***********************************************************************************************#>
        $this.log.WriteStep("Provide TestSuite Structure", $this.logConst.Main)
        #*** Define Destination-Folder depending on TestSuite (Create Folder if not existing)
        $pathDestination = $this.config.pathTestStructuresRoot + "\IB_" + $this.config.IB
        if (!(Test-Path $pathDestination)){
            New-Item -ItemType Directory -Path $pathDestination -Force
        }
        else{
            $this.log.WriteInfo("TestSuite Structure is already existing at NetworkDrive", $this.logConst.Main)
            return
        }
        $ts = $this.config.TS
        if($ts -eq "CFD_IMPL_IB"){
            $ts = "TS"
        }
        elseif($ts -eq "CFD_TS"){
            $ts = "CFD_TS\AT"
        }
        else{
            $pathDestination += "\" + $ts
        }
        
        #*** Get Source Folder and map to a free Drive Letter
        $gl = ""
        if($this.config.TS -eq "TS_GLKoppl"){
            $gl = "TS\RtaSup\RtaCfg\"
        }
        $pathSource = $this.config.pathFullIB + "\BuildRoot\Release\TestSuite\" + $gl + $ts
        $freeDrive = $this.getFreeDrive()
        & 'subst.exe' ($freeDrive + ':') $pathSource
        $this.log.WriteInfo((("Folder: " + $pathSource), ("To Drive: " + $freeDrive + ":")),
                            ($this.logConst.Main, "Map Folder"))
        $pathSource = $freeDrive + ":"
        
        #*** Abort script if source path is not available
        if (!(Test-Path $pathSource)){
            $this.ShowError("Copying of test suite " + $this.config.TS + 
                            " could not be done,`r`nbecause path couldn't be mapped.", 550, 125)
        }
        
        #*** Start the Copy-Process
        $pathLog = $this.config.pathLog.replace(".log", " - File Copy.log").replace(".txt", " - File Copy.txt")
        $this.log.WriteStep("Start copying Test Structure. See LOG: " + $pathLog)
        $this.EditGlobalMassage(("Copying/Checking Test Structure`r`n" + $pathDestination), 550, 125)
        (robocopy.exe $pathSource $pathDestination /MIR /MT:8) | Out-File $pathLog
        #aCopyLatest -Source $pathSource -Destination $pathDestination -pathLog $pathLog
        
        #*** Unmap Drive again and write log / InfoBox
        $this.EditGlobalMassage("Finish copying Test Structure", 300, 100)
        $this.log.WriteInfo("Finished copying Test Structure for Test Suite: " + $this.config.TS)
        & 'subst.exe' ($freeDrive + ':') '/D'
        $this.log.WriteInfo($pathSource, ($this.logConst.Main, "UnMap Drive"))
    }
    [void] UpdateTestSuiteStructure($repNum){
        <#***************************************************************************************************************
        Update TestSuite structure if structure is not yet imported or if structure has changed compared to last import.
        And do the update, if necessary, only once.
        ****************************************************************************************************************#>
         
        if ($repNum -eq 0){
            if($this.config.updateTS.ToLower().CompareTo("true") -eq 0){
                $this.log.WriteSeparatorLine()
                $this.log.WriteSeparatorLine()
                #*** Update is only needed, if in sheet TestTriggerOverview in column
                #*** "TS Revision" no previous revision or a lower revision was found.
                $this.GetTestSuiteRevision() # --> $this.TSRevision
                $this.GetTestSuiteRevisionPrevious() # --> $this.TSRevsionPrev
                if (($this.TSRevision -gt $this.TSRevisionPrev) -or !(Test-Path ($this.config.pathTestStructuresRoot + "\IB_" + $this.config.IB))){
                    $this.log.WriteInfo("TS Revision is not equal", $this.logConst.Main)
                    $this.ProvideTestStructure()
                    $this.EditGlobalMassage("Update TestSuite Structure", 300, 100)
                    $this.log.WriteStep("Update structure of test suite " + $this.config.TS, $this.logConst.Main)
                    $this.sheet.Results.Activate()
                    if($this.RunMacro("TestResultOverviewTSStructureUpdate_Silent")){
                        $this.log.WriteInfo("Update structure of test suite " + $this.config.TS + " finished.",
                                            $this.logConst.Main)
                        Start-Sleep -Seconds 10
                    }
                    else{
                        $this.log.WriteError("Error occured", ($this.logConst.Main, "Update structure of test suite"))
                        $this.ShowError("Error occured while updating structure of test suite", 430)
                    }
                }
                else{
                    $this.log.WriteInfo("TS Revision is equal to the previous one,
                             Skipping Update of TestSuite Structure", $this.logConst.Main)
                }
                $this.log.WriteSeparatorLine()
                $this.log.WriteSeparatorLine()
            }
            else{
                $this.log.WriteInfo("Skipping Update of TestSuite Structure", $this.logConst.Main)
            }
        }
    }
    [void] SetTestSelections($repNum){
        <#********************************************************************************************************
        Set test selection for selected test suite on respective ResultOverview sheet for the given Repetition.    
        #*******************************************************************************************************#>

        $colSelection = 2
        $colTest = 10
        $rowRepetition = 3
        
        $this.EditGlobalMassage(("Set Test Selections:`r`n" + $this.config.ResFolders[$repNum]), 450, 125)
            
        $this.sheet.Results.Activate()

        #*** Reset any auto filters so that all tests are visible
        #$this.sheet.Results.UsedRange.AutoFilter(14) >> $null

        if($this.config.TS -ne "TS_TRCGen"){
            if(!($this.RunMacro("TestExecutionConfigResetTestSelection"))){
                $this.log.WriteError("Repetition: " + $repNum, ($this.logConst.Main, "Set Test Selections"))
                $this.ShowError("Error occured while setting Test Selections", 430)
            }
        }
        
        switch ($this.config.TS){
            "TS_GLKoppl"{
                #*** Deselect followng tests: at_tc00015, 16, 17, 21, 22, and 23
                $tests = @(15, 16, 17, 21, 22, 23)
                foreach ($test in $tests){
                    $found = $this.sheet.Results.columns($colTest).find("at_tc000" + $test.ToString())
                    $this.sheet.Results.cells($found.row,$colSelection).value2 = ""
                }
            }
            "TS_SIC_COMP"{
                #*** Deselect followng tests: all scenarios for TC00016 and TC00020
                $tests = @(16, 20)
                foreach ($test in $tests){
                    $found = $this.sheet.Results.columns($colTest).find("at_TC000" + $test.ToString())
                    if (-not ($found -eq $null)){
                        $rowFirst = $found.row
                        $this.sheet.Results.cells($found.row,$colSelection).value2 = ""
                        do{
                            $found = $this.sheet.Results.columns($colTest).findNext($found)
                            if ($found -eq $null){
                                break
                            }
                            else{
                                $this.sheet.Results.cells($found.row,$colSelection).value2 = ""
                            }
                        }
                        while ((-not ($found -eq $null)) -and ($found.row -ne $rowFirst))
                    }
                }
            }
            "TS_TRCGen"{
                #*** Call special TS_TRCGen selection macro with Repetition number based test type as input.
                if ($repNum -eq $this.sheet.Results.cells($rowRepetition,$colSelection).value2){
                    $repTypes = @{
                        0 = 'Component DS1005'
                        1 = 'Component DS1006'
                        2 = 'Component DS1007'
                        3 = 'Component SCALEXIO'
                        4 = 'functional'}
                    $repArg = $repNum.ToString() + " - " + $repTypes[$repNum]  
                    if(!($this.RunMacro("SelectTests_TS_TRCGen", $repArg))){
                        $this.log.WriteError("Repetition: " + $repNum, ($this.logConst.Main, "Set Test Selections"))
                        $this.ShowError("Error occured while setting Test Selections", 430)
                    }
                }
                else{
                    $this.log.WriteFail("Repetition number for test suite " + $this.config.TS + " is not as expected.")
                }
            }
        }
        $this.log.WriteInfo("Repetition: " + $repNum, ($this.logConst.Main, "Test Selection set"))
    }
    [void] FinishTestConfiguration($repNum){
        <#********************************************************************************************************************
        Finish test configuration for a test suite with already selected tests, so that test results can be imported/updated.
        ********************************************************************************************************************#>

        $colConfigStatus = 17
        
        if (($this.sheet.Overview.cells($this.rowTestTrigger[$repNum],$colConfigStatus).value2 -eq "ASSIGNED")){
            $this.EditGlobalMassage("Finish Test Configuration:`r`n" + $this.config.ResFolders[$repNum])
            #*** Activate respective ResultOverview sheet and write start log message.
            $this.sheet.Results.Activate()
            
            if($this.RunMacro("TestExecutionConfigFinishTestConfigStep_Silent")){
                $this.log.WriteInfo("Repetition: " + $repNum,
                                    ($this.logConst.Main, "Finish Test Configuration", "Finished"))
            }
            else{
                $this.log.WriteError("Repetition: " + $repNum, ($this.logConst.Main, "Finish Test Configuration"))
                $this.ShowError("Error occured while finishing Test Configuration", 430)
            }
        }
    }
    [void] CopyResultItems($repNum){
        <#******************************************************************************************
        Copy all items of a test results folder to the respective Repetition of actual test trigger.
        ******************************************************************************************#>

        $pathTestTrigger = $this.config.pathData + "\" + $this.testTrigger + "\" + $repNum + "\" + $this.config.TS + "\ATC\"
        $pathLog = $this.config.pathLog.replace(".log", " - File Copy.log").replace(".txt", " - File Copy.txt")
        
        #*** Write start message to console and log file
        $this.log.WriteStep((("Folder: " + $this.config.ResFolders[$repNum]), ("Repetition-No.: " + $repNum)),
                             ($this.logConst.Main, "Copy Test Results"))
        
        #*** Copy html report
        $pathDestination = $pathTestTrigger + "Report"
        $pathSource = $this.config.pathFullIB + "\TestResults\" + $this.config.ResFolders[$repNum]
        (robocopy.exe $pathSource $pathDestination /MIR /MT:8) | Out-File $pathLog -Append
        #aCopyLatest -Source $pathSource -Destination $pathDestination -pathLog $pathLog
        
        #*** Copy result data
        $pathDestination = $pathTestTrigger + "ResData"
        $pathSource = $pathSource + "\Result"
        (robocopy.exe $pathSource $pathDestination /MIR /MT:8) | Out-File $pathLog -Append
        #aCopyLatest -Source $pathSource -Destination $pathDestination -pathLog $pathLog
        $this.log.WriteSeparatorLine()
    }
    [void] CopyTestResults(){
        <#*****************************************************************************************************************
        Copy test results of of all selected IB results folders of selected test suite to respective test trigger folders.
        *****************************************************************************************************************#>
        
        $pathLog = $this.config.pathLog.replace(".log", " - File Copy.log").replace(".txt", " - File Copy.txt")
        $this.log.WriteSeparatorLine()
        $this.log.WriteStep("See LOG: " + $pathLog, ($this.logConst.Main, "Copy Test Results"))
        $this.log.WriteSeparatorLine()
        
        # $pathSource = Join-Path ($this.config.pathFullIB) "TestResults"
        # $freeDrive = $this.getFreeDrive()
        # & 'subst.exe' ($freeDrive + ':') $pathSource
        # $this.log.WriteInfo((("Folder: " + $pathSource), ("To Drive: " + $freeDrive + ":")),
                            # ($this.logConst.Main, "Map Folder"))
        # $freeDriveData = $this.getFreeDrive()
        # & 'subst.exe' ($freeDriveData + ':') $this.config.pathData
        # $this.log.WriteInfo((("Folder: " + $this.config.pathData), ("To Drive: " + $freeDriveData + ":")),
                            # ($this.logConst.Main, "Map Folder"))
                            
        if ($this.config.TS -eq "TS_TRCGen"){
            #*** Loop throuh all results folders and do the copying for the corresponding Repetition
            foreach ($ResFolder in $this.config.ResFolders){
                #*** Get Repetition number
                $repNum = $this.objTestFolders.ResultsFolders[$ResFolder].RepNum

                #*** Copy all items of test results folder
                $this.EditGlobalMassage("Copying Result-Folder:`r`n" + $ResFolder)
                $this.CopyResultItems($repNum)
            }
        }
        else{
            #*** Loop throuh all results folders and do the copying for the corresponding Repetition
            #*** Copy all items of test results folder
            for ($repNum=0;$repNum -lt $this.config.ResFolders.Length; $repNum++){
                $this.EditGlobalMassage("Copying Result-Folder:`r`n" + $this.config.ResFolders[$repNum])
                $this.CopyResultItems($repNum)
            }
        }
        $this.log.WriteInfo($pathLog, ($this.logConst.Main, "Copy Test Results", "Finished"))
        $this.log.WriteSeparatorLine()
    }
    [Object] GetLastRowAndColumn(){
        <# Get last row and column of both sheets #>
        $returning = @{Overview=@{row=0; column=0}; Results=@{row=0; column=0}}
        try{
            for($i=2; $i -lt 50; $i++){
                if($this.sheet.Overview.cells(2, $i).Interior.ColorIndex -ne 40){
                    $returning.Overview.column = $i - 1
                    break
                }
            }
            $returning.Overview.row = $this.sheet.Overview.columns(2).find("DATA_AREA_END_ROW").row - 1
            if(!($this.newITL)){
                $returning.Results.row = $this.sheet.Results.columns(2).find("DATA_AREA_END_ROW").row - 1
                $returning.Results.column = $this.sheet.Results.rows(1).find("DATA_AREA_END_COL").column - 1
            }
        }
        catch{
            $this.log.WriteError("GetLastRowAndColumn", $this.logConst.Main)
            $this.log.WriteError($_, $this.logConst.Main)
        }
        return $returning
    }
    [Object] FindTestTriggerColumns(){
        $returning = @{first=0; last=0}
        $found = $this.sheet.Results.rows(2).find($this.testTrigger)
        
        if ($found -ne $null){
            $returning.first = $found.column
            # Find the last column belonging to this test trigger. This last column can be identified as the column
            # before the previous test trigger (to the right) or the marker for the last column DATA_AREA_END_COL.
            for ($col=$returning.first+1; $col -le $this.GetLastRowAndColumn().Results.column; $col++){
                $cellvalue = $this.sheet.Results.cells(2,$col).value2
                if (($cellvalue -ne "") -and ($cellvalue -ne $null) -and ($cellvalue -ne $this.testTrigger)){
                    break
                }
            }
            $returning.last = $col - 1
        }
        return $returning
    }
    [void] UpdateResultsOfOneRepetition($repNum){
        <#********************************************************************************
        Update results in ResultOverview sheet for one selected Repetition via TCMGT macro.
        ********************************************************************************#>

        $TestTriggerColumn = $this.FindTestTriggerColumns()
        
        #*** Select the right field containing the given Repetition number of actual test trigger
        #*** and call the TCMGT macro for updating the test results.
        $start = $this.sheet.Results.cells(3,$TestTriggerColumn.first).Address()
        $end = $this.sheet.Results.cells(3,$TestTriggerColumn.last).Address()
        $found = $this.sheet.Results.range($start + ":" + $end).find($repNum)
        
        if ($found -ne $null){
            $colRepetition = $found.column
            $SummaryResult = $this.sheet.Results.cells(4,$colRepetition).value2
            if (($SummaryResult -eq 'P') -or ($SummaryResult -eq 'F')){
                $this.log.WriteInfo("Results for Repetition" + $repNum  + "are already updated.",
                                    ($this.logConst.Main, "Update Test Results"))
            }
            else{
                $this.sheet.Results.cells(3,$colRepetition).select()

                $this.log.WriteStep((("Folder: " + $this.config.ResFolders[$repNum]), ("Repetition-No.: " + $repNum)),
                                    ($this.logConst.Main, "Update Test Results"))
                $this.log.WriteStep("Updating test results for Repetition " + $repNum)

                if($this.RunMacro("TestResultOverviewResultUpdate_Silent")){
                    $this.log.WriteInfo("Repetition-No.: " + $repNum,
                                        ($this.logConst.Main, "Update Test Results", "Finished"))
                }
                else{
                    $this.log.WriteError("Repetition-No.: " + $repNum, ($this.logConst.Main, "Update Test Results"))
                    $this.ShowError("Error occured while updating Test Results", 430)
                }
            }
        }
        else{
            $this.log.WriteFail((("Folder: " + $this.config.ResFolders[$repNum]), ("Repetition-No.: " + $repNum)),
                                ($this.logConst.Main, "Update Test Results", "Missing Repetition"))
        }
    }
    [void] UpdateTestResults(){
        <#********************************************************************************************
        Import all test suite results stored on file system in the test trigger/Repetitions structure
        into ITL and update respective ResultOverview sheet.
        ********************************************************************************************#>
        $this.log.WriteSeparatorLine()
        $this.log.WriteStep("Start", ($this.logConst.Main, "Update Test Results"))
        $this.log.WriteSeparatorLine()
        $this.sheet.Results.Activate()
        for ($repNum=0;$repNum -lt $this.config.ResFolders.Length; $repNum++){
            $this.EditGlobalMassage("Updating Test Results:`r`n" + $this.config.ResFolders[$repNum])
            $this.UpdateResultsOfOneRepetition($repNum)
        }
        $this.log.WriteSeparatorLine()
    }
    [void] MergeRepetitions(){
        <#***************************************************************
        Merge all Repetition result columns of the actual test trigger.
        ***************************************************************#>

        if (($this.config.TS -eq "TS_TRCGen") -or ($this.config.TS -eq "CFD_IMPL_IB") -or ($this.config.TS -eq "CFD_TS")){
            $this.log.WriteSeparatorLine()
            
            #*** Activate respective ResultOverview sheet.
            $this.sheet.Results.Activate()
            
            #*** Init
            $TestTriggerColumn = $this.FindTestTriggerColumns()
            $rowRepetition = 3

            #*** Select all fields in Repetition row (3) in all columns belonging
            #*** to the actual test trigger, including columns "Tester" and "Comment". 
            $start = $this.sheet.Results.cells(3,$TestTriggerColumn.first).Address()
            $end = $this.sheet.Results.cells(3,$TestTriggerColumn.last).Address()
            
            #*** Start merging only if Repetitions are not yet merged.
            if ($this.sheet.Results.range($start + ":" + $end).columns.count() -le 3){
                $this.log.WriteInfo("Merging for test suite " + $this.config.TS + 
                                    " is not started because there is only one Repetition.",
                                    ($this.logConst.Main, "Merging all Repetitions", ("TestTrigger: " + $this.testTrigger)))
            }
            else{
                #*** Write start message to console and log file
                $this.log.WriteStep("TestTrigger: " + $this.testTrigger, ($this.logConst.Main, "Merging all Repetitions"))
                $this.wbITL.Save()
                $this.CreateITLBackup()
                $this.EditGlobalMassage("Merging Repetitions", 300, 100)
                
                $this.sheet.Results.range($start + ":" + $end).select()
                
                if($this.RunMacro("MergeRepetitions_Silent")){
                    Start-Sleep -s 20
                    if((($this.config.TS -eq "CFD_IMPL_IB") -or ($this.config.TS -eq "CFD_TS")) -and ($this.rowTestTrigger.Length -gt 1)){
                        $this.sheet.Overview.Activate()
                        try{
                            $this.sheet.Overview.range('B' + $this.rowTestTrigger[1] + ':B' + 
                                                   $this.rowTestTrigger[$this.rowTestTrigger.Length - 1]).EntireRow.Delete()
                        }
                        catch{
                            $this.log.WriteFail("Couldnt delete Repetition-Rows in Overview-Sheet",
                                                ($this.logConst.Main, "Merging all Repetitions"))
                        }
                    }
                    $this.log.WriteInfo("Finished", ($this.logConst.Main, "Merging all Repetitions"))
                }
                else{
                    $this.log.WriteError("Error occured", ($this.logConst.Main, "Merging all Repetitions"))
                    $this.ShowError("Error occured while merging all repetitions", 430)
                }
            }
            $this.log.WriteSeparatorLine()
        }  
    }
    [void] InputTestResponsible(){
        <#****************************************************************************************
        Inputs TestResponsible to a failed test. There are fixed testers for the MIS-TestSuites.
        For the CRTITA TestSuite are many different tester,
        so they will be acquired by comparing with the TestResponsible-ExcelWorkbook
        ****************************************************************************************#>

        $this.EditGlobalMassage("Inserting Test Responsibles")
        
        #*** Activate respective ResultOverview sheet.
        $this.sheet.Results.Activate()
        $this.log.WriteSeparatorLine()
        
        #*** Init
        $rowLast = $this.sheet.Results.columns(2).find("DATA_AREA_END_ROW").row - 1
        $columnTT = $this.sheet.Results.rows(2).find($this.testTrigger).column
        $columnTester = $columnTT + 1
        $globaltestpath = ""
        $tester = ""
        [Array] $testers = ""
        $trpath = "R:\PE\Testdata\WRV\" + 
                  "CRTITA4Import\sharedData\CRTITA-ConfigurationDesk_IMPL-Testverantwortliche.csv"
        $trsheetname = "CRTITA-ConfigurationDesk_IMPL-T"
        $this.log.WriteStep("TestTrigger: " + $this.testTrigger,
                            ($this.logConst.Main, "Writing Test Responsibles"))
        $this.log.WriteSeparatorLine()
        if($columnTT -ne $null){
            $this.log.WriteInfo(("TestTrigger-Column: " + 
                                [regex]::split($this.sheet.Results.cells(2,$columnTT).Address(),'\$')[1]),
                               ($this.logConst.Main, "Writing Test Responsibles"))
            switch ($this.config.TS){
                "TS_GLKoppl"{ $tester = "MatthiasW" }
                "TS_SIC_COMP"{ $tester = "MahmoudA" }
                "TS_TRCGen" { $tester = "MahmoudA" }
                "CFD_TS"{
                    $trpath = "R:\PE\Testdata\WRV\" + 
                              "CRTITA4Import\sharedData\CRTITA-ConfigurationDesk_IMPL_GIT-Testverantwortliche.csv"
                    $trsheetname = "CRTITA-ConfigurationDesk_IMPL_G"
                }
            }
            if(@("TS_GLKoppl", "TS_SIC_COMP", "TS_TRCGen").contains($this.config.TS)){
                for($i=6; $i -le $rowLast; $i++){
                    $color = $this.sheet.Results.cells($i,10).Interior.ColorIndex
                    $result = $this.sheet.Results.cells($i,$columnTT).value2
                    if(($color -eq -4105) -and ($result -eq "F")){
                        $testpath = $globaltestpath + "\" + $this.sheet.Results.cells($i,10).value2
                        $this.log.WriteStep((("Path to failed test: " + $testpath),
                                            ("Row: " + $i),
                                            ("Tester: " + $tester)),
                                           ($this.logConst.Main, "Writing Test Responsibles", "Setting Tester"))
                        $this.sheet.Results.cells($i, $columnTester).value2 = $tester
                    }
                }
            }
            if(@("CFD_IMPL_IB", "CFD_TS").contains($this.config.TS)){
                $this.log.WriteInfo("Test Responsibles File: " + $trpath,
                                   ($this.logConst.Main, "Writing Test Responsibles"))
                $wbTV = $this.excel.Workbooks.Open($trpath)
                $TVOverview = $wbTV.sheets | where {$_.name -eq $trsheetname}
                for($i=6; $i -le $rowLast; $i++){
                    $color = $this.sheet.Results.cells($i,10).Interior.ColorIndex
                    $result = $this.sheet.Results.cells($i,$columnTT).value2
                    if($color -eq 40){
                        $globaltestpath = $this.sheet.Results.cells($i,10).value2
                    }
                    if(($color -eq -4105) -and ($result -eq "F")){
                        $testpath = $globaltestpath + "\" + $this.sheet.Results.cells($i,10).value2
                        $rowTester = $TVOverview.columns(1).find($testpath).row
                        $tester = ""
                        if($rowTester -ne $null){
                            $tester = $TVOverview.cells($rowTester,2).value2
                            $this.log.WriteStep((("Path to failed test: " + $testpath),
                                                ("Row: " + $i),
                                                ("Tester: " + $tester)),
                                               ($this.logConst.Main, "Writing Test Responsibles", "Setting Tester"))
                            $this.sheet.Results.cells($i,$columnTester).value2 = $tester
                            if(!$testers.Contains($tester)){
                                if($testers[0] -eq ""){[Array] $testers = $tester}
                                else{$testers += $tester}
                            }
                        }
                        else{
                            $this.log.WriteFail("Path to failed test: " + $testpath,
                                               ($this.logConst.Main, "Writing Test Responsibles", "NOT FOUND"))
                        }
                    }
                }
                foreach($t in $testers){
                    Out-File -FilePath ((Split-Path $this.config.pathLog) + "\Testers.txt") -InputObject $t -Append
                }
                $this.log.WriteInfo("Saved file with Testers occured: " + 
                                    ((Split-Path $this.config.pathLog) + "\Testers.txt"),
                                    ($this.logConst.Main, "Writing Test Responsibles"))
                $wbTV.close($false)
            }
        }
        else{
            $this.log.WriteFail("TestTrigger: " + $this.testTrigger,
                                ($this.logConst.Main, "Writing Test Responsibles", "NOT FOUND"))
        }
        $this.log.WriteSeparatorLine()
        $this.log.WriteInfo("Finished", ($this.logConst.Main, "Writing Test Responsibles"))
    }
    [void] LogEnd(){
        $this.EditGlobalMassage("Finishing")
        $this.log.WriteSeparatorLine()
        $timeSpan = New-TimeSpan -Start $this.startTime -End (Get-Date)
        $textTime = "{0} hours {1} minutes {2} seconds." -f $timeSpan.Hours, $timeSpan.Minutes, $timeSpan.Seconds
        $this.log.WriteInfo("Import for test suite " + $this.config.TS + " has been finished with execution time of " + 
                            $textTime, $this.logConst.Main)
    }
    [void] ExitImporter($save){
        #*** Save ITL-Workbook, close InfoBox, exit excel and exit this powershell-script
        $this.log.WriteStep("Closing ITL, Excel and Importer", $this.logConst.Main)
        if($this.excel -ne $null){
            if($this.wbITL -ne $null){
                $this.wbITL.close($save) 
            }
            foreach($window in $this.excel.Windows){
                $window.close($false)
            }
            $this.excel.quit()
        }
        spps -n excel
        $this.InfoBox.Close()
        $this.InfoBox.Dispose()
        $this.DeleteMutexFile()
        $this.log.WriteStep("Finished", $this.logConst.Main)
        exit
    }
    [void] ExitImporter(){
        $this.ExitImporter($true)
    }
    
    <# ---- Other Functions ---- #>
    [void] AskContinue(){
        Write-Host
        Write-Host "Continue? (y/n): " -ForegroundColor Green -NoNewline
        $Continue = Read-Host
        if (-not ($Continue -eq 'y')) {Exit}
    }
    [void] WaitForFile($file){
        $shortname = Split-Path $file -leaf
        $shortpath = Split-Path $file
        $shortpath2 = Split-Path $shortpath -leaf
        $shortpath = Split-Path $shortpath
        $shortpath1 = Split-Path $shortpath -leaf
        $this.EditGlobalMassage(("Waiting for file: " + $shortpath1 + "\" + $shortpath2 + "\" + $shortname), 400)
        while(![System.IO.File]::Exists($file)){
            $this.log.WriteLog("File $file does not exist... waiting for file", "Waiting")
            Start-Sleep -Seconds 10
        }
    }
    [void] WaitForITLAccess(){
        <#******************************************************************************************
        Waiting for Write-Access for the ITL-Workbook if its ReadOnly and showing it in the InfoBox
        ******************************************************************************************#>
        if($this.wbITL.ReadOnly -eq $True){
            $ReadOnly = $True
            $this.EditGlobalMassage("ITL is ReadOnly, waiting for ITL Access...", 400)
            $this.log.WriteInfo("ITL is ReadOnly, waiting for ITL Access...", $this.logConst.Main)
            while ($ReadOnly){
                Start-Sleep -Seconds 30
                $this.wbITL = $this.excel.Workbooks.Open($this.config.pathITL, $null, $false)
                if($this.wbITL.ReadOnly -eq $False){
                    $ReadOnly = $False
                }
                else{
                    $this.wbITL.close($false)
                }
            }
        }
    }
    [Boolean] RunMacro($macro, $param){
        <# Run macro with try catch #>
        $macrofile = "TCMGT_Macros.xls"
        $macromodule = "TCMGTPublicMacros"
        if($this.AddonMacros.contains($macro)){
            $macromodule = "TCMGTAddOn"
        }
        $macro = $macrofile + '!' + $macromodule + '.' + $macro
        $this.log.WriteStep((("Macro: " + $macro), ("Parameters: " + $param)), ($this.logConst.Main, "Run Macro"))
        if($param -ne ""){
            try{
                $this.excel.Run($macro, $param)
            }
            catch{
                $this.log.WriteError($_, $this.logConst.Main)
                return $false
            }
        }
        else{
            try{
                $this.excel.Run($macro)
            }
            catch{
                $this.log.WriteError($_, $this.logConst.Main)
                return $false
            }
        }
        $this.DeleteFilterDatabase()
        return $true
    }
    [Boolean] RunMacro($macro){
        return $this.RunMacro($macro, "")
    }
    [void] DeleteFilterDatabase(){
        <#********************************************************************************
        Deletes any filter with name "_FilterDatabase" from ResultOverview sheet
        of selected test suite, because this would cause trouble during script execution. 
        ********************************************************************************#>
        try{
            $filter = "ResultOverview_" + $this.config.TS + "!" + "_FilterDatabase"
            foreach ($item in $this.wbITL.names){
                if ($item.name -eq $filter){
                    $item.delete()
                }
            }
        }
        catch{
            $this.log.WriteError($_, $this.logConst.Main)
        }
    }
    [Object] ShowMassage([String] $message, [Int32] $width, [Int32] $height, [Boolean] $iserror){
        <#**************************************************
        Creates an InfoBox with the help of the GUICreator
        **************************************************#>
        
        if($width -eq 0){
            $width = 300
        }
        if($height -eq 0){
            $height = 100
        }
        
        if($iserror){
            $this.InfoBox.Close()
            $this.InfoBox.Dispose()
            #$this.log.WriteError($message, ($this.logConst.Main, "Info-Box"))
        }
        else{
            #$this.log.WriteInfo($message, "Info-Box")
        }

        $this.GUI.CreateSysObject("Form",
                                  "Info",
                                  @{Size = ($width.ToString()+","+$height.ToString());
                                    Text = ("Info - " + $this.cfgname);
                                    Topmost = $true;
                                    MaximizeBox = $False;
                                    FormBorderStyle = "FixedDialog";
                                    Location = "20,20"
                                    })#;StartPosition = "CenterScreen"
        $this.GUI.CreateSysObject("Label",
                                  "Info",
                                  @{Location= '10,20';
                                    Size = (($width - 36).ToString()+","+($height - 76).ToString());
                                    Font = "Microsoft Sans Serif, 14";
                                    Text = $message;
                                    TextAlign = "MiddleCenter"},
                                  "Info")
            
        if($iserror){
            $this.GUI.SysObjects.Form.Info.Text = "Error - " + $this.cfgname
            $this.GUI.SysObjects.Form.Info.Size = ($width.ToString()+","+($height + 42).ToString())
            $temp = New-Object System.Windows.Forms.DialogResult
            $this.GUI.CreateSysObject("Button",
                                      "Info",
                                      @{Location= ((($width - 156)/2).ToString()+","+($height - 40).ToString());
                                        Size = '140,23';
                                        Text = "OK";
                                        DialogResult = $temp::CANCEL},
                                      "Info")
            $this.GUI.SysObjects.Form.Info.ShowDialog()
            $this.ExitImporter($false)
        }
        else{
            $this.GUI.SysObjects.Form.Info.Show()
        }
        return $this.GUI.SysObjects.Form.Info
    }
    [Object] ShowMassage([String] $message){
        return $this.ShowMassage($message, 0, 0, $false)
    }
    [Object] ShowMassage([String] $message, [Int32] $width, [Int32] $height){
        return $this.ShowMassage($message, $width, $height, $false)
    }
    [Object] ShowMassage([String] $message, [Int32] $width){
        return $this.ShowMassage($message, $width, 0, $false)
    }
    [void] ShowError([String] $message, [Int32] $width, [Int32] $height){
        $this.ShowMassage($message, $width, $height, $true)
    }
    [void] ShowError([String] $message, [Int32] $width){
        $this.ShowError($message, $width, 0)
    }
    [void] ShowError([String] $message){
        $this.ShowError($message, 0, 0)
    }
    [void] EditGlobalMassage([String] $message, [Int32] $width, [Int32] $height){
        <#**************************************************
        Edits the Text of the InfoBox and resizes it
        **************************************************#>
        if($width -eq $null){
            $width = $this.InfoBox.Size.Width
        }
        if($height -eq $null){
            $height = $this.InfoBox.Size.Height
        }
        if(($this.InfoBox.Size.Width -ne $width) -or ($this.InfoBox.Size.Height -ne $height)){
            $this.InfoBox.Close()
            $this.InfoBox.Dispose()
            $this.InfoBox = $this.ShowMassage($message, $width, $height)
            Start-Sleep -Seconds 2
        }
        else{
            $this.InfoBox.Controls.Item(0).Text = $message
            Start-Sleep -Seconds 2
        }
    }
    [void] EditGlobalMassage([String] $message, [Int32] $width){
        $this.EditGlobalMassage($message, $width, $this.InfoBox.Size.Height)
    }
    [void] EditGlobalMassage([String] $message){
        $this.EditGlobalMassage($message, $this.InfoBox.Size.Width, $this.InfoBox.Size.Height)
    }
}

return [ITL_Importer]::new($configfile, $debug)