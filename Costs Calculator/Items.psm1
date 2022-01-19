$content = Get-Content "D:\Y-Downloads\Minecraft\OC-Scripts\Costs Calculator\MC-ItemsDrawer.js"
$content[0] = "{"
$json = $content | ConvertFrom-Json
$recipeItems = @{}
$recipeItemsAll = [System.Collections.ArrayList] @()
function GetKeys($object){
    if($object -is [System.Management.Automation.PSCustomObject]){
        return $object | get-member -MemberType NoteProperty | 
          select -ExpandProperty Name
    }
    elseif($object -is [Array]){
        return $object
    }
    return @()
}
foreach($storage in (GetKeys $json)){
    Write-Host $storage
    $recipeItems[$storage] = @{}
    $recipeItems[$storage].RecipeItems = [System.Collections.ArrayList] @()
    $recipeItems[$storage].NoRecipeItems = [System.Collections.ArrayList] @()
    $recipeItems[$storage].ForeignItems = [System.Collections.ArrayList] @()
    foreach($storageItem in (GetKeys $json.$storage)){
        #Write-Host $storageItem
        foreach($recipeItem in (GetKeys $json.$storage.$storageItem.recipe)){
            #Write-Host $recipeItem
            [void] $recipeItemsAll.Add($recipeItem)
            if(!((GetKeys $json.$storage).Contains($recipeItem))){
                [void] $recipeItems[$storage].ForeignItems.Add($recipeItem)
            }
        }
    }
    $recipeItems[$storage].ForeignItems = $recipeItems[$storage].ForeignItems | Select-Object -Unique | Sort-Object
}
$recipeItemsAll = $recipeItemsAll | Select-Object -Unique | Sort-Object

Write-Host

foreach($storage in (GetKeys $json)){
    Write-Host $storage
    foreach($storageItem in (GetKeys $json.$storage)){
        if($recipeItemsAll.Contains($storageItem)){
            [void] $recipeItems[$storage].RecipeItems.Add($storageItem)
        }
        else{
            [void] $recipeItems[$storage].NoRecipeItems.Add($storageItem)
        }
    }
    $recipeItems[$storage].RecipeItems = $recipeItems[$storage].RecipeItems | Select-Object -Unique | Sort-Object
    $recipeItems[$storage].NoRecipeItems = $recipeItems[$storage].NoRecipeItems | Select-Object -Unique | Sort-Object
}


$foreignAll = @()
foreach($storage in $recipeItems.keys){
    $foreignAll += $recipeItems.$storage.ForeignItems
}
foreach($storage in $recipeItems.keys){
    Write-Host $storage
    $recipeItems.$storage.ExternRItems = [System.Collections.ArrayList] @()
    $recipeItems.$storage.InternRItems = [System.Collections.ArrayList] @()
    foreach($recipeItem in $recipeItems.$storage.RecipeItems){
        if($foreignAll.Contains($recipeItem)){
            [void] $recipeItems.$storage.ExternRItems.Add($recipeItem)
        }
        else{
            [void] $recipeItems.$storage.InternRItems.Add($recipeItem)
        }
    }
    $recipeItems[$storage].ExternRItems = $recipeItems[$storage].ExternRItems | Select-Object -Unique | Sort-Object
    $recipeItems[$storage].InternRItems = $recipeItems[$storage].InternRItems | Select-Object -Unique | Sort-Object
}

$recipeItems | ConvertTo-Json | Out-File "D:\Y-Downloads\Minecraft\OC-Scripts\Costs Calculator\recipeItems.json"