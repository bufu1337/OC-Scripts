using module ".\GUICreator.psm1"
using module "..\Modules\JsonMutex.psm1"
class ShowJsonMutex{
    $gui
    $mutex
    $log
    $view = "Mutex"
    $changingindex = $false
    $def = @{form = "MtoWork";
        formtext = "Mutex View";
        list_mutex="Mutex";
        list_work="Work";
        list_wait="Wait";
        btn_ref="Refresh";
        btn_rem="RemM";
        btn_arem="RemAllM";
        btn_add="AddM";
        btn_view="View";
        btn_quit="MQuit"
    }
    ShowJsonMutex(){
        $this.gui = [GUICreator]::new()
        $this.gui.PtoP_Visible($PSScriptRoot)
        $this.mutex = [JsonMutex]::new("", "ShowJsonMutex")
        $this.log = $this.mutex.log
    }
    [void] ShowMutexForm(){
        $this.gui.CreateSysObject(
                "Form", $this.def.form, 
                @{Size = '1600,900'; Text = $this.def.formtext; MaximizeBox = $False; 
                  FormBorderStyle = "FixedDialog"; Topmost = $false; StartPosition = "CenterScreen" })
                    
        $this.gui.CreateSysObject("Label", $this.def.list_mutex, @{TextAlign = "TopCenter"; Text = "Mutex:"}, $this.def.form)
        $this.gui.CreateSysObject("ListBox", $this.def.list_mutex, @{Name = $this.def.list_mutex}, $this.def.form)
        $this.gui.SysObjects.ListBox[$this.def.list_mutex].Add_SelectedIndexChanged({
            $global:sl.ListIndexChange()
        })
        
        $this.gui.CreateSysObject("Label", $this.def.list_work, @{TextAlign = "TopCenter"; Text = "Work-IDs:"}, $this.def.form)
        $this.gui.CreateSysObject("ListBox", $this.def.list_work, @{Name = $this.def.list_work}, $this.def.form)
        $this.gui.SysObjects.ListBox[$this.def.list_work].Add_SelectedIndexChanged({
            $global:sl.WorkIndexChange()
        })
        
        $this.gui.CreateSysObject("Label", $this.def.list_wait, @{TextAlign = "TopCenter"; Text = "Wait-IDs:"}, $this.def.form)
        $this.gui.CreateSysObject("ListBox", $this.def.list_wait, @{Name = $this.def.list_wait}, $this.def.form)
        $this.gui.SysObjects.ListBox[$this.def.list_wait].Add_SelectedIndexChanged({
            $global:sl.WaitIndexChange()
        })
        
        $this.gui.CreateSysObject("Button", $this.def.btn_ref, @{Text = "Refresh"; Name = $this.def.btn_ref}, $this.def.form)
        $this.gui.SysObjects.Button[$this.def.btn_ref].Add_Click({
            $global:sl.Refresh()
        })
        
        $this.gui.CreateSysObject("Button", $this.def.btn_rem, @{Text = "Remove Mutex"; Name = $this.def.btn_rem}, $this.def.form)
        $this.gui.SysObjects.Button[$this.def.btn_rem].Add_Click({
            $global:sl.Remove()
        })
        
        $this.gui.CreateSysObject("Button", $this.def.btn_arem, @{Text = "Remove All ID Mutexes"; Name = $this.def.btn_arem}, $this.def.form)
        $this.gui.SysObjects.Button[$this.def.btn_arem].Add_Click({
            $global:sl.RemoveAll()
        })
        $this.gui.CreateSysObject("Button", $this.def.btn_add, @{Text = "Add Mutex"; Name = $this.def.btn_add}, $this.def.form)
        $this.gui.SysObjects.Button[$this.def.btn_add].Add_Click({
            $global:sl.Add()
        })
        
        $this.gui.CreateSysObject("Button", $this.def.btn_view, @{Text = "WorkID View"; Name = $this.def.btn_view}, $this.def.form)
        $this.gui.SysObjects.Button[$this.def.btn_view].Add_Click({
            $global:sl.ChangeView()
        })
        
        $this.gui.CreateSysObject("Button", $this.def.btn_quit, @{Text = "Quit"; Name = $this.def.btn_quit}, $this.def.form)
        $this.gui.SysObjects.Button[$this.def.btn_quit].Add_Click({
            $global:sl.Quit($global:sl.def.form)
        })
        
        $font = New-Object System.Drawing.Font("Microsoft Sans Serif",12,$global:fontstyle)
        foreach($button in ([Array] $this.gui.SysObjects.Button.keys)){
            $this.gui.SysObjects.Button[$button].Font = $font
        }
        #$this.log.WriteInfo($this.gui.SysObjects.Form[$this.def.form].Controls)
        $this.gui.ApplyToSysObject((Join-Path $PSScriptRoot "ShowJsonMutex.json"))
        $this.Refresh()
        $this.gui.SysObjects.Form[$this.def.form].ShowDialog()
    }
    [void] ShowMsgForm([String] $text){
        $this.gui.CreateSysObject(
                "Form", "MSG", 
                @{Size = '500,124'; Text = "Warning"; MaximizeBox = $False; 
                  FormBorderStyle = "FixedDialog"; Topmost = $false; StartPosition = "CenterScreen" })
        
        $this.gui.CreateSysObject("Label", "MSG", @{Location = "0,10"; Size = "490,30"; TextAlign = "TopCenter"; Text = $text}, "MSG")
        $font = New-Object System.Drawing.Font("Microsoft Sans Serif",12,$global:fontstyle)
        $this.gui.SysObjects.Label.MSG.Font = $font
        $this.gui.SysObjects.Label.MSG.TextAlign = $global:CenterAlign
        $this.gui.CreateSysObject("Button", "MsgQuit", @{Location = "142,40"; Size = "200,35"; Text = "Ok"; Name = $this.def.btn_quit}, "MSG")
        $this.gui.SysObjects.Button.MsgQuit.Font = $font
        $this.gui.SysObjects.Button.MsgQuit.Add_Click({
            $global:sl.Quit("MSG")
        })
        $this.gui.SysObjects.Form.MSG.ShowDialog()
    }
    [void] WorkIndexChange(){
        if($this.gui.GetIndexing()[$this.def.list_work][0] -eq $this.gui.SysObjects.ListBox.Work.SelectedIndex){
            $this.gui.SysObjects.ListBox.Work.SelectedIndex = -1
        }
        $this.gui.GetIndexing().Work[0] = $this.gui.SysObjects.ListBox.Work.SelectedIndex
        if(!$this.changingindex){
            $this.changingindex = $true
            $this.gui.SysObjects.ListBox.Wait.SelectedIndex = -1
            $this.changingindex = $false
        }
    }
    [void] WaitIndexChange(){
        if($this.gui.GetIndexing()[$this.def.list_wait][0] -eq $this.gui.SysObjects.ListBox.Wait.SelectedIndex){
            $this.gui.SysObjects.ListBox.Wait.SelectedIndex = -1
        }
        $this.gui.GetIndexing().Wait[0] = $this.gui.SysObjects.ListBox.Wait.SelectedIndex
        if(!$this.changingindex){
            $this.changingindex = $true
            $this.gui.SysObjects.ListBox.Work.SelectedIndex = -1
            $this.changingindex = $false
        }
    }
    [void] ListIndexChange(){
        $lb = $this.gui.SysObjects.ListBox.Mutex
        $this.log.WriteInfo($this.gui.GetIndexing()[$this.def.list_mutex][0])
        $this.log.WriteInfo($lb.SelectedIndex)
        if($this.gui.GetIndexing()[$this.def.list_mutex][0] -eq $lb.SelectedIndex){
            $lb.SelectedIndex = -1
        }
        $this.gui.GetIndexing().Mutex[0] = $lb.SelectedIndex
        $this.gui.SysObjects.ListBox.Work.Items.Clear()
        $this.gui.SysObjects.ListBox.Wait.Items.Clear()
        if($lb.SelectedIndex -ge 0){
            if($this.view -eq "Mutex"){
                $working = [Array] $this.mutex.mutex[$lb.SelectedItem].workIDs.workID
                $waiting = [Array] $this.mutex.mutex[$lb.SelectedItem].waitinglist.workID
                if($working){
                    $this.gui.SysObjects.ListBox.Work.Items.AddRange($working)
                }
                if($waiting){
                    $this.gui.SysObjects.ListBox.Wait.Items.AddRange($waiting)
                }
            }
            elseif($this.view -eq "WorkIDs"){
                $mutexes = @{}
                $mutexes.work = [System.Collections.Arraylist] @()
                $mutexes.wait = [System.Collections.Arraylist] @()
                foreach($mkey in ([Array] $this.mutex.mutex.keys)){
                    $working = [Array] $this.mutex.mutex[$mkey].workIDs.workID
                    $waiting = [Array] $this.mutex.mutex[$mkey].waitinglist.workID
                    if($working -and $working.Contains($lb.SelectedItem)){
                        $mutexes.work.Add($mkey)
                    }
                    if($waiting -and $waiting.Contains($lb.SelectedItem)){
                        $mutexes.wait.Add($mkey)
                    }
                }
                $this.gui.SysObjects.ListBox.Work.Items.AddRange([Array] $mutexes.work)
                $this.gui.SysObjects.ListBox.Wait.Items.AddRange([Array] $mutexes.wait)
            }
        }
    }
    [void] Refresh(){
        $this.mutex.getMutex()
        $this.gui.SysObjects.ListBox.Work.Items.Clear()
        $this.gui.SysObjects.ListBox.Wait.Items.Clear()
        $this.gui.SysObjects.ListBox.Mutex.Items.Clear()
        
        if($this.view -eq "Mutex"){
            $newmutexes = [Array] (([Array] $this.mutex.mutex.keys) | Sort-Object)
            if($newmutexes){
                $this.gui.ApplyToSysObject("ListBox", "Mutex", @{List = $newmutexes})
                #$this.gui.SysObjects.ListBox.Mutex.Items.AddRange($newmutexes)
            }
        }
        elseif($this.view -eq "WorkIDs"){
            $workIDs = [System.Collections.Arraylist] @() 
            foreach($mkey in ([Array] $this.mutex.mutex.keys)){
                $workIDs.add($this.mutex.mutex[$mkey].workIDs.workID)
                $workIDs.add($this.mutex.mutex[$mkey].waitinglist.workID)
            }
            $workIDs = [Array] ($workIDs | Select-Object -Unique | Sort-Object)
            if($workIDs){
                $this.gui.SysObjects.ListBox.Mutex.Items.AddRange($workIDs)
            }
        }
    }
    [void] Remove(){
        $selected_mutex = $this.gui.SysObjects.ListBox.Mutex.SelectedItem
        $selected_work = $this.gui.SysObjects.ListBox.Work.SelectedItem
        $selected_wait = $this.gui.SysObjects.ListBox.Wait.SelectedItem
        if(($selected_mutex -eq $null) -or 
           (($selected_work -eq $null) -and ($selected_wait -eq $null))){
            $this.ShowMsgForm("Please select a Mutex and a WorkID")
            return
        }
        if($this.view -eq "Mutex"){
            $selected_ID = ""
            if($selected_work -ne $null){
                $selected_ID = $selected_work
            }
            if($selected_wait -ne $null){
                $selected_ID = $selected_wait
            }
            $this.mutex.removeMutex($selected_ID, $selected_mutex)
            $this.Refresh()
        }
        elseif($this.view -eq "WorkIDs"){
            
        }
    }
    [void] RemoveAll(){
        if($this.view -eq "Mutex"){
            
        }
        elseif($this.view -eq "WorkIDs"){
            
        }
    }
    [void] Add(){
    
    }
    [void] ChangeView(){
        if($this.view -eq "Mutex"){
            $this.view = "WorkIDs"
            $this.gui.SysObjects.Form[$this.def.form].Text = "WorkID View"
            $this.gui.SysObjects.ListBox.Mutex.Size = "930,834"
            $this.gui.SysObjects.ListBox.Work.Size = "426,403"
            $this.gui.SysObjects.ListBox.Wait.Size = "426,403"
            $this.gui.SysObjects.Label.Work.Size = "426,16"
            $this.gui.SysObjects.Label.Wait.Size = "426,16"
            $this.gui.SysObjects.Label.Mutex.Text = "Work-IDs:"
            $this.gui.SysObjects.Label.Work.Text = "Work-Mutexes:"
            $this.gui.SysObjects.Label.Wait.Text = "Wait-Mutexes:"
            $this.gui.SysObjects.ListBox.Work.Location = "940,27"
            $this.gui.SysObjects.ListBox.Wait.Location = "940,457"
            $this.gui.SysObjects.Label.Work.Location = "940,10"
            $this.gui.SysObjects.Label.Wait.Location = "940,440"
            $this.gui.SysObjects.Button.View.Text = "Mutex View"
        }
        elseif($this.view -eq "WorkIDs"){
            $this.view = "Mutex"
            $this.gui.SysObjects.Form[$this.def.form].Text = "Mutex View"
            $this.gui.SysObjects.ListBox.Mutex.Size = "426,834"
            $this.gui.SysObjects.ListBox.Work.Size = "930,403"
            $this.gui.SysObjects.ListBox.Wait.Size = "930,403"
            $this.gui.SysObjects.Label.Work.Size = "930,16"
            $this.gui.SysObjects.Label.Wait.Size = "930,16"
            $this.gui.SysObjects.Label.Mutex.Text = "Mutex:"
            $this.gui.SysObjects.Label.Work.Text = "Work-IDs:"
            $this.gui.SysObjects.Label.Wait.Text = "Wait-IDs:"
            $this.gui.SysObjects.ListBox.Work.Location = "436,27"
            $this.gui.SysObjects.ListBox.Wait.Location = "436,457"
            $this.gui.SysObjects.Label.Work.Location = "436,10"
            $this.gui.SysObjects.Label.Wait.Location = "436,440"
            $this.gui.SysObjects.Button.View.Text = "WorkID View"
        }
        $this.Refresh()
    }
    [void] Quit([String] $form){
        $this.gui.SysObjects.Form[$form].Close()
        $this.gui.SysObjects.Form[$form].Dispose()
    }
}
[void][System.Reflection.Assembly]::LoadWithPartialName( "System.Drawing")
$global:fontstyle = [System.Drawing.FontStyle]::Regular
$global:CenterAlign = [System.Drawing.ContentAlignment]::TopCenter
#[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
#[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
#[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic")
#Import-Module "R:\PE\Testdata\CRTI-Test\CFD\Importer\PS-Scripts\GUICreator.psm1"
$global:sl = [ShowJsonMutex]::new()
$global:sl.ShowMutexForm()
#$global:sl.ShowPtoPForm()

