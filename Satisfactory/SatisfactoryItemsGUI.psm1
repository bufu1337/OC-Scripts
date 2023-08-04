using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.IO
using namespace System.Management.Automation
using module .\GUICreator.psm1
using module .\Functions.psm1
using module .\Logging.psm1

class Constants{
    static [String] $ConfigPath = "D:\Y-Downloads\Minecraft\OC-Scripts\Satisfactory\Satisfactory.json"
    static [Hashtable] GetConfig(){
        return [Functions]::GetJsonHash(([Constants]::ConfigPath))
    }
    static [void] SaveConfig([Hashtable] $Config){
        $Config | ConvertTo-Json -Depth 4 | Out-File ([Constants]::ConfigPath)
        Write-Host Config saved to ([Constants]::ConfigPath)
    }
    static [Hashtable] $def = @{form = "Satisfactory";
        formtext = "Satisfactory";
        itemlist = "Items"
        # list_work="Work";
        # list_wait="Wait";
        # btn_ref="Refresh";
        # btn_rem="RemM";
        # btn_arem="RemAllM";
        # btn_add="AddM";
        # btn_view="View";
        # btn_quit="MQuit"
    }
}

class Ingredient{
    [Item] $Item
    [Int32] $Count

    Ingredient([Item] $Item, [Int32] $Count){
        $this.Item = $Item
        $this.Count = $Count
    }

    [Hashtable] ConvertToHash(){
        return @{Name = $this.Item.Name; Count = $this.Count}
    }
}
class Recipe{
    [String] $Name
    [Int32] $Production
    [Ingredient] $Output
    [Ingredient] $SecondOutput
    [List[Ingredient]] $Ingredients

    Recipe([String] $Name, [Ingredient] $Output, [Ingredient] $SecondOutput, [List[Ingredient]] $Ingredients){
        $this.Name = $Name
        $this.Output = $Output
        $this.SecondOutput = $SecondOutput
        $this.Ingredients = $Ingredients
    }

    [void] SetProduction([Int32] $Production){
        $this.Production = $Production
    }

    [Boolean] IsIngredient([Item] $Item){
        return ($null -ne ($this.Ingredients | Where-Object{ $_.Item -eq $Item }))
    }

    [Int32] GetConsumption([Item] $Item){
        if(!$this.IsIngredient($Item)){
            return 0
        }
        return $this.Production / $this.Output.Count * ($this.Ingredients | Where-Object{ $_.Item -eq $Item }).Count
    }

    [Int32] GetSecondaryProduction(){
        if($null -eq $this.SecondOutput){
            return 0
        }
        return $this.Production / $this.Output.Count * $this.SecondOutput.Count
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
        if($null -ne $this.Ingredients){
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

    [Int32] GetProduction(){
        $output = 0
        if($null -ne $this.MainRecipes){
            $output += ($this.MainRecipes.Production | Measure-Object -sum).Sum
        }
        if($null -ne $this.SecondaryRecipes){
            $output += ($this.SecondaryRecipes.GetSecondaryProduction() | Measure-Object -sum).Sum
        }
        return $output
    }

    [Int32] GetConsumption(){
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
    $gui

    Satisfactory(){
        $this.gui = [GUICreator]::new()
        $this.gui.PtoP_Visible($PSScriptRoot)
    }

    [Item] GetItemByName([String] $Name){
        return $this.Items | Where-Object{$_.Name -eq $Name}
    }

    [Recipe] GetRecipeByName([String] $Name){
        return $this.Recipes | Where-Object{$_.Name -eq $Name}
    }

    [void] AddItem([String] $Name){
        $this.Items.Add([Item]::new($Name))
    }

    [void] AddRecipe([String] $Name, [Int32] $Production, [Ingredient] $Output, [Ingredient] $SecondOutput, [List[Ingredient]] $Ingredients){
        $this.Recipes.Add([Recipe]::new($Name, $Output, $SecondOutput, $Ingredients))
        foreach($item in $this.Items){
            $item.GetRecipes($this.Recipes)
        }
        $this.GetRecipeByName($Name).SetProduction($Production)
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

    [Ingredient] NewIngredient([String] $Name, [Int32] $Count){
        return [Ingredient]::new($this.GetItemByName($Name), $Count)
    }
    
    [Hashtable] ConvertToHash(){
        return @{Items = $this.Items.Name; Recipes = ([Array] $this.Recipes.ConvertToHash())}
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
                $secondOutput = $this.NewIngredient($recipe.SecondOutput.Name, $recipe.SecondOutput.Count)
            }
            if($null -ne $recipe.Ingredients){
                $ingredients = $this.ConvertArrayOfIngredients([Array] ($recipe.Ingredients | Foreach-Object{$this.NewIngredient($_.Name, $_.Count)}))
            }
            $this.AddRecipe($recipe.Name, $recipe.Production, $this.NewIngredient($recipe.Output.Name, $recipe.Output.Count), $secondOutput, $ingredients)
        }
    }

    [void] ShowForm(){
        $this.gui.CreateSysObject(
                "Form", [Constants]::def.form, 
                @{Size = '1600,900'; Text = [Constants]::def.formtext; MaximizeBox = $False; 
                  FormBorderStyle = "FixedDialog"; Topmost = $false; StartPosition = "CenterScreen" })
                    
        $this.gui.CreateSysObject("Label", [Constants]::def.itemlist, @{TextAlign = "TopCenter"; Text = "Items:"}, [Constants]::def.form)
        $this.gui.CreateSysObject("ListBox", [Constants]::def.itemlist, @{Name = [Constants]::def.itemlist}, [Constants]::def.form)
        # $this.gui.SysObjects.ListBox[([Constants]::def.itemlist)].Add_SelectedIndexChanged({
        #     $global:sl.ListIndexChange()
        # })
        
        # $this.gui.CreateSysObject("Label", $this.def.list_work, @{TextAlign = "TopCenter"; Text = "Work-IDs:"}, $this.def.form)
        # $this.gui.CreateSysObject("ListBox", $this.def.list_work, @{Name = $this.def.list_work}, $this.def.form)
        # $this.gui.SysObjects.ListBox[$this.def.list_work].Add_SelectedIndexChanged({
        #     $global:sl.WorkIndexChange()
        # })
        
        # $this.gui.CreateSysObject("Label", $this.def.list_wait, @{TextAlign = "TopCenter"; Text = "Wait-IDs:"}, $this.def.form)
        # $this.gui.CreateSysObject("ListBox", $this.def.list_wait, @{Name = $this.def.list_wait}, $this.def.form)
        # $this.gui.SysObjects.ListBox[$this.def.list_wait].Add_SelectedIndexChanged({
        #     $global:sl.WaitIndexChange()
        # })
        
        # $this.gui.CreateSysObject("Button", $this.def.btn_ref, @{Text = "Refresh"; Name = $this.def.btn_ref}, $this.def.form)
        # $this.gui.SysObjects.Button[$this.def.btn_ref].Add_Click({
        #     $global:sl.Refresh()
        # })
        
        # $this.gui.CreateSysObject("Button", $this.def.btn_rem, @{Text = "Remove Mutex"; Name = $this.def.btn_rem}, $this.def.form)
        # $this.gui.SysObjects.Button[$this.def.btn_rem].Add_Click({
        #     $global:sl.Remove()
        # })
        
        # $this.gui.CreateSysObject("Button", $this.def.btn_arem, @{Text = "Remove All ID Mutexes"; Name = $this.def.btn_arem}, $this.def.form)
        # $this.gui.SysObjects.Button[$this.def.btn_arem].Add_Click({
        #     $global:sl.RemoveAll()
        # })
        # $this.gui.CreateSysObject("Button", $this.def.btn_add, @{Text = "Add Mutex"; Name = $this.def.btn_add}, $this.def.form)
        # $this.gui.SysObjects.Button[$this.def.btn_add].Add_Click({
        #     $global:sl.Add()
        # })
        
        # $this.gui.CreateSysObject("Button", $this.def.btn_view, @{Text = "WorkID View"; Name = $this.def.btn_view}, $this.def.form)
        # $this.gui.SysObjects.Button[$this.def.btn_view].Add_Click({
        #     $global:sl.ChangeView()
        # })
        
        # $this.gui.CreateSysObject("Button", $this.def.btn_quit, @{Text = "Quit"; Name = $this.def.btn_quit}, $this.def.form)
        # $this.gui.SysObjects.Button[$this.def.btn_quit].Add_Click({
        #     $global:sl.Quit($global:sl.def.form)
        # })
        
        # $font = New-Object System.Drawing.Font("Microsoft Sans Serif",12,$global:fontstyle)
        # foreach($button in ([Array] $this.gui.SysObjects.Button.keys)){
        #     $this.gui.SysObjects.Button[$button].Font = $font
        # }
        #$this.log.WriteInfo($this.gui.SysObjects.Form[$this.def.form].Controls)
        $this.gui.ApplyToSysObject((Join-Path $PSScriptRoot "SatisfactoryGUI.json"))
        #$this.Refresh()
        $this.gui.SysObjects.Form[([Constants]::def.form)].ShowDialog()
    }
}


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
