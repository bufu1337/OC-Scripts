<# ------------------------------------------------------------------------------------------------------------ #>
<# Author: Alexander Skripkin
   Version: 1.05
   Copyright: Copyright (c) 2018 by dSPACE GmbH, Paderborn, Germany. All Rights Reserved.
#>
<# Description:
   A simple logger which outputs text with timestamp and the type of message (e.g. Fail, Info, Step)
   to the console and to a predefined Logfile.
#>
<# Change-Log:
        v1.05 --> - Error Message Handling. If the type is an ErrorRecord, then he write more detailed information about the Error.
                  - Sub-Type can now be defined as an array or arraylist, so multiple Sub-Types can be possible.
                  - ON/OFF switch included
                  - Logging SeparatorLine without timestamp included
        v1.04 --> - Added the option to define a Sub-Type.
                    Purpose: e.g. Main-Type = Info | Sub-Type = Process (ExitCode) or Sub-Type = Parameter-Table
                             e.g. Main-Type = Step | Sub-Type = VM-Control or Sub-Type = Installation
                  - Catched Exception when text equals $null, then the text will be "null"
                  - Added empty Constructor. Logger will only write log in console, without saving to a file
<# ------------------------------------------------------------------------------------------------------------ #>

class Logging{
    <# ---- Public Fields ---- #>
    $lastText = "" # The last Text written to the log (without timestamp, type, subtype)
    $pathLog = "" # The path to a logfile given in with the constructor (can be empty string for no output to a file)
    $ON = $true # ON/OFF switch for entire logging
    $separatorLine = "-" * 100 # Definition of the separatorline
    
    <# ---- Constructor ---- #>
    <# Sets the path to the Logfile. Creates the folder and file if it is not existing.
    Parameters: 1. pathLog --> Full path to a textfile. (string) #>
    Logging([String] $pathLog){
        # Set path to corresponding field
        $this.pathLog = $pathLog
        # If its not empty...
        if($pathLog -ne ""){
            # ... create folder
            if(!(Test-Path (Split-Path $this.pathLog))){
                New-Item -ItemType Directory -Force -Path (Split-Path $this.pathLog)
            }
            # ... create file
            if(!(Test-Path $this.pathLog)){
                New-Item $this.pathLog -ItemType file
            }
        }
    }
    Logging(){}
    
    <# +++ Main Method for using Logger +++
    Writes the desired text to the console and to the logfile (defined with the initialization of this class)
    with a timestamp and the type in between to find it easier. (timestamp [type]: text)
    It also doesnt repeat the logging if the text is equal to the previous one.
    Parameters:
        1. text --> the text for the log, can be an array for multiple lines
            (any common type (bool, int, string, char),
                as well as Array, ArrayList, Hashtable, ErrorRecord, VMScriptResultImpl (multiple lines))
            (multiple lines wont have a timestamp, the timestamp and type/subtype will be at the first line.
            Last subtype (or if no one is defined, then type will be written "-------- $type --------")
        2. type --> the type of the log-message for better recognition, whats happening. (string)
        3. subtype --> one or multiple sutypes of the log-message for better recognition (string or array or arraylist)
                                                                                         (optional)(default: "") 
    Examples:
        $this --> any object inherting this class
        $this.log.WriteLog("I am an example", "Main Type", ("Subtype1", "Subtype2"))
            Output --> 26-Jul-2019 12:33:02 [Main Type][Subtype1][Subtype2]: I am an example
            
        $this.log.WriteLog(("Log 1", "Log 2", "Log 3"), "Main Type", ("Subtype1", "I am an example list"))
            Output --> 26-Jul-2019 12:33:32 [Main Type][Subtype1]: -------- I am an example list -------- 
                            Log 1
                            Log 2
                            Log 3
        $this.log.WriteLog(@{key1="I"; key2="am", key3="a hashtable"}, "Main Type", ("Some Variables", "Hashtable example"))
            Output --> 26-Jul-2019 12:40:20 [Main Type][Some Variables]: -------- Hashtable example --------
                        {
                            key1 = I
                            key2 = am
                            key3 = a hashtable
                        } #>
    [void] WriteLog($text, $type, $subtype){
        # Main Switch
        if($this.ON){
            # Convert a $null to string
            if($text -eq $null){
                $text = "null"
            }
            
            # Convert subtype to an array if it is an arraylist or string
            if(($subtype -is [Array]) -or ($subtype -is [System.Collections.ArrayList]) -or ($subtype -is [String])){
                $subtype = [Array] $subtype
            }
            else{
                $subtype = [Array] ""
            }
                        
            if(($text -is [String]) -and ($text -eq "")){
                # Write an empty line without timestamp if text is empty (use overload method: WriteEmptyLine)
                Write-Host ""
                if($this.pathLog -ne ""){ Out-File -FilePath $this.pathLog -InputObject $this.separatorLine -Append }
            }
            elseif(($text -is [String]) -and ($text -eq $this.separatorLine)){
                # Write an empty line without timestamp if text equals the defined separatorline
                # (use overload method: WriteSeparatorLine)
                Write-Host " " $this.separatorLine " "
                if($this.pathLog -ne ""){ Out-File -FilePath $this.pathLog -InputObject $this.separatorLine -Append }
            }
            elseif($text -ne $this.lastText){
                # Show log if the text does not equal to the previous text logged
                
                # Define type if the text is VMScriptResultImpl - Object and split the lines of the ScriptOutput
                if($text.GetType().name -eq "VMScriptResultImpl"){
                    $type = "Script Output -- Exit Code " + $text.ExitCode
                    $text = [regex]::split($text.ScriptOutput,'\n')
                }
                
                # Set the lastText for the next log
                $this.lastText = $text
                
                # Get Timestamp
                $msg = Get-Date -format "dd-MMM-yyyy HH:mm:ss"
                
                # Convert objects like Array, Arraylist, Hashtable or ErrorRecord to an Array of Strings
                # (method: ConvertObject)
                if(($text -is [Array]) -or
                   ($text -is [System.Collections.ArrayList]) -or
                   ($text -is [Hashtable]) -or
                   ($text -is [System.Management.Automation.ErrorRecord])){
                    $text = $this.ConvertObject($text, $false)
                }
                
                # Handling of a String-Array (converted Objects in previous step)
                if($text -is [String[]]){
                    
                    if(($subtype.length -eq 1) -and ($subtype[0] -eq "")){
                        $msg += ": -------- " + $type + " --------"
                    }
                    else{
                        $msg += " [" + $type + "]"
                        if($subtype.length -gt 1){
                            for($i=0; $i -lt ($subtype.length - 1); $i++){
                                $msg += "[" + $subtype[$i] + "]"
                            }
                        }
                        $msg += ": -------- " + $subtype[$subtype.length - 1] + " --------"
                    }
                    # Write timestamp and (sub)types to console and write each String of the Sting-Array
                    Write-Host $msg
                    foreach ($i in $text){
                        Write-Host $i
                    }
                    # Append to file if defined
                    if($this.pathLog -ne ""){ 
                        Out-File -FilePath $this.pathLog -InputObject $msg -Append
                        Out-File -FilePath $this.pathLog -InputObject $text -Append
                    }
                }
                else{
                    # Handling of normal types (bool, int, string, char)
                    if(($text -is [String]) -and ($text -eq "")){
                        $msg = $text
                    }
                    elseif(($subtype.length -eq 1) -and ($subtype[0] -eq "")){
                        # No subtype
                        $msg += " [" + $type + "]: " + $text
                    }
                    else{
                        # Adding subtype(s)
                        $msg += " [" + $type + "]"
                        foreach($sub in $subtype){
                            $msg += "[" + $sub + "]"
                        }
                        $msg += ": " + $text
                    }
                    # Write to console
                    Write-Host $msg
                    # Append to file if defined
                    if($this.pathLog -ne ""){ Out-File -FilePath $this.pathLog -InputObject $msg -Append }
                }
            }
        }
    }
    
    <# Overload methods: Predefined message types for faster scripting #>
    [void] WriteLog ($text, $type){
        $this.WriteLog($text, $type, "")
    }
    
    [void] WriteEmptyLine(){
        $this.WriteLog("", "")
    }
    [void] WriteSeparatorLine(){
        $this.WriteLog($this.separatorLine, "")
    }
    [void] WriteInfo($text, $subtype){
        $this.WriteLog($text, "Info", $subtype)
    }
    [void] WriteStep($text, $subtype){
        $this.WriteLog($text, "Step", $subtype)
    }
    [void] WriteFail($text, $subtype){
        $this.WriteLog($text, "FAIL", $subtype)
    }
    [void] WriteError($text, $subtype){
        $this.WriteLog($text, "ERROR", $subtype)
    }
    [void] WriteInfo($text){
        $this.WriteLog($text, "Info")
    }
    [void] WriteStep($text){
        $this.WriteLog($text, "Step")
    }
    [void] WriteFail($text){
        $this.WriteLog($text, "FAIL")
    }
    [void] WriteError($text){
        $this.WriteLog($text, "ERROR")
    }
    
    <# Converts Array, Arraylist, Hashtable and ErrorRecords to an Array of Strings
       Returns an Array of Strings
       Parameters:
            1. obj -> an Object like Array, ArrayList, Hashtable or ErrorRecord 
            2. firstbrackets -> place the first brackets of an hashtable or array(list) #>
    [String[]] ConvertObject([Object] $obj, [Boolean] $firstbrackets){
        # Define initially a returning value
        [System.Collections.ArrayList] $returning = @()
        # This string defines the indention of all strings in the returned value
        [String] $indention = "    "
        # Everything in try and catch if an error occurs while converting
        try{
            # Different handlings for corresponding object-types
            if($obj -is [Hashtable]){
                # Add initial curly bracket of hashtable and add indention
                if($firstbrackets){
                    $returning += ($indention + "{")
                    $indention += "    "
                }
                # Go through keys
                foreach($o in ($obj.GetEnumerator() | Sort-Object "name")){
                    # Add keyname and equals (=)
                    $returning += ($indention + $o.name + " = ")
                    # Call this method recursively if it is Array, ArrayList, Hashtable
                    $temp = [System.Collections.ArrayList] $this.ConvertObject($obj[$o.name], $true)
                    # Add initial bracket to the last string (behind = )
                    $returning[($returning.length.length - 1)] += $temp[0].SubString(4)
                    # Remove the initial bracket from the Array
                    $temp.RemoveAt(0)
                    # Add all other Strings of the returned Array
                    foreach($line in $temp){
                        $returning += ($indention + $line.SubString(4))
                    }
                }
                # Close in the indention previously added and add closing curly bracket
                if($firstbrackets){
                    $indention = $indention.Substring(0,($indention.length - 4))
                    $returning += ($indention + "}")
                }
            }
            elseif(($obj -is [Array]) -or ($obj -is [System.Collections.ArrayList])){
                # Add initial bracket of array and add indention
                if($firstbrackets){
                    $returning += ($indention + "(")
                    $indention += "    "
                }
                foreach($o in $obj){
                    # Call this method recursively if it is Array, ArrayList, Hashtable
                    # and add all other Strings of that returned Array
                    foreach($line in $this.ConvertObject($o, $true)){
                        $returning += ($indention + $line.SubString(4))
                    }
                }
                # Close in the indention previously added and add closing bracket
                if($firstbrackets){
                    $indention = $indention.Substring(0,($indention.length - 4))
                    $returning += ($indention + ")")
                }
            }
            elseif($obj -is [System.Management.Automation.ErrorRecord]){
                # Add PositionMessage and full ExceptionMessage
                $returning += $indention + $obj.ToString()
                foreach($pm in $obj.InvocationInfo.PositionMessage.Split("`n")){
                    $returning += $indention + $pm
                }
                $returning += ""
                $returning += "Full Error Message:"
                foreach($pm in $obj.Exception.toString().Split("`n")){
                    $returning += $indention + $pm.ToString()
                }
            }
            else{
                # If it is a normal Object then convert it to String and add to returning value
                $returning += ($indention + $obj.ToString())
            }
        }
        catch{ $returning += "{}" }
        
        # Return value as a String-Array
        return ([String[]] $returning)
    }
}

<#***************************************
Creates a new instance of class Logging.
(Unknown class if script is used as a module.)
**************************************#>
function New-Logging ([String] $pathLog){    
    return [Logging]::new($pathLog)
}

