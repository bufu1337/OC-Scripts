using module .\Functions.psm1
using module .\Logging.psm1
<#********************************************************************************

Author: Alexander Skripkin
Version: 1.01

********************************************************************************#>

class GUICreator{
    <#*******************************************************************************************************************
    This class creates GUI Objects in a single line, multiple properties can be applied to a GUI Object in a single line.
    Look at the following link for all GUI Objects you can create: 
    https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms?view=netframework-4.7.2
    *******************************************************************************************************************#>
    #*** Class constructor
    GUICreator(){
        $this.log = [Logging]::new()
        
        #*** Trigger logging on or off
        $this.log.On = $true
    }
    $log
    
    #*** Object where the GUI Objects are stored
    [Object] $SysObjects = @{}
    
    #*** Object where a List of selected items for Listboxes are stored
    [Object] $ListIndexing = @{}
    [Hashtable] $def = @{
        listnames = "Location", "Size", "List";
        lblnames = "Location", "Size", "ForeColor", "TextAlign", "Text";
        buttonnames = "Text", "Location", "Size"
    }
    [Boolean] $set_PtoP_obj = $false
    $saveroot = $PSScriptRoot
    [Boolean] $PtoPVisible = $true
    
    #*** Get-Functions for the 2 main fields of this class
    [Hashtable] Get(){
        return $this.SysObjects
    }
    [Hashtable] GetIndexing(){
        return $this.ListIndexing
    }
    
    
    
    #*** SubFunction to combine 2 Arrays (one with names the other with values) to an object and returns the object
    [Object] CombinePropNVs([Array] $propNames, [Array] $propValues){
        $props = @{}
        for($i=0; $i -lt $propNames.Length; $i++){
            $props[$propNames[$i]] = $propValues[$i]
        }
        return $props
    }
    
    <#*****************************************************************************************************
    From here all functions need at least the type of GUI Object (f.e. Label, Button, ListBox etc.)
    and the name of the GUI Object, the properties can be given in 2 ways:
    with the help of the subfunction to combine 2 arrays into 1 object of properties
    (good for multiple GUI Objects with the same property-names, shorter lines) or directly as an object.
    There is the optional parameter to put the GUI Object directly into a Form
    (it is not recommended to put a form into a form ;])
    There are overloading functions for all this variants.
    ******************************************************************************************************#>
    
    #*** Overloading function with 2 arrays instead of 1 object for the properties, and without putting it into a form
    [void] CreateSysObject([String] $type, [String] $name, [Array] $propNames, [Array] $propValues){
        $this.CreateSysObject($type, $name, $propNames, $propValues, "")
    }
    #*** Overloading function with 2 arrays instead of 1 object for the properties, and a parameter to put it into a form
    [void] CreateSysObject([String] $type, [String] $name, [Array] $propNames, [Array] $propValues, [String] $toForm){
        $this.CreateSysObject($type, $name, $this.CombinePropNVs($propNames, $propValues), $toForm)
    }    
    #*** Overloading function with only the properties as object
    [void] CreateSysObject([String] $type, [String] $name, [Object] $props){
        $this.CreateSysObject($type, $name, $props, "")
    }
    
    #*** Main function to create a GUI Object
    [void] CreateSysObject([String] $type, [String] $name, [Object] $props, [String] $toForm){
        [void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
        [void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing.Color")
        [void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
        [void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic")
        if($this.SysObjects[$type] -eq $null){ $this.SysObjects.$type = @{} }
        $this.SysObjects[$type].$name = New-Object System.Windows.Forms.$type
        $this.log.WriteInfo("Creating Object: $type Name: $name")
        if($type -eq "ListBox"){ [Array] $this.ListIndexing[$name] = -1 }
        $this.ApplyToSysObject($type, $name, $props) 
        if($toForm.Length -gt 0){
            if(($this.SysObjects.Form -ne $null) -and $this.SysObjects.Form[$toForm] -ne $null){
                if(!($this.SysObjects.Form.$toForm.IsDisposed)){
                    $this.SysObjects.Form.$toForm.Controls.Add($this.SysObjects.$type.$name)
                    $this.log.WriteInfo("$type : $name --> Adding to Form: $toForm")
                }
            }
            elseif(($this.SysObjects.GroupBox -ne $null) -and $this.SysObjects.GroupBox[$toForm] -ne $null){
                if(!($this.SysObjects.GroupBox.$toForm.IsDisposed)){
                    $this.SysObjects.GroupBox.$toForm.Controls.Add($this.SysObjects.$type.$name)
                    $this.log.WriteInfo("$type : $name --> Adding to GroupBox: $toForm")
                }
            }
        }
        if(($type -eq "Form") -and (!$name.StartsWith("PtoP")) -and 
           ($null -ne $global:gui) -and ($this.PtoPVisible)){ 
            $this.CreateSysObject(
                "Button", "PtoP_Button_$name", 
                @{Text = "Resize"; Location = "0,0"; Size = "20,20"; Name = "PtoP_Button"}, $name)
            $this.SysObjects.Button["PtoP_Button_$name"].Add_Click({
                $global:gui.ShowPtoPForm()
            })
        }
    }
    
    #*** Overloading function with 2 arrays instead of 1 object for the properties
    [void] ApplyToSysObject([String] $type, [String] $name, [Array] $propNames, [Array] $propValues){
        $this.ApplyToSysObject($type, $name, $this.CombinePropNVs($propNames, $propValues))
    }
    [void] ApplyToSysObject([Hashtable] $jsonhash){
        foreach($type in ([Array] $jsonhash.keys)){
            foreach($name in ([Array] $jsonhash[$type].keys)){
                $this.ApplyToSysObject($type, $name, $jsonhash[$type][$name])
            }
        }
    }
    [void] ApplyToSysObject([String] $jsonpath){
        $this.ApplyToSysObject([Functions]::GetJsonHash($jsonpath))
    }
    
    #*** Main function to apply properties to a GUI Object
    [void] ApplyToSysObject([String] $type, [String] $name, [Object] $props){
        #+ Checking if the GUI Object is existing and if it is not disposed
        if($this.SysObjects[$type] -ne $null){
            if($this.SysObjects[$type][$name] -ne $null){
                if(!($this.SysObjects[$type][$name].IsDisposed)){
                    #+ Applying each property from the 
                    foreach($propkey in $props.Keys){
                        $this.log.WriteInfo("propkey: " + $propkey)
                        #+ Checking if the Property is existing in the GUI Object
                        if(($this.SysObjects[$type][$name].$propkey -ne $null) -and ($props[$propkey] -ne "")){
                            $this.SysObjects[$type][$name].$propkey = $props[$propkey]
                            $this.log.WriteInfo("Applying Property: $propkey - " + $props[$propkey] + " to $type : $name")
                        }
                        #+ Special handling for the property 'List', it doesnt exist for a ListBox
                        #+ This adds all items to a ListBox (array of Objects or array of strings)
                        #+ if it is an array of Objects, then define another property 'ListKey'
                        #+ (f.e. @{List=(@{name="a"}, @{name="b"}); ListKey="name"})
                        #+ You can also select a listitem instantly (property: SelectListItem)
                        elseif($propkey -eq "List"){
                            $counter = -1
                            if($props[$propkey] -is [Array]){
                                foreach ($listitem in $props[$propkey]){
                                    if($props["ListKey"] -ne $null){
                                        $item = $listitem[$props["ListKey"]]
                                    }
                                    else{
                                        $item = $listitem
                                    }
                                    $this.log.WriteInfo("Adding ListItem: $item")
                                    [void] $this.SysObjects[$type][$name].Items.Add($item)
                                    $counter = $counter + 1
                                    if($props["SelectListItem"] -ne $null){
                                        $check = $True
                                        if($item.GetType().name.EndsWith("[]")){
                                            $check = $item.Contains($props["SelectListItem"])
                                        }
                                        else{
                                            $check = $item -eq $props["SelectListItem"]
                                        }
                                        if($check){
                                            $this.SysObjects[$type][$name].SetSelected($counter, $true)
                                            if($this.ListIndexing[$name][0] -eq -1){
                                                $this.ListIndexing[$name][0] = $counter
                                            }
                                            else{
                                                $this.ListIndexing[$name] += $counter
                                            }
                                        }
                                    }
                                }
                            }
                            else{$this.log.WriteInfo("Property: $propkey in $type : $name --> Cant add items to List")}
                        }
                        else{$this.log.WriteInfo("Property: $propkey in $type : $name does not exist")}
                    }
                }
                else{$this.log.WriteInfo("$type : $name is disposed")}
            }
            else{$this.log.WriteInfo("$type : $name does not exist")}
        }
        else{$this.log.WriteInfo("Type: $type does not exist")}
    }
    [void] CreateMsgForm([String] $formname, [String] $formtext, [Boolean] $YesNoButtons, [String] $msg){
        $this.CreateSysObject(
                "Form", $formname, 
                @{Size = '500,124'; Text = $formtext; MaximizeBox = $False; 
                  FormBorderStyle = "FixedDialog"; Topmost = $false; StartPosition = "CenterScreen" })
        $this.CreateSysObject("Label", $formname, @{TextAlign = "TopCenter"; Text = $msg; Location = '10,10'; AutoSize = $true}, $formname)
        $minformwidth = 240
        if($YesNoButtons){
            $this.CreateSysObject("Button", ($formname + "_Yes"), @{Size = "100,35"; Text = "Yes"; Name = ($formname + "_Yes")}, $formname)
            $this.CreateSysObject("Button", ($formname + "_No"), @{Size = "100,35"; Text = "No"; Name = ($formname + "_No")}, $formname)
        }
        else{
            $this.CreateSysObject("Button", ($formname + "_Ok"), @{Size = "100,35"; Text = "Ok"; Name = ($formname + "_Ok")}, $formname)
            $minformwidth = 130
        }
        $this.SysObjects.Form[$formname].Size = "" + ($this.SysObjects.Label[$formname].Size.Width + 30) + "," + ($this.SysObjects.Label[$formname].Size.Height + 103)
        if($this.SysObjects.Form[$formname].Size.Width -lt $minformwidth){
            $this.SysObjects.Form[$formname].Size = "" + $minformwidth + "," + ($this.SysObjects.Label[$formname].Size.Height + 103)
        }
        if($YesNoButtons){
            $this.SysObjects.Button[($formname + "_Yes")].Location = "" + ((($this.SysObjects.Form[$formname].Size.Width - 210) / 2) - 8 ) + "," + ($this.SysObjects.Label[$formname].Size.Height + 20)
            $this.SysObjects.Button[($formname + "_No")].Location = "" + ($this.SysObjects.Button[($formname + "_Yes")].Location.X + 110) + "," + $this.SysObjects.Button[($formname + "_Yes")].Location.Y
        }
        else{
            $this.SysObjects.Button[($formname + "_Ok")].Location = "" + ((($this.SysObjects.Form[$formname].Size.Width - 100) / 2) - 8 ) + "," + ($this.SysObjects.Label[$formname].Size.Height + 20)
        }
    }
    [void] ShowPtoPForm(){
        if($null -eq $global:gui){
            Write-Host "PtoP Form not available. Set global:gui instance"
            return
        }
        $types = [System.Collections.Arraylist] @()
        foreach($type in ([Array] $this.SysObjects.keys)){
            foreach($name in ([Array] $this.SysObjects[$type].keys)){
                if(!$name.StartsWith("PtoP")){
                    if(!$types.contains($type)){
                        $types.Add($type)
                    }
                }
            }
        }
        $this.CreateSysObject(
                "Form", "PtoP", 
                @{Size = '275,194'; Text = "Resize GUI Obj."; MaximizeBox = $False; 
                  FormBorderStyle = "FixedDialog"; Topmost = $false; StartPosition = "CenterScreen" })
        
        $this.CreateSysObject(
                "Label", "PtoP_LBL_Type", $this.def.lblnames, 
                ("10,15", "40,20", "", "", "Type:"), "PtoP")
        $this.CreateSysObject(
                "ComboBox", "PtoP_Combo_Type", 
                @{Location = "50,10"; Size = "200,20"}, "PtoP")
        $this.SysObjects.ComboBox.PtoP_Combo_Type.Items.AddRange(($types | Sort-Object))
        $this.SysObjects.ComboBox.PtoP_Combo_Type.Add_SelectedIndexChanged({
            $global:gui.PtoP_SetObjType()
        })
        $this.CreateSysObject(
                "Label", "PtoP_LBL_Name", $this.def.lblnames, 
                ("10,40", "40,20", "", "", "Name:"), "PtoP")
        $this.CreateSysObject(
                "ComboBox", "PtoP_Combo_Name", 
                @{Location = "50,35"; Size = "200,20"}, "PtoP")
        $this.SysObjects.ComboBox.PtoP_Combo_Name.Add_SelectedIndexChanged({
            $global:gui.PtoP_SetObj()
        })
        $this.CreateSysObject(
                "Label", "PtoP_LBL_X", $this.def.lblnames, 
                ("35,65", "15,20", "", "", "X:"), "PtoP")
        $this.CreateSysObject(
                "NumericUpDown", "PtoP_Num_X", 
                @{Location = "50,60"; Size = "60,20"}, "PtoP")
        $this.SysObjects.NumericUpDown.PtoP_Num_X.Add_ValueChanged({
            $global:gui.PtoP_ChangeObj()
        })
        $this.CreateSysObject(
                "Label", "PtoP_LBL_Y", $this.def.lblnames, 
                ("35,90", "15,20", "", "", "Y:"), "PtoP")
        $this.CreateSysObject(
                "NumericUpDown", "PtoP_Num_Y", 
                @{Location = "50,85"; Size = "60,20"}, "PtoP")
        $this.SysObjects.NumericUpDown.PtoP_Num_Y.Add_ValueChanged({
            $global:gui.PtoP_ChangeObj()
        })
                
        $this.CreateSysObject(
                "Label", "PtoP_LBL_Width", $this.def.lblnames, 
                ("120,65", "40,20", "", "", "Width:"), "PtoP")
        $this.CreateSysObject(
                "NumericUpDown", "PtoP_Num_Width", 
                @{Location = "160,60"; Size = "60,20"}, "PtoP")
        $this.SysObjects.NumericUpDown.PtoP_Num_Width.Add_ValueChanged({
            $global:gui.PtoP_ChangeObj()
        })
                
        $this.CreateSysObject(
                "Label", "PtoP_LBL_Height", $this.def.lblnames, 
                ("120,90", "40,20", "", "", "Height:"), "PtoP")
        $this.CreateSysObject(
                "NumericUpDown", "PtoP_Num_Height", 
                @{Location = "160,85"; Size = "60,20"}, "PtoP")
        $this.SysObjects.NumericUpDown.PtoP_Num_Height.Add_ValueChanged({
            $global:gui.PtoP_ChangeObj()
        })
        $this.SysObjects.NumericUpDown.PtoP_Num_X.Maximum = 3840
        $this.SysObjects.NumericUpDown.PtoP_Num_Width.Maximum = 3840
        $this.SysObjects.NumericUpDown.PtoP_Num_Y.Maximum = 2160
        $this.SysObjects.NumericUpDown.PtoP_Num_Height.Maximum = 2160
        $this.SysObjects.ComboBox.PtoP_Combo_Type.SelectedIndex = 0
        $this.CreateSysObject(
                "Button", "PtoP_Quit", $this.def.buttonnames, 
                ("Ok", "30,110", "95,35"), "PtoP")
        $this.SysObjects.Button.PtoP_Quit.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",12,$global:fontstyle)
        $this.SysObjects.Button.PtoP_Quit.Add_Click({
            $global:gui.Quit("PtoP")
        })
        $this.CreateSysObject(
                "Button", "PtoP_Save", $this.def.buttonnames, 
                ("Save", "135,110", "95,35"), "PtoP")
        $this.SysObjects.Button.PtoP_Save.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",12,$global:fontstyle)
        $this.SysObjects.Button.PtoP_Save.Add_Click({
            $global:gui.PtoP_Save()
        })
        
        $this.SysObjects.Form.PtoP.ShowDialog()
    }
    [void] PtoP_ChangeObj(){
        if($this.set_PtoP_obj){
            return
        }
        $selected = @{
            typ = $this.SysObjects.ComboBox.PtoP_Combo_Type.SelectedItem;
            name = $this.SysObjects.ComboBox.PtoP_Combo_Name.SelectedItem
        }
        $object = $this.SysObjects[$selected.typ][$selected.name]
        $object.location = "" + $this.SysObjects.NumericUpDown.PtoP_Num_X.value + "," + 
                           $this.SysObjects.NumericUpDown.PtoP_Num_Y.value
        $object.size = "" + $this.SysObjects.NumericUpDown.PtoP_Num_Width.value + "," + 
                             $this.SysObjects.NumericUpDown.PtoP_Num_Height.value
    }
    [void] PtoP_SetObjType(){
        $type = $this.SysObjects.ComboBox.PtoP_Combo_Type.SelectedItem
        $names = [System.Collections.Arraylist] @()
        foreach($name in ([Array] $this.SysObjects[$type].keys)){
            if(!$name.StartsWith("PtoP")){
                if(!$names.contains($name)){
                    $names.Add($name)
                }
            }
        }
        $this.SysObjects.ComboBox.PtoP_Combo_Name.Items.Clear()
        $this.SysObjects.ComboBox.PtoP_Combo_Name.Items.AddRange(($names | Sort-Object))
        $this.SysObjects.ComboBox.PtoP_Combo_Name.SelectedIndex = 0
    }
    [void] PtoP_SetObj(){
        $this.set_PtoP_obj = $true
        $selected = @{
            typ = $this.SysObjects.ComboBox.PtoP_Combo_Type.SelectedItem;
            name = $this.SysObjects.ComboBox.PtoP_Combo_Name.SelectedItem
        }
        $object = $this.SysObjects[$selected.typ][$selected.name]
        $this.SysObjects.NumericUpDown.PtoP_Num_X.value = $object.location.X
        $this.SysObjects.NumericUpDown.PtoP_Num_Y.value = $object.location.Y
        $this.SysObjects.NumericUpDown.PtoP_Num_Width.value = $object.size.Width
        $this.SysObjects.NumericUpDown.PtoP_Num_Height.value = $object.size.Height
        $this.set_PtoP_obj = $false
    }
    [void] PtoP_Visible([String] $save_root){
        $global:gui = $this
        $this.PtoPVisible = $true
        $this.saveroot = $save_root
    }
    [void] PtoP_Visible(){
        $this.PtoP_Visible($PSScriptRoot)
    }
    [void] PtoP_Save(){
        $this.CreateSysObject("OpenFileDialog", "PtoP_OFD", 
            @{initialDirectory = $this.saveroot; filter = "Json-File (*.json)| *.json"; Topmost = $false; 
              StartPosition = "CenterScreen"})
        $file = ""
        if($this.SysObjects.OpenFileDialog.PtoP_OFD.ShowDialog() -eq "OK"){
            $file = $this.SysObjects.OpenFileDialog.PtoP_OFD.FileName
        }
        if($file -eq ""){ 
            return
        }
        $Obj_props = @{}
        foreach($type in ([Array] $this.SysObjects.keys)){
            foreach($name in ([Array] $this.SysObjects[$type].keys)){
                if(!$name.StartsWith("PtoP")){
                    if($null -eq $Obj_props[$type]){
                        $Obj_props[$type] = @{}
                    }
                    $object = $this.SysObjects[$type][$name]
                    $Obj_props[$type][$name] = @{
                        location = "" + $object.location.X + "," + $object.location.Y;
                        size = "" + $object.size.Width + "," + $object.size.Height;
                    }
                }
            }
        }
        $Obj_props | ConvertTo-Json | Out-File $file
    }
    [void] Quit([String] $form){
        $this.SysObjects.Form[$form].Close()
        $this.SysObjects.Form[$form].Dispose()
    }
}
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
$global:fontstyle = [System.Drawing.FontStyle]::Regular
$global:CenterAlign = [System.Drawing.ContentAlignment]::TopCenter
function New-GUICreator (){
    #*******************************************************************************************
    #*** Creates a new instance of class GUICreator. This instance creation method is a
    #*** workaround in case the class GUICreator is not directly available in the using script.
    #*******************************************************************************************
    $global:gui = [GUICreator]::new()
    return $global:gui
}