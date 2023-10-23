using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.IO
using namespace System.Management.Automation
using namespace System.Data
using namespace System.Drawing
using module ..\Satisfactory\GUICreator.psm1
using module ..\Satisfactory\Functions.psm1
using module ..\Satisfactory\Logging.psm1

class Constants{
    static [String] ConfigPath(){return "$PSScriptRoot\MovieDB.json"}
    static [String] ConfigPathActors(){return "$PSScriptRoot\Actors.json"}
    static [Hashtable] GetConfig(){
        return [Functions]::GetJsonHash(([Constants]::ConfigPath()))
    }
    static [Array] GetConfigActors(){
        return [Functions]::GetJsonHash(([Constants]::ConfigPathActors())).SyncRoot
    }
    static [void] SaveConfigItems([Hashtable] $Config){
        $Config | ConvertTo-Json -Depth 4 | Out-File ([Constants]::ConfigPath())
        Write-Host Config saved to ([Constants]::ConfigPath())
    }
    static [void] SaveConfigActors([Array] $Config){
        $Config | ConvertTo-Json -Depth 4 | Out-File ([Constants]::ConfigPathActors())
        Write-Host Config saved to ([Constants]::ConfigPathActors())
    }
    static [Hashtable] $def = @{
        # Main
        form = "MovieDB";
        formtext = "Movie Database";

        frames = @{
            lists = "fLists";
            details = "fDetails";
            options = "fOptions"
        };

        # Info
        list = @{
            item = "Items";
            actor = "Actors"
        };

        dd =@{
            type = "dType"
        };

        cap =@{
            title = "Title";
            actor = "Actors"
        };

        cb =@{
            wish = "cbWish";
            oAct = "cboAct";
            oItem = "cboItem";
            oWish = "cboWish";
            oExist = "cboExist";
            oRest = "cboRest"
        };

        # Other
        btn_Item="Add Item";
        btn_Actor="Add Actor";
        btn_rItem="Remove Item";
        btn_Refresh="Refresh";
        btn_save="Save";
        btn_quit="Quit"
    }
}

class Actor{
    [String] $Name

    Actor([String] $Name){
        $this.Name = $Name
    }
}

class Item{
    [String] $Title
    [String] $OrigTitle
    [String] $Year
    [List[Actor]] $Actors = [List[Actor]]::new()
    [Boolean] $Wish
    [Boolean] $Exist
    [ArrayList] $Other = [ArrayList] @()

    Item([Hashtable] $Item){
        $this.Title = $Item.Title
        if($null -eq $Item.OrigTitle){$this.OrigTitle = $this.Title}
        else{$this.OrigTitle = $Item.OrigTitle}
        $this.Year = $Item.Year
        $this.Wish = $Item.Wish
        $this.Other = $Item.Other
    }

    [Hashtable] ConvertToHash(){
        return @{
            Title = $this.Title;
            OrigTitle = $this.OrigTitle;
            Year = $this.Year;
            Wish = $this.Wish;
            Other = $this.Other
        }
    }
}
class MovieDB{
    [Hashtable] $Items = @{}
    [Hashtable] $ItemsIndex = @{}
    [Hashtable] $ActorsIndex = @{}
    [List[Actor]] $Actors = [List[Actor]]::new()
    [List[Item]] $ItemsShow = [List[Item]]::new()
    # [Item] $SelectedRecipe
    # [Boolean] $SelectedRecipeMutex = $false
    # [Boolean] $EditRecipe = $false
    $gui
    $log

    MovieDB(){
        $this.gui = [GUICreator]::new()
        $this.gui.PtoP_Visible($PSScriptRoot)
        $this.gui.log.ON = $false
        $this.log = [Logging]::new()
        $this.LoadConfig()
    }

    [Item] GetItem([String] $Type, [String] $Title, [String] $Year){
        if($null -eq $this.Items[$Type]){ return $null }
        if($null -eq $this.ItemsIndex[$Type]["$($Title) ($($Year))"]){ return $null }
        return $this.Items[$Type][$this.ItemsIndex[$Type]["$($Title) ($($Year))"]]
    }

    [Actor] GetActor([String] $Name){
        if($null -eq $this.ActorsIndex[$Name]){ return $null }
        return $this.Actors[$this.ActorsIndex[$Name]]
    }

    [Array] GetTypes(){
        return [Array] $this.Items.Keys
    }

    [void] Sort(){
        $this.SortActors()
        $this.SortItems()
    }

    [void] SortActors(){
        $this.Actors = [List[Actor]] ($this.Actors | Sort-Object -Property {$_.Name})
        foreach($actor in $this.Actors){
            $this.ActorsIndex[$actor.Name] = $this.Actors.IndexOf($actor)
        }
    }

    [void] SortItems([String] $Type){
        $this.Items[$Type] = [List[Item]] ($this.Items[$Type] | Sort-Object -Property {$_.Title})
        foreach($item in $this.Items[$Type]){
            $this.ItemsIndex[$Type]["$($item.Title) ($($item.Year))"] = $this.Items[$Type].IndexOf($item)
        }
    }

    [void] SortItems(){
        foreach($type in $this.GetTypes()){
            $this.SortItems($type)
        }
    }
    
    # [void] SetItemRecipes([Array] $Names){
    #     $this.log.WriteStep("Set Item Recipes")
    #     $itemsToSet = $this.Items
    #     if(($null -ne $Names) -and ($Names.Count -gt 0)){
    #         $itemsToSet = [Array] ($this.Items | Where-Object{$Names -contains $_.Name})
    #     }
    #     foreach($item in $itemsToSet){
    #         $this.log.WriteStep("Set Recipes for Item: $($item.Name)")
    #         $item.GetRecipes($this.Recipes)
    #     }
    # }
    # [void] SetItemRecipes(){
    #     $this.SetItemRecipes($null)
    # }
    # [void] UpdateItems([Array] $itemsToUpdate){
    #     $itemsForUpdate = $this.Items
    #     if($null -ne $itemsToUpdate){
    #         $itemsForUpdate = $this.Items | Where-Object{$itemsToUpdate -contains $_.Name}
    #     }
    #     foreach($item in $itemsForUpdate){
    #         $item.Update($this.ProduktionKey)
    #     }
    # }
    # [void] UpdateItems(){$this.UpdateItems($null)}

    [Hashtable] AddItem([String] $Type, [Hashtable] $Item){
        if($null -ne $this.GetItem($Type, $Item.Title, $Item.Year)){
            $msg = "$Type arleady existing: $($Item.Title) ($($Item.Year))"
            $this.log.WriteError($msg)
            return @{status = $false; msg = $msg }
        }
        if($null -eq $this.Items[$Type]){
            $this.Items[$Type] = [List[Item]]::new() 
            $this.ItemsIndex[$Type] = @{}
            #$this.log.WriteInfo("Type $Type added")
        }
        #$this.log.WriteInfo($Item)
        $xItem = [Item]::new($Item)
        foreach($actorName in $Item.Actors){
            $xItem.Actors.Add($this.GetActor($actorName))
        }
        $this.ItemsIndex[$Type]["$($xItem.Title) ($($xItem.Year))"] = $this.Items[$Type].Count
        $this.Items[$Type].Add($xItem)
        $msg = "$Type added: $($xItem.Title) ($($xItem.Year))"
        #$this.log.WriteInfo($msg)
        return @{status = $true; msg = $msg}
    }

    [Hashtable] AddActor([String] $Name){
        if($null -ne $this.GetActor($Name)){
            $msg = "Actor arleady existing: $Name"
            $this.log.WriteError($msg)
            return @{status = $false; msg = $msg }
        }
        $actor = [Actor]::new($Name)
        $this.ActorsIndex[$Name] = $this.Actors.Count
        $this.Actors.Add($actor)
        $msg = "Actor added: $Name"
        #$this.log.WriteInfo($msg)
        return @{status = $true; msg = $msg}
    }
    
    [Hashtable] ConvertToHash(){
        $rc = @()
        if($this.Recipes.Count -gt 0){
            $rc = ([Array] $this.Recipes.ConvertToHash())
        }
        return @{Items = $this.Items.Name; Recipes = $rc}
    }

    [void] SaveConfig(){
        [Constants]::SaveConfig($this.ConvertToHash())
    }

    [void] LoadConfig(){
        $cfgActors = [Constants]::GetConfigActors()
        foreach($actorName in $cfgActors){
            $this.AddActor($actorName)
        }

        $cfgItems = [Constants]::GetConfig()
        foreach($type in [Array] $cfgItems.keys){
            foreach($item in [Array] $cfgItems[$type]){
                $this.AddItem($type, $item)
            }
        }
        $this.Sort()
    }

    [void] ShowForm(){
        # Add GUI Elements
        $this.gui.CreateSysObject(
                "Form", [Constants]::def.form, 
                @{Size = '1600,950'; Text = [Constants]::def.formtext; MaximizeBox = $False; 
                  FormBorderStyle = "FixedDialog"; Topmost = $false; StartPosition = "CenterScreen" })
          
        $this.gui.CreateSysObject("GroupBox", [Constants]::def.frames.lists, @{}, [Constants]::def.form)
        $this.gui.CreateSysObject("GroupBox", [Constants]::def.frames.details, @{}, [Constants]::def.form)
        $this.gui.CreateSysObject("GroupBox", [Constants]::def.frames.options, @{}, [Constants]::def.form)
        
        #$this.gui.CreateSysObject("Label", [Constants]::def.list.item, @{Text = "Items:"}, [Constants]::def.frames.lists)
        $this.gui.CreateSysObject("ComboBox", [Constants]::def.dd.type, @{}, [Constants]::def.frames.lists)
        $this.gui.SysObjects.ComboBox[([Constants]::def.dd.type)].Items.AddRange([Array] $this.GetTypes())
        $this.gui.SysObjects.ComboBox[([Constants]::def.dd.type)].SelectedIndex = 0
        $this.gui.SysObjects.ComboBox[([Constants]::def.dd.type)].Add_SelectedIndexChanged({
            $global:s.RefreshItemList()
            # $global:s.SetRecipeLists()
            # $global:s.ShowItemInfo()
        })
        
        $this.gui.CreateSysObject("ListBox", [Constants]::def.list.item, @{Name = [Constants]::def.list.item; DrawMode = "OwnerDrawFixed"; ItemHeight = 21; DisplayMember=""}, [Constants]::def.frames.lists)
        $this.gui.SysObjects.ListBox[([Constants]::def.list.item)].Add_DrawItem({
            $selectedType = $global:s.gui.SysObjects.ComboBox[([Constants]::def.dd.type)].SelectedItem
            if ($global:s.Items[$selectedType].Count -eq 0) {return}
            $item = $global:s.Items[$selectedType][$args.Index]
            #$global:s.log.WriteInfo($item.ConvertToHash(), "Draw")
            #$item = $global:s.GetItemByName($itemName)
            $brush = $global:brushes.White
            # if(($item.Production -ne 0) -or ($item.Consumption -ne 0)){
            #     $prefix = "Light"
            #     $suffix = "Red"
            #     if($this.SelectedItem -eq $itemName){
            #         $prefix = ""
            #     }
            #     if($item.IsEnough){
            #         $suffix = "Green"
            #     }
            #     $brush = $global:brushes["$prefix$suffix"]
            # }
            # elseif($this.SelectedItem -eq $itemName){
            #     $brush = $global:brushes.Blue
            # }
            # else{
            #     $brush = $global:brushes.White
            # }
            $args.Graphics.FillRectangle($brush, (new-object System.Drawing.Rectangle(
                                                                        (new-object System.Drawing.Point($args.Bounds.X[1], $args.Bounds.Y[1])), 
                                                                        (new-object System.Drawing.Size(($this.Width/2),$this.ItemHeight))
                                                                )))
            $args.Graphics.FillRectangle($global:brushes.Blue, (new-object System.Drawing.Rectangle(
                                                                        (new-object System.Drawing.Point((([Int32] $args.Bounds.X[1])+([Int32] $this.Width / 2)), $args.Bounds.Y[1])), 
                                                                        (new-object System.Drawing.Size(($this.Width/2),$this.ItemHeight))
                                                                )))
            $args.Graphics.DrawString($item.Title, $global:font1, $global:CT, (new-object System.Drawing.PointF($args.Bounds.X[1], $args.Bounds.Y[1])))
        })
        $this.gui.SysObjects.ListBox[([Constants]::def.list.item)].Add_SelectedIndexChanged({
            $this.Refresh()
            # $global:s.SetRecipeLists()
            # $global:s.ShowItemInfo()
        })
                    
        #$this.gui.CreateSysObject("Label", [Constants]::def.list.mainRecipe, @{Text = "Main Recipes:"}, [Constants]::def.frames.lists)
        $this.gui.CreateSysObject("ListBox", [Constants]::def.list.actor, @{Name = [Constants]::def.list.actor; DrawMode = "OwnerDrawFixed"; ItemHeight = 21; DisplayMember=""}, [Constants]::def.frames.lists)
        $this.gui.SysObjects.ListBox[([Constants]::def.list.actor)].Add_DrawItem({
            if ($global:s.Actors.Count -eq 0) {return}
            $actor = $global:s.Actors[$args.Index]
            #$item = $global:s.GetItemByName($itemName)
            $brush = $global:brushes.White
            # if(($item.Production -ne 0) -or ($item.Consumption -ne 0)){
            #     $prefix = "Light"
            #     $suffix = "Red"
            #     if($this.SelectedItem -eq $itemName){
            #         $prefix = ""
            #     }
            #     if($item.IsEnough){
            #         $suffix = "Green"
            #     }
            #     $brush = $global:brushes["$prefix$suffix"]
            # }
            # elseif($this.SelectedItem -eq $itemName){
            #     $brush = $global:brushes.Blue
            # }
            # else{
            #     $brush = $global:brushes.White
            # }
            $args.Graphics.FillRectangle($brush, (new-object System.Drawing.Rectangle(
                                                                        (new-object System.Drawing.Point($args.Bounds.X[1], $args.Bounds.Y[1])), 
                                                                        (new-object System.Drawing.Size($this.Width,$this.ItemHeight))
                                                                )))
            $args.Graphics.DrawString($actor.Name, $global:font1, $global:CT, (new-object System.Drawing.PointF($args.Bounds.X[1], $args.Bounds.Y[1])))
        })
        $this.gui.SysObjects.ListBox[([Constants]::def.list.actor)].Add_SelectedIndexChanged({
            # if(!$global:s.SelectedRecipeMutex){
            #     $global:s.SelectedRecipeMutex = $true
            #     $global:s.gui.SysObjects.ListBox[([Constants]::def.list.secRecipe)].SelectedIndex = -1
            #     $global:s.gui.SysObjects.ListBox[([Constants]::def.list.usedIn)].SelectedIndex = -1
            #     $global:s.ShowRecipeInfo()
            #     $global:s.SelectedRecipeMutex = $False
            # }
        })

        # $this.gui.CreateSysObject("Label", [Constants]::def.pk.lbl, @{Text = "PKey:"; Font = $global:font2}, [Constants]::def.frames.pk)
        # $this.gui.CreateSysObject("ComboBox", [Constants]::def.pk.cb, @{Font = $global:font1}, [Constants]::def.frames.pk)
        # $this.gui.SysObjects.ComboBox[([Constants]::def.pk.cb)].Add_SelectedIndexChanged({
        #     $global:s.ChangePK()
        # })
        # $this.gui.CreateSysObject("TextBox", [Constants]::def.pk.tb, @{Text = ""; Font = $global:font1}, [Constants]::def.frames.pk)
        # $this.gui.CreateSysObject("Button", [Constants]::def.pk.btn, @{Text = "Add"; Name = [Constants]::def.pk.btn}, [Constants]::def.frames.pk)
        # $this.gui.SysObjects.Button[([Constants]::def.pk.btn)].Add_Click({
        #     $global:s.AddPK()
        # })
        # $this.gui.CreateSysObject("Button", [Constants]::def.pk.btnr, @{Text = "Remove"; Name = [Constants]::def.pk.btnr}, [Constants]::def.frames.pk)
        # $this.gui.SysObjects.Button[([Constants]::def.pk.btnr)].Add_Click({
        #     $global:s.RemovePK()
        # })

        # $this.gui.CreateSysObject("Label", [Constants]::def.ItemInfoCaptions.IName, @{Text = "Item Name:"}, [Constants]::def.frames.item)
        # $this.gui.CreateSysObject("Label", [Constants]::def.ItemInfoCaptions.Prod, @{Text = "Production:"}, [Constants]::def.frames.item)
        # $this.gui.CreateSysObject("Label", [Constants]::def.ItemInfoCaptions.Cons, @{Text = "Consumption:"}, [Constants]::def.frames.item)
        # #$this.gui.CreateSysObject("Label", [Constants]::def.ItemInfoCaptions.Enough, @{Text = "Enough:"}, [Constants]::def.frames.item)

        # $this.gui.CreateSysObject("Label", [Constants]::def.ItemInfoValues.IName, @{Text = "Heavy Modular Frame"}, [Constants]::def.frames.item)
        # $this.gui.CreateSysObject("Label", [Constants]::def.ItemInfoValues.Prod, @{Text = "1000"}, [Constants]::def.frames.item)
        # $this.gui.CreateSysObject("Label", [Constants]::def.ItemInfoValues.Cons, @{Text = "800"}, [Constants]::def.frames.item)
        # $this.gui.CreateSysObject("Label", [Constants]::def.ItemInfoValues.Enough, @{Text = "YES"}, [Constants]::def.frames.item)

        
        # $this.gui.CreateSysObject("Label", [Constants]::def.RInfoCaptions.Name, @{Text = "Recipe Name:"}, [Constants]::def.frames.recipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.RInfoCaptions.RProd, @{Text = "Production for Recipe:"}, [Constants]::def.frames.recipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.RInfoCaptions.OutName, @{Text = "Main Output Item:"}, [Constants]::def.frames.recipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.RInfoCaptions.OutCount, @{Text = "Main Output Count:"}, [Constants]::def.frames.recipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.RInfoCaptions.SecName, @{Text = "Secondary Output Item:"}, [Constants]::def.frames.recipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.RInfoCaptions.SecCount, @{Text = "Secondary Output Count:"}, [Constants]::def.frames.recipe)

        # $this.gui.CreateSysObject("Label", [Constants]::def.RInfoMain.iName, @{Text = "Iron Ingot"}, [Constants]::def.frames.recipe)
        # $this.gui.CreateSysObject("NumericUpDown", [Constants]::def.SetProd.iRProd, @{Maximum = 10000000; DecimalPlaces = 2}, [Constants]::def.frames.recipe)
        # $this.gui.CreateSysObject("Button", [Constants]::def.SetProd.setProd, @{Text = "Set Production"; Name = [Constants]::def.SetProd.setProd}, [Constants]::def.frames.recipe)
        # $this.gui.SysObjects.Button[([Constants]::def.SetProd.setProd)].Add_Click({
        #     $global:s.SetProductionGUI()
        # })
        # $this.gui.CreateSysObject("Label", [Constants]::def.RInfoMain.iOutName, @{Text = "Iron Ingot"}, [Constants]::def.frames.recipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.RInfoMain.iOutCount, @{Text = "3"}, [Constants]::def.frames.recipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.RInfoMain.iSecName, @{Text = "Iron Dust"}, [Constants]::def.frames.recipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.RInfoMain.iSecCount, @{Text = "4"}, [Constants]::def.frames.recipe)
        
        # $this.gui.CreateSysObject("Label", [Constants]::def.iRHead[0], @{Text = "Item"}, [Constants]::def.frames.recipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.iRHead[1], @{Text = "Count"}, [Constants]::def.frames.recipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.iRHead[2], @{Text = "Ratio"}, [Constants]::def.frames.recipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.iRHead[3], @{Text = "Consumption"}, [Constants]::def.frames.recipe)

        # $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRName[0], @{Text = "Rubber"}, [Constants]::def.frames.recipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRName[1], @{Text = "Plastic"}, [Constants]::def.frames.recipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRName[2], @{Text = "Adaptive Control Unit"}, [Constants]::def.frames.recipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRName[3], @{Text = "Heavy Modular Frame"}, [Constants]::def.frames.recipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRName[4], @{Text = "Heavy Oil"}, [Constants]::def.frames.recipe)

        # $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRCount[0], @{Text = "1"}, [Constants]::def.frames.recipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRCount[1], @{Text = "10"}, [Constants]::def.frames.recipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRCount[2], @{Text = "100"}, [Constants]::def.frames.recipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRCount[3], @{Text = "999"}, [Constants]::def.frames.recipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRCount[4], @{Text = "999"}, [Constants]::def.frames.recipe)

        # $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRRatio[0], @{Text = "2.000000"}, [Constants]::def.frames.recipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRRatio[1], @{Text = "2.000000"}, [Constants]::def.frames.recipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRRatio[2], @{Text = "2.000000"}, [Constants]::def.frames.recipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRRatio[3], @{Text = "2.000000"}, [Constants]::def.frames.recipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRRatio[4], @{Text = "2.000000"}, [Constants]::def.frames.recipe)

        # $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRCon[0], @{Text = "1000000"}, [Constants]::def.frames.recipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRCon[1], @{Text = "1000000"}, [Constants]::def.frames.recipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRCon[2], @{Text = "1000000"}, [Constants]::def.frames.recipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRCon[3], @{Text = "1000000"}, [Constants]::def.frames.recipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRCon[4], @{Text = "1000000"}, [Constants]::def.frames.recipe)

        # $this.gui.CreateSysObject("Label", [Constants]::def.tb_iName, @{TextAlign = "MiddleCenter"; Font = $global:font2; Text = "Item Name:"}, [Constants]::def.frames.addItem)
        # $this.gui.CreateSysObject("TextBox", [Constants]::def.tb_iName, @{Text = ""}, [Constants]::def.frames.addItem)
        # $this.gui.CreateSysObject("Button", [Constants]::def.btn_addItem, @{Text = "Add Item"; Name = [Constants]::def.btn_addItem}, [Constants]::def.frames.addItem)
        # $this.gui.SysObjects.Button[([Constants]::def.btn_addItem)].Add_Click({
        #     $addItemOutput = $global:s.AddItem($global:s.gui.SysObjects.TextBox[([Constants]::def.tb_iName)].Text)
        #     if($addItemOutput.status){
        #         $global:s.RefreshItemList()
        #         $global:s.ClearRecipeLists()
        #     }
        #     else{
        #         $global:s.gui.CreateMsgForm("AddItem", "Add Item", $false, $addItemOutput.msg)
        #     }
        # })

        # $this.gui.CreateSysObject("Label", [Constants]::def.AddingRecipe.R1, @{Text = "Ingredient 1:"}, [Constants]::def.frames.addRecipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.AddingRecipe.R2, @{Text = "Ingredient 2:"}, [Constants]::def.frames.addRecipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.AddingRecipe.R3, @{Text = "Ingredient 3:"}, [Constants]::def.frames.addRecipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.AddingRecipe.R4, @{Text = "Ingredient 4:"}, [Constants]::def.frames.addRecipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.AddingRecipe.R5, @{Text = "Ingredient 5:"}, [Constants]::def.frames.addRecipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.AddingRecipe.Out, @{Text = "Output:"}, [Constants]::def.frames.addRecipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.AddingRecipe.S1, @{Text = "Second Output:"}, [Constants]::def.frames.addRecipe)

        # $this.gui.CreateSysObject("ComboBox", [Constants]::def.AddingRecipe.R1, @{}, [Constants]::def.frames.addRecipe)
        # $this.gui.CreateSysObject("ComboBox", [Constants]::def.AddingRecipe.R2, @{}, [Constants]::def.frames.addRecipe)
        # $this.gui.CreateSysObject("ComboBox", [Constants]::def.AddingRecipe.R3, @{}, [Constants]::def.frames.addRecipe)
        # $this.gui.CreateSysObject("ComboBox", [Constants]::def.AddingRecipe.R4, @{}, [Constants]::def.frames.addRecipe)
        # $this.gui.CreateSysObject("ComboBox", [Constants]::def.AddingRecipe.R5, @{}, [Constants]::def.frames.addRecipe)
        # $this.gui.CreateSysObject("ComboBox", [Constants]::def.AddingRecipe.Out, @{}, [Constants]::def.frames.addRecipe)
        # $this.gui.CreateSysObject("ComboBox", [Constants]::def.AddingRecipe.S1, @{}, [Constants]::def.frames.addRecipe)
        
        # $this.gui.CreateSysObject("NumericUpDown", [Constants]::def.AddingRecipe.R1, @{Maximum = 1000; DecimalPlaces = 1}, [Constants]::def.frames.addRecipe)
        # $this.gui.CreateSysObject("NumericUpDown", [Constants]::def.AddingRecipe.R2, @{Maximum = 1000; DecimalPlaces = 1}, [Constants]::def.frames.addRecipe)
        # $this.gui.CreateSysObject("NumericUpDown", [Constants]::def.AddingRecipe.R3, @{Maximum = 1000; DecimalPlaces = 1}, [Constants]::def.frames.addRecipe)
        # $this.gui.CreateSysObject("NumericUpDown", [Constants]::def.AddingRecipe.R4, @{Maximum = 1000; DecimalPlaces = 1}, [Constants]::def.frames.addRecipe)
        # $this.gui.CreateSysObject("NumericUpDown", [Constants]::def.AddingRecipe.R5, @{Maximum = 1000; DecimalPlaces = 1}, [Constants]::def.frames.addRecipe)
        # $this.gui.CreateSysObject("NumericUpDown", [Constants]::def.AddingRecipe.Out, @{Maximum = 1000; DecimalPlaces = 1}, [Constants]::def.frames.addRecipe)
        # $this.gui.CreateSysObject("NumericUpDown", [Constants]::def.AddingRecipe.S1, @{Maximum = 1000; DecimalPlaces = 1}, [Constants]::def.frames.addRecipe)

        # $this.gui.CreateSysObject("Label", [Constants]::def.AddingRecipe.RProd, @{Text = "Production:"}, [Constants]::def.frames.addRecipe)
        # $this.gui.CreateSysObject("Label", [Constants]::def.AddingRecipe.RName, @{Text = "Recipe Name:"}, [Constants]::def.frames.addRecipe)
        # $this.gui.CreateSysObject("NumericUpDown", [Constants]::def.AddingRecipe.RProd, @{Maximum = 10000000; DecimalPlaces = 2}, [Constants]::def.frames.addRecipe)
        # $this.gui.CreateSysObject("TextBox", [Constants]::def.AddingRecipe.RName, @{}, [Constants]::def.frames.addRecipe)

        # $this.gui.CreateSysObject("Button", [Constants]::def.AddRBTN.addRecipe, @{Text = "Add Recipe"; Name = [Constants]::def.AddRBTN.addRecipe}, [Constants]::def.frames.addRecipe)
        # $this.gui.SysObjects.Button[([Constants]::def.AddRBTN.addRecipe)].Add_Click({
        #     $global:s.AddRecipeGUI()
        # })
        # $this.gui.CreateSysObject("Button", [Constants]::def.AddRBTN.editRecipe, @{Text = "Edit Recipe"; Name = [Constants]::def.AddRBTN.editRecipe}, [Constants]::def.frames.addRecipe)
        # $this.gui.SysObjects.Button[([Constants]::def.AddRBTN.editRecipe)].Add_Click({
        #     $global:s.EditRecipeGUI()
        # })

        # $this.gui.CreateSysObject("Button", [Constants]::def.btn_save, @{Text = "Save"; Name = [Constants]::def.btn_save}, [Constants]::def.frames.other)
        # $this.gui.SysObjects.Button[([Constants]::def.btn_save)].Add_Click({
        #     $global:s.SaveConfig()
        # })
        # $this.gui.CreateSysObject("Button", [Constants]::def.btn_quit, @{Text = "Quit"; Name = [Constants]::def.btn_quit}, [Constants]::def.frames.other)
        # $this.gui.SysObjects.Button[([Constants]::def.btn_quit)].Add_Click({
        #     $global:s.Quit()
        # })

        # Distribute Settings
        
        # $allLists = ([Array] ([Constants]::def.list.Values))
        # $allMainCaptions = ([Array] ([Constants]::def.ItemInfoCaptions.Values) + [Array] ([Constants]::def.RInfoCaptions.Values) + [Array] ([Constants]::def.AddingRecipe.Values))
        # $allMainInfos = [Array] ([Constants]::def.ItemInfoValues.Values) + [Array] ([Constants]::def.RInfoMain.Values)
        # $allIngInfos = ([Constants]::def.RInfoIng.iRName) + ([Constants]::def.RInfoIng.iRCount) + ([Constants]::def.RInfoIng.iRRatio) + ([Constants]::def.RInfoIng.iRCon)
        # $clickableLabels = ([Constants]::def.RInfoIng.iRName) + [Constants]::def.RInfoMain.iOutName + [Constants]::def.RInfoMain.iSecName
        # foreach($lbl in $clickableLabels){
        #     $this.gui.SysObjects.Label[($lbl)].Add_Click({
        #         $global:s.LabelClick($this.Text)
        #     })
        # }
        # foreach($l in $allLists){
        #     $this.gui.SysObjects.ListBox[$l].Font = $global:font1
        #     $this.gui.SysObjects.Label[$l].Font = $global:font2
        #     $this.gui.SysObjects.Label[$l].TextAlign = "MiddleCenter"
        # }
        
        # foreach($l in ($allMainCaptions + ([Constants]::def.iRHead))){
        #     $this.gui.SysObjects.Label[$l].Font = $global:font2
        # }

        # foreach($l in ($allMainCaptions + $allMainInfos)){
        #     $this.gui.SysObjects.Label[$l].TextAlign = "MiddleLeft"
        # }
        # foreach($l in ($allMainInfos + $allIngInfos)){
        #     $this.gui.SysObjects.Label[$l].Font = $global:font1
        #     $this.gui.SysObjects.Label[$l].BackColor = "White"
        #     $this.gui.SysObjects.Label[$l].BorderStyle = "Fixed3D"
        # }

        # foreach($l in ([Constants]::def.iRHead + $allIngInfos)){
        #         $this.gui.SysObjects.Label[$l].TextAlign = "MiddleCenter"
        # }

        # foreach($l in ([Constants]::def.iRHead)){
        #     $this.gui.SysObjects.Label[$l].BorderStyle = "Fixed3D"
        # }

        # foreach($button in ([Array] $this.gui.SysObjects.Button.keys)){
        #     $this.gui.SysObjects.Button[$button].Font = $global:font1
        # }

        # foreach($tb in ([Array] $this.gui.SysObjects.TextBox.keys)){
        #     $this.gui.SysObjects.TextBox[$tb].Font = $global:font1
        # }

        # foreach($cb in ([Array] $this.gui.SysObjects.ComboBox.keys)){
        #     $this.gui.SysObjects.ComboBox[$cb].Font = $global:font1
        # }

        # foreach($nud in ([Array] $this.gui.SysObjects.NumericUpDown.keys)){
        #     $this.gui.SysObjects.NumericUpDown[$nud].Font = $global:font1
        # }
        $this.gui.ApplyToSysObject((Join-Path $PSScriptRoot "MovieDB-GUI.json"))
        $this.RefreshGUI()
        $this.gui.SysObjects.Form[([Constants]::def.form)].ShowDialog()
    }
    [void] ClearLists(){
        $this.gui.SysObjects.ListBox[([Constants]::def.list.item)].Items.Clear()
        $this.gui.SysObjects.ListBox[([Constants]::def.list.actor)].Items.Clear()
        # $this.ClearRecipeLists()
    }
    # [void] ClearRecipeLists(){
    #     $this.gui.SysObjects.ListBox[([Constants]::def.list.mainRecipe)].Items.Clear()
    #     $this.gui.SysObjects.ListBox[([Constants]::def.list.secRecipe)].Items.Clear()
    #     $this.gui.SysObjects.ListBox[([Constants]::def.list.usedIn)].Items.Clear()
    # }
    [void] RefreshGUI(){
        $this.ClearLists()
        $this.RefreshItemList()
        $this.RefreshActorList()
        # $this.ClearRecipeInfo()
        # $this.RefreshPK()
    }
    [void] RefreshItemList(){
        $this.log.WriteStep("RefreshItemList")
        #$this.UpdateItems()
        $this.gui.SysObjects.ListBox[([Constants]::def.list.item)].Items.Clear()
        $selectedType = $global:s.gui.SysObjects.ComboBox[([Constants]::def.dd.type)].SelectedItem
        $this.gui.ApplyToSysObject("ListBox", ([Constants]::def.list.item), @{List = [Array] $this.Items[$selectedType].Title})
        # $this.ClearItemInfo()
        # $this.RefreshAddRComboBoxes()
    }
    [void] RefreshActorList(){
        $this.log.WriteStep("RefreshActorList")
        #$this.UpdateItems()
        $this.gui.SysObjects.ListBox[([Constants]::def.list.actor)].Items.Clear()
        $this.gui.ApplyToSysObject("ListBox", ([Constants]::def.list.actor), @{List = [Array] $this.Actors.Name})
        # $this.ClearItemInfo()
        # $this.RefreshAddRComboBoxes()
    }
    # [void] RefreshAddRComboBoxes(){
    #     $this.log.WriteStep("RefreshAddRComboBoxes")
    #     $list = [ArrayList] (([Array] $this.Items.Name) | Sort-Object)
    #     if($null -eq $list){ $list = [ArrayList] @()}
    #     $list.Insert(0, "None")
    #     $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.R1)].Items.clear()
    #     $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.R2)].Items.clear()
    #     $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.R3)].Items.clear()
    #     $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.R4)].Items.clear()
    #     $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.R5)].Items.clear()
    #     $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.Out)].Items.clear()
    #     $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.S1)].Items.clear()
    #     $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.R1)].Items.AddRange([Array] $list)
    #     $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.R2)].Items.AddRange([Array] $list)
    #     $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.R3)].Items.AddRange([Array] $list)
    #     $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.R4)].Items.AddRange([Array] $list)
    #     $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.R5)].Items.AddRange([Array] $list)
    #     $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.Out)].Items.AddRange([Array] $list)
    #     $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.S1)].Items.AddRange([Array] $list)
    #     $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.R1)].SelectedIndex = 0
    #     $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.R2)].SelectedIndex = 0
    #     $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.R3)].SelectedIndex = 0
    #     $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.R4)].SelectedIndex = 0
    #     $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.R5)].SelectedIndex = 0
    #     $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.Out)].SelectedIndex = 0
    #     $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.S1)].SelectedIndex = 0
    #     $this.gui.SysObjects.NumericUpDown[([Constants]::def.AddingRecipe.R1)].Value = 0
    #     $this.gui.SysObjects.NumericUpDown[([Constants]::def.AddingRecipe.R2)].Value = 0
    #     $this.gui.SysObjects.NumericUpDown[([Constants]::def.AddingRecipe.R3)].Value = 0
    #     $this.gui.SysObjects.NumericUpDown[([Constants]::def.AddingRecipe.R4)].Value = 0
    #     $this.gui.SysObjects.NumericUpDown[([Constants]::def.AddingRecipe.R5)].Value = 0
    #     $this.gui.SysObjects.NumericUpDown[([Constants]::def.AddingRecipe.Out)].Value = 0
    #     $this.gui.SysObjects.NumericUpDown[([Constants]::def.AddingRecipe.S1)].Value = 0
    #     $this.gui.SysObjects.NumericUpDown[([Constants]::def.AddingRecipe.RProd)].Value = 0
    # }
    # [void] RefreshPK(){
    #     $this.gui.SysObjects.ComboBox[([Constants]::def.pk.cb)].Items.clear()
    #     $this.gui.SysObjects.ComboBox[([Constants]::def.pk.cb)].Items.AddRange([Array] $this.AllProduktionKeys)
    #     $this.gui.SysObjects.ComboBox[([Constants]::def.pk.cb)].SelectedIndex = 0
    # }
    # [void] ChangePK(){
    #     $this.ProduktionKey = $this.gui.SysObjects.ComboBox[([Constants]::def.pk.cb)].SelectedItem
    #     $this.RefreshItemList()
    #     $this.ShowItemInfo()
    #     $this.ShowRecipeInfo()
    # }
    # [void] AddPK(){
    #     $val = $this.gui.SysObjects.TextBox[([Constants]::def.pk.tb)].Text
    #     if([String]::IsNullOrWhiteSpace($val) -or ($this.AllProduktionKeys -contains $val)){
    #         return
    #     }
    #     $this.AllProduktionKeys.Add($val)
    #     foreach($recipe in $this.Recipes){
    #         $recipe.SetProduction($val, 0)
    #     }
    #     $this.RefreshPK()
    #     $this.gui.SysObjects.ComboBox[([Constants]::def.pk.cb)].SelectedItem = $val
    # }
    # [void] RemovePK(){
    #     $val = $this.gui.SysObjects.ComboBox[([Constants]::def.pk.cb)].SelectedItem 
    #     foreach($recipe in $this.Recipes){
    #         $recipe.Production.Remove($val)
    #     }
    #     $this.AllProduktionKeys.Remove($val)
    #     $this.RefreshPK()
    #     $this.gui.SysObjects.ComboBox[([Constants]::def.pk.cb)].SelectedIndex = 0
    # }
    # [void] SetRecipeLists(){
    #     $this.ClearRecipeLists()
    #     $this.ClearRecipeInfo()
    #     $selectedItem = $this.GetItemByName($this.gui.SysObjects.ListBox[([Constants]::def.list.item)].SelectedItem)
    #     $this.log.WriteInfo($selectedItem.MainRecipes.Name)
    #     $this.log.WriteInfo($selectedItem.SecondaryRecipes.Name)
    #     $this.log.WriteInfo($selectedItem.IngredientRecipes.Name)
    #     if($null -ne $selectedItem.MainRecipes.Name){
    #         $this.gui.ApplyToSysObject("ListBox", ([Constants]::def.list.mainRecipe), @{List = [Array] (([Array] $selectedItem.MainRecipes.Name) | Sort-Object)})
    #     }
    #     if($null -ne $selectedItem.SecondaryRecipes.Name){
    #         $this.gui.ApplyToSysObject("ListBox", ([Constants]::def.list.secRecipe), @{List = [Array] (([Array] $selectedItem.SecondaryRecipes.Name) | Sort-Object)})
    #     }
    #     if($null -ne $selectedItem.IngredientRecipes.Name){
    #         $this.gui.ApplyToSysObject("ListBox", ([Constants]::def.list.usedIn), @{List = [Array] (([Array] $selectedItem.IngredientRecipes.Name) | Sort-Object)})
    #     }
    # }
    # [void] ClearItemInfo(){
    #     $this.gui.ApplyToSysObject("Label", ([Constants]::def.ItemInfoValues.IName), @{Text = " "})
    #     $this.gui.ApplyToSysObject("Label", ([Constants]::def.ItemInfoValues.Prod), @{Text = " "})
    #     $this.gui.ApplyToSysObject("Label", ([Constants]::def.ItemInfoValues.Cons), @{Text = " "})
    #     $this.gui.ApplyToSysObject("Label", ([Constants]::def.ItemInfoValues.Enough), @{Text = " "; BackColor = "White"})
    # }
    # [void] ShowItemInfo(){
    #     if($this.gui.SysObjects.ListBox[([Constants]::def.list.item)].SelectedIndex -eq -1){
    #         return
    #     }
    #     $this.ClearItemInfo()
    #     $selectedItem = $this.GetItemByName($this.gui.SysObjects.ListBox[([Constants]::def.list.item)].SelectedItem)
    #     $recipeName = $selectedItem.Name
    #     $recipeNameInit = $recipeName
    #     $counter = 1
    #     while($null -ne $this.GetRecipeByName($recipeName)){
    #         $counter++
    #         $recipeName = "$recipeNameInit ($counter)"
    #     }
    #     $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.Out)].SelectedItem = $selectedItem.Name
    #     $this.gui.ApplyToSysObject("TextBox", ([Constants]::def.AddingRecipe.RName), @{Text = $recipeName})
    #     $this.gui.ApplyToSysObject("Label", ([Constants]::def.ItemInfoValues.IName), @{Text = $selectedItem.Name})
    #     $this.gui.ApplyToSysObject("Label", ([Constants]::def.ItemInfoValues.Prod), @{Text = $selectedItem.GetProduction($this.ProduktionKey).ToString()})
    #     $this.gui.ApplyToSysObject("Label", ([Constants]::def.ItemInfoValues.Cons), @{Text = $selectedItem.GetConsumption($this.ProduktionKey).ToString()})

    #     $enoughProps = @{Text = "NO"; BackColor = "Red"}
    #     if ($selectedItem.IsEnoughProduction($this.ProduktionKey)) {
    #         $enoughProps = @{Text = "YES"; BackColor = "Green"}
    #     }
    #     $this.gui.ApplyToSysObject("Label", ([Constants]::def.ItemInfoValues.Enough), $enoughProps)
    # }
    # [void] ClearRecipeInfo(){
    #     $allInfoLabels = [Array] ([Constants]::def.RInfoMain.Values) + ([Constants]::def.RInfoIng.iRName) + ([Constants]::def.RInfoIng.iRCount) + ([Constants]::def.RInfoIng.iRRatio) + ([Constants]::def.RInfoIng.iRCon)
    #     foreach($labelName in $allInfoLabels){
    #         $this.gui.ApplyToSysObject("Label", $labelName, @{Text = " "})
    #     }
    #     $this.gui.SysObjects.NumericUpDown[([Constants]::def.SetProd.iRProd)].Value = 0
    #     $this.gui.SysObjects.Button[([Constants]::def.SetProd.SetProd)].Enabled = $false
    #     $this.SelectedRecipe = $null
    #     $this.EditRecipe = $false
    #     $this.gui.ApplyToSysObject("Button", ([Constants]::def.AddRBTN.addRecipe), @{Text = "Add Recipe"})
    #     $this.gui.SysObjects.Button[([Constants]::def.AddRBTN.editRecipe)].Enabled = $false
    # }
    # [void] ShowRecipeInfo(){
    #     $key = @("mainRecipe", "secRecipe", "usedIn") | Where-Object{$this.gui.SysObjects.ListBox[([Constants]::def.list[$_])].SelectedIndex -ne -1}
    #     if ($null -eq $key) {
    #         return
    #     }
    #     $fromList = [Constants]::def.list[$key]
    #     $this.ClearRecipeInfo()
    #     $this.gui.SysObjects.Button[([Constants]::def.AddRBTN.editRecipe)].Enabled = $true
    #     $this.RefreshAddRComboBoxes()
    #     $this.SelectedRecipe = $this.GetRecipeByName($this.gui.SysObjects.ListBox[$fromList].SelectedItem)
    #     $this.gui.SysObjects.Button[([Constants]::def.SetProd.SetProd)].Enabled = $true
    #     $this.gui.ApplyToSysObject("Label", [Constants]::def.RInfoMain.iName, @{Text = $this.SelectedRecipe.Name})
    #     $this.gui.ApplyToSysObject("Label", [Constants]::def.RInfoMain.iOutName, @{Text = $this.SelectedRecipe.Output.Item.Name})
    #     $this.gui.ApplyToSysObject("Label", [Constants]::def.RInfoMain.iOutCount, @{Text = $this.SelectedRecipe.Output.ACount})
    #     if($null -ne $this.SelectedRecipe.SecondOutput){
    #         $this.gui.ApplyToSysObject("Label", [Constants]::def.RInfoMain.iSecName, @{Text = $this.SelectedRecipe.SecondOutput.Item.Name})
    #         $this.gui.ApplyToSysObject("Label", [Constants]::def.RInfoMain.iSecCount, @{Text = $this.SelectedRecipe.SecondOutput.ACount})
    #     }
    #     $this.gui.SysObjects.NumericUpDown[([Constants]::def.SetProd.iRProd)].Value = $this.SelectedRecipe.Production[$this.ProduktionKey]
    #     foreach($ingredient in $this.SelectedRecipe.Ingredients){
    #         $index = $this.SelectedRecipe.Ingredients.IndexOf($ingredient)
    #         $this.gui.ApplyToSysObject("Label", [Constants]::def.RInfoIng.iRName[$index], @{Text = $ingredient.Item.Name})
    #         $this.gui.ApplyToSysObject("Label", [Constants]::def.RInfoIng.iRCount[$index], @{Text = $ingredient.ACount.ToString()})
    #         $this.gui.ApplyToSysObject("Label", [Constants]::def.RInfoIng.iRRatio[$index], @{Text = $this.SelectedRecipe.GetRatio($ingredient.Item).ToString()})
    #         $this.gui.ApplyToSysObject("Label", [Constants]::def.RInfoIng.iRCon[$index], @{Text = $this.SelectedRecipe.GetConsumption($this.ProduktionKey, $ingredient.Item).ToString()})
    #     }
    # }
    # [void] LabelClick([String] $itemName){
    #     $item = $this.GetItemByName($itemName)
    #     if($null -ne $item){
    #         $this.gui.SysObjects.ListBox[([Constants]::def.list.item)].SelectedItem = $item.Name
    #     }
    # } 
    # [void] SetProductionGUI(){
    #     $this.SelectedRecipe.SetProduction($this.ProduktionKey, $this.gui.SysObjects.NumericUpDown[([Constants]::def.SetProd.iRProd)].Value)
    #     $this.ShowItemInfo()
    #     $this.ShowRecipeInfo()
    # }
    # [void] AddRecipeGUI(){
    #     $name = $this.gui.SysObjects.TextBox[([Constants]::def.AddingRecipe.RName)].Text
    #     $production = $this.gui.SysObjects.NumericUpDown[([Constants]::def.AddingRecipe.RProd)].Value
    #     $ingredients = [ArrayList] @()
    #     $allItems = [ArrayList] @()
    #     for($i = 1; $i -le 5; $i++){
    #         $ing = [Ingredient]::new($this.GetItemByName(
    #             $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe["R$i"])].SelectedItem),
    #             $this.gui.SysObjects.NumericUpDown[([Constants]::def.AddingRecipe["R$i"])].Value)
    #         if(($null -ne $ing.Item) -and ($ing.ACount -gt 0)){
    #             [void] $ingredients.Add($ing)
    #             [void] $allItems.Add($ing.Item.Name)
    #         }
    #     }
    #     $Output = [Ingredient]::new($this.GetItemByName(
    #         $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.Out)].SelectedItem),
    #         $this.gui.SysObjects.NumericUpDown[([Constants]::def.AddingRecipe.Out)].Value)
    #     $SecOutput = [Ingredient]::new($this.GetItemByName(
    #         $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.S1)].SelectedItem),
    #         $this.gui.SysObjects.NumericUpDown[([Constants]::def.AddingRecipe.S1)].Value)
    #     [void] $allItems.Add($Output.Item.Name)
    #     if($null -eq $SecOutput.Item){
    #         $SecOutput = $null
    #     }
    #     else {
    #         [void] $allItems.Add($SecOutput.Item.Name)
    #     }
    #     $this.log.WriteInfo($allItems, "All Added Items")
    #     $addROutput = @{status = $true}
    #     if(!$this.EditRecipe){
    #         $addROutput = $this.AddRecipe($name, $production, $Output, $SecOutput, $this.ConvertArrayOfIngredients([Array] $ingredients), $false)
    #     }   
    #     else {
    #         $this.SelectedRecipe.Name = $name
    #         $this.SelectedRecipe.SetProduction($this.ProduktionKey, $production)
    #         $this.SelectedRecipe.Output = $Output
    #         $this.SelectedRecipe.SecondOutput = $SecOutput
    #         $this.SelectedRecipe.Ingredients = $this.ConvertArrayOfIngredients([Array] $ingredients)
    #     }
    #     if(($this.EditRecipe) -or ($addROutput.status)){
    #         $selectedItem = $this.gui.SysObjects.ListBox[([Constants]::def.list.item)].SelectedItem
    #         $this.SetItemRecipes([Array] $allItems)
    #         $this.RefreshItemList()
    #         $this.ClearRecipeLists()
    #         $this.ClearRecipeInfo()
    #         $this.gui.SysObjects.ListBox[([Constants]::def.list.item)].SelectedItem = $selectedItem
    #     }
    #     else{
    #         $this.gui.CreateMsgForm("AddRecipe", "Add Recipe", $false, $addROutput.msg)
    #     }
    # }
    # [void] EditRecipeGUI(){
    #     $this.EditRecipe = $true
    #     $this.gui.ApplyToSysObject("Button", ([Constants]::def.AddRBTN.addRecipe), @{Text = "Save Recipe"})
    #     $this.gui.SysObjects.TextBox[([Constants]::def.AddingRecipe.RName)].Text = $this.SelectedRecipe.Name
    #     $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.Out)].SelectedItem = $this.SelectedRecipe.Output.Item.Name
    #     $this.gui.SysObjects.NumericUpDown[([Constants]::def.AddingRecipe.Out)].Value = $this.SelectedRecipe.Output.ACount
    #     if($null -ne $this.SelectedRecipe.SecondOutput){
    #         $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.S1)].SelectedItem = $this.SelectedRecipe.SecondOutput.Item.Name
    #         $this.gui.SysObjects.NumericUpDown[([Constants]::def.AddingRecipe.S1)].Value = $this.SelectedRecipe.SecondOutput.ACount
    #     }
    #     for ($i = 0; $i -lt $this.SelectedRecipe.Ingredients.Count; $i++) {
    #         $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe["R$($i + 1)"])].SelectedItem = $this.SelectedRecipe.Ingredients[$i].Item.Name
    #         $this.gui.SysObjects.NumericUpDown[([Constants]::def.AddingRecipe["R$($i + 1)"])].Value = $this.SelectedRecipe.Ingredients[$i].ACount
    #     }
    #     $this.gui.SysObjects.NumericUpDown[([Constants]::def.AddingRecipe.RProd)].Value = $this.SelectedRecipe.Production[$this.ProduktionKey]
    # }
    [void] Quit(){
        $this.gui.SysObjects.Form[[Constants]::def.form].Close()
        $this.gui.SysObjects.Form[[Constants]::def.form].Dispose()
    }
}
$global:font1 = [Font]::new("Microsoft Sans Serif",12,[FontStyle]::Regular)
$global:font2 = [Font]::new("Microsoft Sans Serif",12,[FontStyle]::Bold)
$global:brushes = @{
    Green = [SolidBrush]::new([Color]::Green);
    LightGreen = [SolidBrush]::new([Color]::LightGreen);
    White = [SolidBrush]::new([Color]::White);
    Blue = [SolidBrush]::new([Color]::LightBlue);
    LightRed = [SolidBrush]::new([Color]::Red);
    Red = [SolidBrush]::new([Color]::DarkRed)
}
$global:CT=[System.Drawing.SystemBrushes]::ControlText   


# using module D:\Y-Downloads\Minecraft\OC-Scripts\SatisfactoryItemsGUI.psm1
# $s = [Satisfactory]::new()
# $s.AddItem("a")
# $s.AddItem("b")
# $s.AddItem("c")
# $s.AddItem("d")
# $s.AddItem("e")
# $s.AddItem("f")
# $s.AddRecipe("a", 
#              [Ingredient]::new($s.GetItemByName("a"),2),
#              [Ingredient]::new($s.GetItemByName("d"),1),
#              $s.ConvertArrayOfIngredients(@(
#                 [Ingredient]::new($s.GetItemByName("b"),3),
#                 [Ingredient]::new($s.GetItemByName("c"),4)
#              )))

$global:s = [MovieDB]::new()
$global:s.ShowForm()