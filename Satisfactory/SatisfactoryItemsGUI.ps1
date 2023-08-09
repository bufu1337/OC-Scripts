using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.IO
using namespace System.Management.Automation
using namespace System.Data
using namespace System.Drawing
using module .\GUICreator.psm1
using module .\Functions.psm1
using module .\Logging.psm1

class Constants{
    static [String] ConfigPath(){return "$PSScriptRoot\Satisfactory.json"}
    static [Hashtable] GetConfig(){
        return [Functions]::GetJsonHash(([Constants]::ConfigPath()))
    }
    static [void] SaveConfig([Hashtable] $Config){
        $Config | ConvertTo-Json -Depth 4 | Out-File ([Constants]::ConfigPath())
        Write-Host Config saved to ([Constants]::ConfigPath())
    }
    static [Hashtable] $def = @{
        # Main
        form = "SF";
        formtext = "Satisfactory";

        frames = @{
            lists = "fLists";
            item = "fItem";
            recipe = "fRecipe";
            addItem = "fAddItem";
            addRecipe = "fAddRecipe";
            other = "fother"
        };

        # Info
        list = @{
            item = "Items";
            mainRecipe = "MainR";
            secRecipe = "SecR";
            usedIn = "UiR"
        };

        ItemInfoCaptions = @{
            IName = "capIName";
            Prod = "capProd";
            Cons = "capCons";
            Enough = "capEnough"
        };
        ItemInfoValues = @{
            IName = "valIName";
            Prod = "valProd";
            Cons = "valCons";
            Enough = "valEnough"
        };

        # Adding Recipe
        AddingRecipe = @{
            R1 = "R1";
            R2 = "R2";
            R3 = "R3";
            R4 = "R4";
            Out = "Out";
            S1 = "S1";
            RProd = "RProd";
            RName = "RName";
        };
        AddRBTN = @{
            addRecipe="AddR";
            editRecipe="EditR"
        };
        SetProd = @{
            setProd="SetProd";
            iRProd= "iRProd";
        };
        # Recipe Info
        RInfoCaptions = @{
            Name = "capiRName";
            RProd= "capiRProd";
            OutCount = "capiOC";
            OutName = "capiON";
            SecCount = "capiSC";
            SecName = "capiSN"
        };
        RInfoMain = @{
            iName = "iRName";
            iOutCount = "iOC";
            iOutName = "iON";
            iSecCount = "iSC";
            iSecName = "iSN"
        };
        iRHead = @("iIName","iRCount","iRRatio","iRCon");
        RInfoIng = @{
            iRName = @("iR1N","iR2N","iR3N","iR4N");
            iRCount = @("iR1C","iR2C","iR3C","iR4C");
            iRRatio = @("iR1R","iR2R","iR3R","iR4R");
            iRCon = @("iR1Con","iR2Con","iR3Con","iR4Con")
        };
        
        # Adding Item
        tb_iName = "IName";
        btn_addItem="AddI";

        # Other
        btn_save="Save";
        btn_quit="Quit"
    }
}

class Ingredient{
    [Item] $Item
    [Float] $ACount

    Ingredient([Item] $Item, [Float] $ACount){
        $this.Item = $Item
        $this.ACount = $ACount
    }

    [Hashtable] ConvertToHash(){
        return @{Name = $this.Item.Name; ACount = $this.ACount}
    }
}
class Recipe{
    [String] $Name
    [Float] $Production
    [Ingredient] $Output
    [Ingredient] $SecondOutput
    [List[Ingredient]] $Ingredients

    Recipe([String] $Name, [Ingredient] $Output, [Ingredient] $SecondOutput, [List[Ingredient]] $Ingredients){
        $this.Name = $Name
        $this.Output = $Output
        $this.SecondOutput = $SecondOutput
        $this.Ingredients = $Ingredients
    }

    [void] SetProduction([Float] $Production){
        $this.Production = $Production
    }

    [Boolean] IsIngredient([Item] $Item){
        return ($null -ne ($this.Ingredients | Where-Object{ $_.Item -eq $Item }))
    }

    [Float] GetConsumption([Item] $Item){
        if(!$this.IsIngredient($Item)){
            return 0
        }
        return $this.Production / $this.Output.ACount * ($this.Ingredients | Where-Object{ $_.Item -eq $Item }).ACount
    }

    [Float] GetRatio([Item] $Item){
        if(!$this.IsIngredient($Item)){
            return 0
        }
        return ($this.Ingredients | Where-Object{ $_.Item -eq $Item }).ACount / $this.Output.ACount
    }

    [Float] GetSecondaryProduction(){
        if($null -eq $this.SecondOutput){
            return 0
        }
        return $this.Production / $this.Output.ACount * $this.SecondOutput.ACount
    }

    [Hashtable] ConvertToHash(){
        $result = @{
            Name = $this.Name; 
            Production = $this.Production; 
            Output = $this.Output.ConvertToHash(); 
            SecondOutput = $null;
            Ingredients = $null
        }
        if($null -ne $this.SecondOutput){
            $result.SecondOutput = $this.SecondOutput.ConvertToHash()
        }
        if(($null -ne $this.Ingredients) -and ($this.Ingredients.Count -gt 0)){
            $result.Ingredients = [Array] $this.Ingredients.ConvertToHash()
        }
        return $result
    }
}
class Item{
    [String] $Name
    [List[Recipe]] $MainRecipes
    [List[Recipe]] $SecondaryRecipes
    [List[Recipe]] $IngredientRecipes

    Item([String] $Name){
        $this.Name = $Name
    }

    [void] GetRecipes([List[Recipe]] $AllRecipes){
        $this.MainRecipes = $AllRecipes | Where-Object{ ($_.Output.Item -eq $this) }
        $this.SecondaryRecipes = $AllRecipes | Where-Object{ ($_.SecondOutput.Item -eq $this) }
        $this.IngredientRecipes = $AllRecipes | Where-Object{ $_.IsIngredient($this) }
    }

    [Float] GetProduction(){
        $output = 0
        if($null -ne $this.MainRecipes){
            $output += ($this.MainRecipes.Production | Measure-Object -sum).Sum
        }
        if($null -ne $this.SecondaryRecipes){
            $output += ($this.SecondaryRecipes.GetSecondaryProduction() | Measure-Object -sum).Sum
        }
        return $output
    }

    [Float] GetConsumption(){
        if($null -ne $this.IngredientRecipes){
            return ($this.IngredientRecipes.GetConsumption($this) | Measure-Object -sum).Sum
        }
        return 0
    }

    [Boolean] IsEnoughProduction(){
        return $this.GetProduction() -ge $this.GetConsumption()
    }
}
class Satisfactory{
    [List[Item]] $Items = [List[Item]]::new()
    [List[Recipe]] $Recipes = [List[Recipe]]::new()
    [Recipe] $SelectedRecipe
    [Boolean] $SelectedRecipeMutex = $false
    [Boolean] $EditRecipe = $false
    $gui
    $log

    Satisfactory(){
        $this.gui = [GUICreator]::new()
        $this.gui.PtoP_Visible($PSScriptRoot)
        $this.log = [Logging]::new()
        $this.LoadConfig()
    }

    [Item] GetItemByName([String] $Name){
        return $this.Items | Where-Object{$_.Name -eq $Name}
    }

    [Recipe] GetRecipeByName([String] $Name){
        return $this.Recipes | Where-Object{$_.Name -eq $Name}
    }
    [void] SetItemRecipes(){
        foreach($item in $this.Items){
            $item.GetRecipes($this.Recipes)
        }
    }
    [Hashtable] AddItem([String] $Name){
        if($null -ne $this.GetItemByName($Name)){
            $msg = "Item arleady existing: $Name"
            $this.log.WriteError($msg)
            return @{status = $false; msg = $msg }
        }
        $this.Items.Add([Item]::new($Name))
        $msg = "Item added: $Name"
        $this.log.WriteInfo($msg)
        return @{status = $true; msg = $msg}
    }

    [Hashtable] AddRecipe([String] $Name, [Float] $Production, [Ingredient] $Output, [Ingredient] $SecondOutput, [List[Ingredient]] $Ingredients, [Boolean] $SetItemRecipes){
        if($null -ne $this.GetRecipeByName($Name)){
            $msg = "Recipe arleady existing: $Name"
            $this.log.WriteError($msg)
            return @{status = $false; msg = $msg }
        }
        $this.Recipes.Add([Recipe]::new($Name, $Output, $SecondOutput, $Ingredients))
        if($SetItemRecipes){
            $this.SetItemRecipes()
        }
        $this.GetRecipeByName($Name).SetProduction($Production)
        $msg = "Recipe added: $Name"
        $this.log.WriteInfo($msg)
        return @{status = $true; msg = $msg}
    }

    [void] AddRecipe([String] $Name, [Float] $Production, [Ingredient] $Output, [Ingredient] $SecondOutput, [List[Ingredient]] $Ingredients){
        $this.AddRecipe($Name, $Production, $Output, $SecondOutput, $Ingredients, $true)
    }

    [void] AddRecipe([String] $Name, [Ingredient] $Output, [Ingredient] $SecondOutput, [List[Ingredient]] $Ingredients){
        $this.AddRecipe($Name, 0, $Output, $SecondOutput, $Ingredients)
    }

    [List[Ingredient]] ConvertArrayOfIngredients([Array] $Ingredients){
        $output = [List[Ingredient]]::new()
        foreach($ingredient in $Ingredients){
            $output.Add($ingredient)
        }
        return $output
    }

    [Ingredient] NewIngredient([String] $Name, [Float] $ACount){
        return [Ingredient]::new($this.GetItemByName($Name), $ACount)
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
        $cfg = [Constants]::GetConfig()
        foreach($item in $cfg.Items){
            $this.AddItem($item)
        }
        foreach($recipe in $cfg.Recipes){
            $secondOutput = $null
            $ingredients = $null
            if($null -ne $recipe.SecondOutput){
                $secondOutput = $this.NewIngredient($recipe.SecondOutput.Name, $recipe.SecondOutput.ACount)
            }
            if($null -ne $recipe.Ingredients){
                $ingredients = $this.ConvertArrayOfIngredients([Array] ($recipe.Ingredients | Foreach-Object{$this.NewIngredient($_.Name, $_.ACount)}))
            }
            $this.AddRecipe($recipe.Name, $recipe.Production, $this.NewIngredient($recipe.Output.Name, $recipe.Output.ACount), $secondOutput, $ingredients, $false)
        }
        $this.SetItemRecipes()
    }

    [void] ShowForm(){
        # Add GUI Elements
        $this.gui.CreateSysObject(
                "Form", [Constants]::def.form, 
                @{Size = '1600,950'; Text = [Constants]::def.formtext; MaximizeBox = $False; 
                  FormBorderStyle = "FixedDialog"; Topmost = $false; StartPosition = "CenterScreen" })
          
        $this.gui.CreateSysObject("GroupBox", [Constants]::def.frames.lists, @{}, [Constants]::def.form)
        $this.gui.CreateSysObject("GroupBox", [Constants]::def.frames.item, @{}, [Constants]::def.form)
        $this.gui.CreateSysObject("GroupBox", [Constants]::def.frames.recipe, @{}, [Constants]::def.form)
        $this.gui.CreateSysObject("GroupBox", [Constants]::def.frames.addItem, @{}, [Constants]::def.form)
        $this.gui.CreateSysObject("GroupBox", [Constants]::def.frames.addRecipe, @{}, [Constants]::def.form)
        $this.gui.CreateSysObject("GroupBox", [Constants]::def.frames.other, @{}, [Constants]::def.form)
        
        $this.gui.CreateSysObject("Label", [Constants]::def.list.item, @{Text = "Items:"}, [Constants]::def.frames.lists)
        $this.gui.CreateSysObject("ListBox", [Constants]::def.list.item, @{Name = [Constants]::def.list.item}, [Constants]::def.frames.lists)
        $this.gui.SysObjects.ListBox[([Constants]::def.list.item)].Add_SelectedIndexChanged({
            $global:s.SetRecipeLists()
            $global:s.ShowItemInfo()
        })
                    
        $this.gui.CreateSysObject("Label", [Constants]::def.list.mainRecipe, @{Text = "Main Recipes:"}, [Constants]::def.frames.lists)
        $this.gui.CreateSysObject("ListBox", [Constants]::def.list.mainRecipe, @{Name = [Constants]::def.list.mainRecipe}, [Constants]::def.frames.lists)
        $this.gui.SysObjects.ListBox[([Constants]::def.list.mainRecipe)].Add_SelectedIndexChanged({
            if(!$global:s.SelectedRecipeMutex){
                $global:s.SelectedRecipeMutex = $true
                $global:s.gui.SysObjects.ListBox[([Constants]::def.list.secRecipe)].SelectedIndex = -1
                $global:s.gui.SysObjects.ListBox[([Constants]::def.list.usedIn)].SelectedIndex = -1
                $global:s.ShowRecipeInfo([Constants]::def.list.mainRecipe)
                $global:s.SelectedRecipeMutex = $False
            }
        })
                    
        $this.gui.CreateSysObject("Label", [Constants]::def.list.secRecipe, @{Text = "Second Output Recipes:"}, [Constants]::def.frames.lists)
        $this.gui.CreateSysObject("ListBox", [Constants]::def.list.secRecipe, @{Name = [Constants]::def.list.secRecipe}, [Constants]::def.frames.lists)
        $this.gui.SysObjects.ListBox[([Constants]::def.list.secRecipe)].Add_SelectedIndexChanged({
            if(!$global:s.SelectedRecipeMutex){
                $global:s.SelectedRecipeMutex = $true
                $global:s.gui.SysObjects.ListBox[([Constants]::def.list.mainRecipe)].SelectedIndex = -1
                $global:s.gui.SysObjects.ListBox[([Constants]::def.list.usedIn)].SelectedIndex = -1
                $global:s.ShowRecipeInfo([Constants]::def.list.secRecipe)
                $global:s.SelectedRecipeMutex = $False
            }
        })
                    
        $this.gui.CreateSysObject("Label", [Constants]::def.list.usedIn, @{Text = "Used In Recipes:"}, [Constants]::def.frames.lists)
        $this.gui.CreateSysObject("ListBox", [Constants]::def.list.usedIn, @{Name = [Constants]::def.list.usedIn}, [Constants]::def.frames.lists)
        $this.gui.SysObjects.ListBox[([Constants]::def.list.usedIn)].Add_SelectedIndexChanged({
            if(!$global:s.SelectedRecipeMutex){
                $global:s.SelectedRecipeMutex = $true
                $global:s.gui.SysObjects.ListBox[([Constants]::def.list.mainRecipe)].SelectedIndex = -1
                $global:s.gui.SysObjects.ListBox[([Constants]::def.list.secRecipe)].SelectedIndex = -1
                $global:s.ShowRecipeInfo([Constants]::def.list.usedIn)
                $global:s.SelectedRecipeMutex = $False
            }
        })

        $this.gui.CreateSysObject("Label", [Constants]::def.ItemInfoCaptions.IName, @{Text = "Item Name:"}, [Constants]::def.frames.item)
        $this.gui.CreateSysObject("Label", [Constants]::def.ItemInfoCaptions.Prod, @{Text = "Production:"}, [Constants]::def.frames.item)
        $this.gui.CreateSysObject("Label", [Constants]::def.ItemInfoCaptions.Cons, @{Text = "Consumption:"}, [Constants]::def.frames.item)
        $this.gui.CreateSysObject("Label", [Constants]::def.ItemInfoCaptions.Enough, @{Text = "Enough:"}, [Constants]::def.frames.item)

        $this.gui.CreateSysObject("Label", [Constants]::def.ItemInfoValues.IName, @{Text = "Heavy Modular Frame"}, [Constants]::def.frames.item)
        $this.gui.CreateSysObject("Label", [Constants]::def.ItemInfoValues.Prod, @{Text = "1000"}, [Constants]::def.frames.item)
        $this.gui.CreateSysObject("Label", [Constants]::def.ItemInfoValues.Cons, @{Text = "800"}, [Constants]::def.frames.item)
        $this.gui.CreateSysObject("Label", [Constants]::def.ItemInfoValues.Enough, @{Text = "YES"}, [Constants]::def.frames.item)

        
        $this.gui.CreateSysObject("Label", [Constants]::def.RInfoCaptions.Name, @{Text = "Recipe Name:"}, [Constants]::def.frames.recipe)
        $this.gui.CreateSysObject("Label", [Constants]::def.RInfoCaptions.RProd, @{Text = "Production for Recipe:"}, [Constants]::def.frames.recipe)
        $this.gui.CreateSysObject("Label", [Constants]::def.RInfoCaptions.OutName, @{Text = "Main Output Item:"}, [Constants]::def.frames.recipe)
        $this.gui.CreateSysObject("Label", [Constants]::def.RInfoCaptions.OutCount, @{Text = "Main Output Count:"}, [Constants]::def.frames.recipe)
        $this.gui.CreateSysObject("Label", [Constants]::def.RInfoCaptions.SecName, @{Text = "Secondary Output Item:"}, [Constants]::def.frames.recipe)
        $this.gui.CreateSysObject("Label", [Constants]::def.RInfoCaptions.SecCount, @{Text = "Secondary Output Count:"}, [Constants]::def.frames.recipe)

        $this.gui.CreateSysObject("Label", [Constants]::def.RInfoMain.iName, @{Text = "Iron Ingot"}, [Constants]::def.frames.recipe)
        $this.gui.CreateSysObject("NumericUpDown", [Constants]::def.SetProd.iRProd, @{Maximum = 10000000; DecimalPlaces = 2}, [Constants]::def.frames.recipe)
        $this.gui.CreateSysObject("Button", [Constants]::def.SetProd.setProd, @{Text = "Set Production"; Name = [Constants]::def.SetProd.setProd}, [Constants]::def.frames.recipe)
        $this.gui.SysObjects.Button[([Constants]::def.SetProd.setProd)].Add_Click({
            $global:s.SetProductionGUI()
        })
        $this.gui.CreateSysObject("Label", [Constants]::def.RInfoMain.iOutName, @{Text = "Iron Ingot"}, [Constants]::def.frames.recipe)
        $this.gui.CreateSysObject("Label", [Constants]::def.RInfoMain.iOutCount, @{Text = "3"}, [Constants]::def.frames.recipe)
        $this.gui.CreateSysObject("Label", [Constants]::def.RInfoMain.iSecName, @{Text = "Iron Dust"}, [Constants]::def.frames.recipe)
        $this.gui.CreateSysObject("Label", [Constants]::def.RInfoMain.iSecCount, @{Text = "4"}, [Constants]::def.frames.recipe)
        
        $this.gui.CreateSysObject("Label", [Constants]::def.iRHead[0], @{Text = "Item"}, [Constants]::def.frames.recipe)
        $this.gui.CreateSysObject("Label", [Constants]::def.iRHead[1], @{Text = "Count"}, [Constants]::def.frames.recipe)
        $this.gui.CreateSysObject("Label", [Constants]::def.iRHead[2], @{Text = "Ratio"}, [Constants]::def.frames.recipe)
        $this.gui.CreateSysObject("Label", [Constants]::def.iRHead[3], @{Text = "Consumption"}, [Constants]::def.frames.recipe)

        $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRName[0], @{Text = "Rubber"}, [Constants]::def.frames.recipe)
        $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRName[1], @{Text = "Plastic"}, [Constants]::def.frames.recipe)
        $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRName[2], @{Text = "Adaptive Control Unit"}, [Constants]::def.frames.recipe)
        $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRName[3], @{Text = "Heavy Modular Frame"}, [Constants]::def.frames.recipe)

        $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRCount[0], @{Text = "1"}, [Constants]::def.frames.recipe)
        $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRCount[1], @{Text = "10"}, [Constants]::def.frames.recipe)
        $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRCount[2], @{Text = "100"}, [Constants]::def.frames.recipe)
        $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRCount[3], @{Text = "999"}, [Constants]::def.frames.recipe)

        $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRRatio[0], @{Text = "2.000000"}, [Constants]::def.frames.recipe)
        $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRRatio[1], @{Text = "2.000000"}, [Constants]::def.frames.recipe)
        $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRRatio[2], @{Text = "2.000000"}, [Constants]::def.frames.recipe)
        $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRRatio[3], @{Text = "2.000000"}, [Constants]::def.frames.recipe)

        $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRCon[0], @{Text = "1000000"}, [Constants]::def.frames.recipe)
        $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRCon[1], @{Text = "1000000"}, [Constants]::def.frames.recipe)
        $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRCon[2], @{Text = "1000000"}, [Constants]::def.frames.recipe)
        $this.gui.CreateSysObject("Label", [Constants]::def.RInfoIng.iRCon[3], @{Text = "1000000"}, [Constants]::def.frames.recipe)

        $this.gui.CreateSysObject("Label", [Constants]::def.tb_iName, @{TextAlign = "MiddleCenter"; Font = $global:font2; Text = "Item Name:"}, [Constants]::def.frames.addItem)
        $this.gui.CreateSysObject("TextBox", [Constants]::def.tb_iName, @{Text = ""}, [Constants]::def.frames.addItem)
        $this.gui.CreateSysObject("Button", [Constants]::def.btn_addItem, @{Text = "Add Item"; Name = [Constants]::def.btn_addItem}, [Constants]::def.frames.addItem)
        $this.gui.SysObjects.Button[([Constants]::def.btn_addItem)].Add_Click({
            $addItemOutput = $global:s.AddItem($global:s.gui.SysObjects.TextBox[([Constants]::def.tb_iName)].Text)
            if($addItemOutput.status){
                $global:s.RefreshItemList()
                $global:s.ClearRecipeLists()
            }
            else{
                $global:s.gui.CreateMsgForm("AddItem", "Add Item", $false, $addItemOutput.msg)
            }
        })

        $this.gui.CreateSysObject("Label", [Constants]::def.AddingRecipe.R1, @{Text = "Ingredient 1:"}, [Constants]::def.frames.addRecipe)
        $this.gui.CreateSysObject("Label", [Constants]::def.AddingRecipe.R2, @{Text = "Ingredient 2:"}, [Constants]::def.frames.addRecipe)
        $this.gui.CreateSysObject("Label", [Constants]::def.AddingRecipe.R3, @{Text = "Ingredient 3:"}, [Constants]::def.frames.addRecipe)
        $this.gui.CreateSysObject("Label", [Constants]::def.AddingRecipe.R4, @{Text = "Ingredient 4:"}, [Constants]::def.frames.addRecipe)
        $this.gui.CreateSysObject("Label", [Constants]::def.AddingRecipe.Out, @{Text = "Output:"}, [Constants]::def.frames.addRecipe)
        $this.gui.CreateSysObject("Label", [Constants]::def.AddingRecipe.S1, @{Text = "Second Output:"}, [Constants]::def.frames.addRecipe)

        $this.gui.CreateSysObject("ComboBox", [Constants]::def.AddingRecipe.R1, @{}, [Constants]::def.frames.addRecipe)
        $this.gui.CreateSysObject("ComboBox", [Constants]::def.AddingRecipe.R2, @{}, [Constants]::def.frames.addRecipe)
        $this.gui.CreateSysObject("ComboBox", [Constants]::def.AddingRecipe.R3, @{}, [Constants]::def.frames.addRecipe)
        $this.gui.CreateSysObject("ComboBox", [Constants]::def.AddingRecipe.R4, @{}, [Constants]::def.frames.addRecipe)
        $this.gui.CreateSysObject("ComboBox", [Constants]::def.AddingRecipe.Out, @{}, [Constants]::def.frames.addRecipe)
        $this.gui.CreateSysObject("ComboBox", [Constants]::def.AddingRecipe.S1, @{}, [Constants]::def.frames.addRecipe)
        
        $this.gui.CreateSysObject("NumericUpDown", [Constants]::def.AddingRecipe.R1, @{Maximum = 1000; DecimalPlaces = 1}, [Constants]::def.frames.addRecipe)
        $this.gui.CreateSysObject("NumericUpDown", [Constants]::def.AddingRecipe.R2, @{Maximum = 1000; DecimalPlaces = 1}, [Constants]::def.frames.addRecipe)
        $this.gui.CreateSysObject("NumericUpDown", [Constants]::def.AddingRecipe.R3, @{Maximum = 1000; DecimalPlaces = 1}, [Constants]::def.frames.addRecipe)
        $this.gui.CreateSysObject("NumericUpDown", [Constants]::def.AddingRecipe.R4, @{Maximum = 1000; DecimalPlaces = 1}, [Constants]::def.frames.addRecipe)
        $this.gui.CreateSysObject("NumericUpDown", [Constants]::def.AddingRecipe.Out, @{Maximum = 1000; DecimalPlaces = 1}, [Constants]::def.frames.addRecipe)
        $this.gui.CreateSysObject("NumericUpDown", [Constants]::def.AddingRecipe.S1, @{Maximum = 1000; DecimalPlaces = 1}, [Constants]::def.frames.addRecipe)

        $this.gui.CreateSysObject("Label", [Constants]::def.AddingRecipe.RProd, @{Text = "Production:"}, [Constants]::def.frames.addRecipe)
        $this.gui.CreateSysObject("Label", [Constants]::def.AddingRecipe.RName, @{Text = "Recipe Name:"}, [Constants]::def.frames.addRecipe)
        $this.gui.CreateSysObject("NumericUpDown", [Constants]::def.AddingRecipe.RProd, @{Maximum = 10000000; DecimalPlaces = 2}, [Constants]::def.frames.addRecipe)
        $this.gui.CreateSysObject("TextBox", [Constants]::def.AddingRecipe.RName, @{}, [Constants]::def.frames.addRecipe)

        $this.gui.CreateSysObject("Button", [Constants]::def.AddRBTN.addRecipe, @{Text = "Add Recipe"; Name = [Constants]::def.AddRBTN.addRecipe}, [Constants]::def.frames.addRecipe)
        $this.gui.SysObjects.Button[([Constants]::def.AddRBTN.addRecipe)].Add_Click({
            $global:s.AddRecipeGUI()
        })
        $this.gui.CreateSysObject("Button", [Constants]::def.AddRBTN.editRecipe, @{Text = "Edit Recipe"; Name = [Constants]::def.AddRBTN.editRecipe}, [Constants]::def.frames.addRecipe)
        $this.gui.SysObjects.Button[([Constants]::def.AddRBTN.editRecipe)].Add_Click({
            $global:s.EditRecipeGUI()
        })

        $this.gui.CreateSysObject("Button", [Constants]::def.btn_save, @{Text = "Save"; Name = [Constants]::def.btn_save}, [Constants]::def.frames.other)
        $this.gui.SysObjects.Button[([Constants]::def.btn_save)].Add_Click({
            $global:s.SaveConfig()
        })
        $this.gui.CreateSysObject("Button", [Constants]::def.btn_quit, @{Text = "Quit"; Name = [Constants]::def.btn_quit}, [Constants]::def.frames.other)
        $this.gui.SysObjects.Button[([Constants]::def.btn_quit)].Add_Click({
            $global:s.Quit()
        })

        # Distribute Settings
        
        $allLists = ([Array] ([Constants]::def.list.Values))
        $allMainCaptions = ([Array] ([Constants]::def.ItemInfoCaptions.Values) + [Array] ([Constants]::def.RInfoCaptions.Values) + [Array] ([Constants]::def.AddingRecipe.Values))
        $allMainInfos = [Array] ([Constants]::def.ItemInfoValues.Values) + [Array] ([Constants]::def.RInfoMain.Values)
        $allIngInfos = ([Constants]::def.RInfoIng.iRName) + ([Constants]::def.RInfoIng.iRCount) + ([Constants]::def.RInfoIng.iRRatio) + ([Constants]::def.RInfoIng.iRCon)
        
        foreach($l in $allLists){
            $this.gui.SysObjects.ListBox[$l].Font = $global:font1
            $this.gui.SysObjects.Label[$l].Font = $global:font2
            $this.gui.SysObjects.Label[$l].TextAlign = "MiddleCenter"
        }
        
        foreach($l in ($allMainCaptions + ([Constants]::def.iRHead))){
            $this.gui.SysObjects.Label[$l].Font = $global:font2
        }

        foreach($l in ($allMainCaptions + $allMainInfos)){
            $this.gui.SysObjects.Label[$l].TextAlign = "MiddleLeft"
        }
        foreach($l in ($allMainInfos + $allIngInfos)){
            $this.gui.SysObjects.Label[$l].Font = $global:font1
            $this.gui.SysObjects.Label[$l].BackColor = "White"
            $this.gui.SysObjects.Label[$l].BorderStyle = "Fixed3D"
        }

        foreach($l in ([Constants]::def.iRHead + $allIngInfos)){
                $this.gui.SysObjects.Label[$l].TextAlign = "MiddleCenter"
        }

        foreach($l in ([Constants]::def.iRHead)){
            $this.gui.SysObjects.Label[$l].BorderStyle = "Fixed3D"
        }

        foreach($button in ([Array] $this.gui.SysObjects.Button.keys)){
            $this.gui.SysObjects.Button[$button].Font = $global:font1
        }

        foreach($tb in ([Array] $this.gui.SysObjects.TextBox.keys)){
            $this.gui.SysObjects.TextBox[$tb].Font = $global:font1
        }

        foreach($cb in ([Array] $this.gui.SysObjects.ComboBox.keys)){
            $this.gui.SysObjects.ComboBox[$cb].Font = $global:font1
        }

        foreach($nud in ([Array] $this.gui.SysObjects.NumericUpDown.keys)){
            $this.gui.SysObjects.NumericUpDown[$nud].Font = $global:font1
        }
        $this.gui.ApplyToSysObject((Join-Path $PSScriptRoot "SatisfactoryGUI.json"))
        $this.RefreshGUI()
        $this.gui.SysObjects.Form[([Constants]::def.form)].ShowDialog()
    }
    [void] ClearLists(){
        $this.gui.SysObjects.ListBox[([Constants]::def.list.item)].Items.Clear()
        $this.ClearRecipeLists()
    }
    [void] ClearRecipeLists(){
        $this.gui.SysObjects.ListBox[([Constants]::def.list.mainRecipe)].Items.Clear()
        $this.gui.SysObjects.ListBox[([Constants]::def.list.secRecipe)].Items.Clear()
        $this.gui.SysObjects.ListBox[([Constants]::def.list.usedIn)].Items.Clear()
    }
    [void] RefreshGUI(){
        $this.ClearLists()
        $this.RefreshItemList()
        $this.ClearRecipeInfo()
    }
    [void] RefreshItemList(){
        $this.gui.SysObjects.ListBox[([Constants]::def.list.item)].Items.Clear()
        $list = [ArrayList] (([Array] $this.Items.Name) | Sort-Object)
        $this.gui.ApplyToSysObject("ListBox", ([Constants]::def.list.item), @{List = [Array] $list})
        $this.ClearItemInfo()
        $this.RefreshAddRComboBoxes()
    }
    [void] RefreshAddRComboBoxes(){
        $list = [ArrayList] (([Array] $this.Items.Name) | Sort-Object)
        if($null -eq $list){ $list = [ArrayList] @()}
        $list.Insert(0, "None")
        $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.R1)].Items.clear()
        $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.R2)].Items.clear()
        $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.R3)].Items.clear()
        $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.R4)].Items.clear()
        $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.Out)].Items.clear()
        $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.S1)].Items.clear()
        $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.R1)].Items.AddRange([Array] $list)
        $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.R2)].Items.AddRange([Array] $list)
        $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.R3)].Items.AddRange([Array] $list)
        $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.R4)].Items.AddRange([Array] $list)
        $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.Out)].Items.AddRange([Array] $list)
        $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.S1)].Items.AddRange([Array] $list)
        $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.R1)].SelectedIndex = 0
        $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.R2)].SelectedIndex = 0
        $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.R3)].SelectedIndex = 0
        $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.R4)].SelectedIndex = 0
        $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.Out)].SelectedIndex = 0
        $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.S1)].SelectedIndex = 0
        $this.gui.SysObjects.NumericUpDown[([Constants]::def.AddingRecipe.R1)].Value = 0
        $this.gui.SysObjects.NumericUpDown[([Constants]::def.AddingRecipe.R2)].Value = 0
        $this.gui.SysObjects.NumericUpDown[([Constants]::def.AddingRecipe.R3)].Value = 0
        $this.gui.SysObjects.NumericUpDown[([Constants]::def.AddingRecipe.R4)].Value = 0
        $this.gui.SysObjects.NumericUpDown[([Constants]::def.AddingRecipe.Out)].Value = 0
        $this.gui.SysObjects.NumericUpDown[([Constants]::def.AddingRecipe.S1)].Value = 0
        $this.gui.SysObjects.NumericUpDown[([Constants]::def.AddingRecipe.RProd)].Value = 0
    }
    [void] SetRecipeLists(){
        $this.ClearRecipeLists()
        $this.ClearRecipeInfo()
        $selectedItem = $this.GetItemByName($this.gui.SysObjects.ListBox[([Constants]::def.list.item)].SelectedItem)
        $this.log.WriteInfo($selectedItem.MainRecipes.Name)
        $this.log.WriteInfo($selectedItem.SecondaryRecipes.Name)
        $this.log.WriteInfo($selectedItem.IngredientRecipes.Name)
        if($null -ne $selectedItem.MainRecipes.Name){
            $this.gui.ApplyToSysObject("ListBox", ([Constants]::def.list.mainRecipe), @{List = [Array] (([Array] $selectedItem.MainRecipes.Name) | Sort-Object)})
        }
        if($null -ne $selectedItem.SecondaryRecipes.Name){
            $this.gui.ApplyToSysObject("ListBox", ([Constants]::def.list.secRecipe), @{List = [Array] (([Array] $selectedItem.SecondaryRecipes.Name) | Sort-Object)})
        }
        if($null -ne $selectedItem.IngredientRecipes.Name){
            $this.gui.ApplyToSysObject("ListBox", ([Constants]::def.list.usedIn), @{List = [Array] (([Array] $selectedItem.IngredientRecipes.Name) | Sort-Object)})
        }
    }
    [void] ClearItemInfo(){
        $this.gui.ApplyToSysObject("Label", ([Constants]::def.ItemInfoValues.IName), @{Text = " "})
        $this.gui.ApplyToSysObject("Label", ([Constants]::def.ItemInfoValues.Prod), @{Text = " "})
        $this.gui.ApplyToSysObject("Label", ([Constants]::def.ItemInfoValues.Cons), @{Text = " "})
        $this.gui.ApplyToSysObject("Label", ([Constants]::def.ItemInfoValues.Enough), @{Text = " "; BackColor = "White"})
    }
    [void] ShowItemInfo(){
        $this.ClearItemInfo()
        $selectedItem = $this.GetItemByName($this.gui.SysObjects.ListBox[([Constants]::def.list.item)].SelectedItem)
        $recipeName = $selectedItem.Name
        $recipeNameInit = $recipeName
        $counter = 1
        while($null -ne $this.GetRecipeByName($recipeName)){
            $counter++
            $recipeName = "$recipeNameInit ($counter)"
        }
        $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.Out)].SelectedItem = $selectedItem.Name
        $this.gui.ApplyToSysObject("TextBox", ([Constants]::def.AddingRecipe.RName), @{Text = $recipeName})
        $this.gui.ApplyToSysObject("Label", ([Constants]::def.ItemInfoValues.IName), @{Text = $selectedItem.Name})
        $this.gui.ApplyToSysObject("Label", ([Constants]::def.ItemInfoValues.Prod), @{Text = $selectedItem.GetProduction().ToString()})
        $this.gui.ApplyToSysObject("Label", ([Constants]::def.ItemInfoValues.Cons), @{Text = $selectedItem.GetConsumption().ToString()})

        $enoughProps = @{Text = "NO"; BackColor = "Red"}
        if ($selectedItem.IsEnoughProduction()) {
            $enoughProps = @{Text = "YES"; BackColor = "Green"}
        }
        $this.gui.ApplyToSysObject("Label", ([Constants]::def.ItemInfoValues.Enough), $enoughProps)
    }
    [void] ClearRecipeInfo(){
        $allInfoLabels = [Array] ([Constants]::def.RInfoMain.Values) + ([Constants]::def.RInfoIng.iRName) + ([Constants]::def.RInfoIng.iRCount) + ([Constants]::def.RInfoIng.iRRatio) + ([Constants]::def.RInfoIng.iRCon)
        foreach($labelName in $allInfoLabels){
            $this.gui.ApplyToSysObject("Label", $labelName, @{Text = " "})
        }
        $this.gui.SysObjects.NumericUpDown[([Constants]::def.SetProd.iRProd)].Value = 0
        $this.gui.SysObjects.Button[([Constants]::def.SetProd.SetProd)].Enabled = $false
        $this.SelectedRecipe = $null
        $this.EditRecipe = $false
        $this.gui.ApplyToSysObject("Button", ([Constants]::def.AddRBTN.addRecipe), @{Text = "Add Recipe"})
        $this.gui.SysObjects.Button[([Constants]::def.AddRBTN.editRecipe)].Enabled = $false
    }
    [void] ShowRecipeInfo([String] $FromList){
        $this.ClearRecipeInfo()
        if($this.gui.SysObjects.ListBox[$FromList].SelectedIndex -lt 0){
            return
        }
        $this.gui.SysObjects.Button[([Constants]::def.AddRBTN.editRecipe)].Enabled = $true
        $this.RefreshAddRComboBoxes()
        $this.SelectedRecipe = $this.GetRecipeByName($this.gui.SysObjects.ListBox[$FromList].SelectedItem)
        $this.gui.SysObjects.Button[([Constants]::def.SetProd.SetProd)].Enabled = $true
        $this.gui.ApplyToSysObject("Label", [Constants]::def.RInfoMain.iName, @{Text = $this.SelectedRecipe.Name})
        $this.gui.ApplyToSysObject("Label", [Constants]::def.RInfoMain.iOutName, @{Text = $this.SelectedRecipe.Output.Item.Name})
        $this.gui.ApplyToSysObject("Label", [Constants]::def.RInfoMain.iOutCount, @{Text = $this.SelectedRecipe.Output.ACount})
        if($null -ne $this.SelectedRecipe.SecondOutput){
            $this.gui.ApplyToSysObject("Label", [Constants]::def.RInfoMain.iSecName, @{Text = $this.SelectedRecipe.SecondOutput.Item.Name})
            $this.gui.ApplyToSysObject("Label", [Constants]::def.RInfoMain.iSecCount, @{Text = $this.SelectedRecipe.SecondOutput.ACount})
        }
        $this.gui.SysObjects.NumericUpDown[([Constants]::def.SetProd.iRProd)].Value = $this.SelectedRecipe.Production
        foreach($ingredient in $this.SelectedRecipe.Ingredients){
            $index = $this.SelectedRecipe.Ingredients.IndexOf($ingredient)
            $this.gui.ApplyToSysObject("Label", [Constants]::def.RInfoIng.iRName[$index], @{Text = $ingredient.Item.Name})
            $this.gui.ApplyToSysObject("Label", [Constants]::def.RInfoIng.iRCount[$index], @{Text = $ingredient.ACount.ToString()})
            $this.gui.ApplyToSysObject("Label", [Constants]::def.RInfoIng.iRRatio[$index], @{Text = $this.SelectedRecipe.GetRatio($ingredient.Item).ToString()})
            $this.gui.ApplyToSysObject("Label", [Constants]::def.RInfoIng.iRCon[$index], @{Text = $this.SelectedRecipe.GetConsumption($ingredient.Item).ToString()})
        }
    }
    [void] SetProductionGUI(){
        $this.SelectedRecipe.SetProduction($this.gui.SysObjects.NumericUpDown[([Constants]::def.SetProd.iRProd)].Value)
    }
    [void] AddRecipeGUI(){
        $name = $this.gui.SysObjects.TextBox[([Constants]::def.AddingRecipe.RName)].Text
        $production = $this.gui.SysObjects.NumericUpDown[([Constants]::def.AddingRecipe.RProd)].Value
        $ingredients = [ArrayList] @()
        for($i = 1; $i -le 4; $i++){
            $ing = [Ingredient]::new($this.GetItemByName(
                $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe["R$i"])].SelectedItem),
                $this.gui.SysObjects.NumericUpDown[([Constants]::def.AddingRecipe["R$i"])].Value)
            if(($null -ne $ing.Item) -and ($ing.ACount -gt 0)){
                [void] $ingredients.Add($ing)
            }
        }
        $Output = [Ingredient]::new($this.GetItemByName(
            $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.Out)].SelectedItem),
            $this.gui.SysObjects.NumericUpDown[([Constants]::def.AddingRecipe.Out)].Value)
        $SecOutput = [Ingredient]::new($this.GetItemByName(
            $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.S1)].SelectedItem),
            $this.gui.SysObjects.NumericUpDown[([Constants]::def.AddingRecipe.S1)].Value)
        if($null -eq $SecOutput.Item){
            $SecOutput = $null
        }
        $addROutput = @{status = $true}
        if(!$this.EditRecipe){
            $addROutput = $this.AddRecipe($name, $production, $Output, $SecOutput, $this.ConvertArrayOfIngredients([Array] $ingredients))
        }   
        else {
            $this.SelectedRecipe.Name = $name
            $this.SelectedRecipe.Production = $production
            $this.SelectedRecipe.Output = $Output
            $this.SelectedRecipe.SecondOutput = $SecOutput
            $this.SelectedRecipe.Ingredients = $this.ConvertArrayOfIngredients([Array] $ingredients)
        }
        if(($this.EditRecipe) -or ($addROutput.status)){
            $selectedItem = $this.gui.SysObjects.ListBox[([Constants]::def.list.item)].SelectedItem
            $this.RefreshItemList()
            $this.ClearRecipeLists()
            $this.gui.SysObjects.ListBox[([Constants]::def.list.item)].SelectedItem = $selectedItem
        }
        else{
            $this.gui.CreateMsgForm("AddRecipe", "Add Recipe", $false, $addROutput.msg)
        }
    }
    [void] EditRecipeGUI(){
        $this.EditRecipe = $true
        $this.gui.ApplyToSysObject("Button", ([Constants]::def.AddRBTN.addRecipe), @{Text = "Save Recipe"})
        $this.gui.SysObjects.TextBox[([Constants]::def.AddingRecipe.RName)].Text = $this.SelectedRecipe.Name
        $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.Out)].SelectedItem = $this.SelectedRecipe.Output.Item.Name
        $this.gui.SysObjects.NumericUpDown[([Constants]::def.AddingRecipe.Out)].Value = $this.SelectedRecipe.Output.ACount
        if($null -ne $this.SelectedRecipe.SecondOutput){
            $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe.S1)].SelectedItem = $this.SelectedRecipe.SecondOutput.Item.Name
            $this.gui.SysObjects.NumericUpDown[([Constants]::def.AddingRecipe.S1)].Value = $this.SelectedRecipe.SecondOutput.ACount
        }
        for ($i = 0; $i -lt $this.SelectedRecipe.Ingredients.Count; $i++) {
            $this.gui.SysObjects.ComboBox[([Constants]::def.AddingRecipe["R$($i + 1)"])].SelectedItem = $this.SelectedRecipe.Ingredients[$i].Item.Name
            $this.gui.SysObjects.NumericUpDown[([Constants]::def.AddingRecipe["R$($i + 1)"])].Value = $this.SelectedRecipe.Ingredients[$i].ACount
        }
        $this.gui.SysObjects.NumericUpDown[([Constants]::def.AddingRecipe.RProd)].Value = $this.SelectedRecipe.Production
    }
    [void] Quit(){
        $this.gui.SysObjects.Form[[Constants]::def.form].Close()
        $this.gui.SysObjects.Form[[Constants]::def.form].Dispose()
    }
}
$global:font1 = [Font]::new("Microsoft Sans Serif",12,[FontStyle]::Regular)
$global:font2 = [Font]::new("Microsoft Sans Serif",12,[FontStyle]::Bold)

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

$global:s = [Satisfactory]::new()
$global:s.ShowForm()