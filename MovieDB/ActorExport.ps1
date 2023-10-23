$types = @("Movie", "Game", "Serie", "Music Video", "Video")
function PrintItem([Array] $item){
    foreach($line in $item){Write-Host $line}
}
$global:ex4 = @{}
$files = Get-ChildItem "C:\Users\Alexander\Desktop\ActorExport"
foreach($file in $files){
    $ex = Get-Content $file.FullName -Encoding UTF8
    $ex2 = [System.Collections.ArrayList] @()
    $ex3 = [System.Collections.ArrayList] @()
    $i = 0
    foreach($line in $ex){
        if([String]::IsNullOrWhiteSpace($line)){
            $i++
            continue
        }
        if($null -eq $ex2[$i]){
            $i = $ex2.Add([System.Collections.ArrayList] @())
        [void] $ex3.Add(@{})
        }
        [void] $ex2[$i].Add($line)
    }
    for($i=0; $i -lt $ex2.Count; $i++){
        $vote = $ex2[$i] | Where-Object{$_ -match "^[0-9],[0-9]$"}
        $titleIndex = 1
        if($null -ne $vote){
            $titleIndex = ($ex2[$i].indexOf($vote)) - 1
        }
        elseif($ex2[$i][0] -notmatch "\([0-9][0-9][0-9][0-9]\)$"){
            $titleIndex = 0
        }
        elseif($ex2[$i][0] -match "\([0-9][0-9][0-9][0-9]\)$"){
            $titleIndex = 1
        }
        else{
            PrintItem $ex2[$i]
            $titleIndex = Read-Host "Title Index?"
            Write-Host
        }
        $ex3[$i].Title = $ex2[$i][$titleIndex]
        $ex3[$i].Year = $ex2[$i] | Where-Object{$_ -match "[0-9][0-9][0-9][0-9]$"}
        $ex3[$i].Type = "Movie"
        if($ex2[$i].Contains("Fernsehserie")){
            $ex3[$i].Type = "Serie"
        }
        elseif($ex2[$i].Contains("Videospiel")){
            $ex3[$i].Type = "Game"
        }
        elseif($ex2[$i].Contains("Musik Video")){
            $ex3[$i].Type = "Music Video"
        }
        elseif($ex2[$i].Contains("Video")){
            $ex3[$i].Type = "Video"
        }
        $ex3[$i].Other = $ex2[$i]
    }
    $global:ex4[$file.BaseName] = $ex3 | Sort-Object -Property {$_.Type},{$_.Title}
    #$ex3 | ForEach-Object{"$($_.Title)`t$($_.Year)`t$($_.Type)"} | Out-File C:\Users\Alexander\Desktop\ActorExport2.txt
}

$global:ex5 = @{}

foreach($type in $types){
    $ex5[$type] = [System.Collections.ArrayList] @()
    foreach($actor in [Array] $ex4.keys){
        foreach($item in ($ex4[$actor] | Where-Object{$_.Type -eq $type})){
            $existingItem = $ex5[$type] | Where-Object{($_.Title -eq $item.Title) -and ($_.Year -eq $item.Year)}
            if($null -ne $existingItem){
                #Write-Host $existingItem.Title $actor
                [void] $existingItem.Actors.Add($actor)
            }
            else{
                $index = $ex5[$type].Add($item)
                $ex5[$type][$index].Actors = [System.Collections.ArrayList] @($actor)
            }
        }
    } 
    $ex5[$type] = $ex5[$type] | Sort-Object -Property {$_.Title}
}

foreach($type in $types){
    foreach($item in $ex5[$type]){
        $item.Remove("Type")
    }
}
$ex5 | ConvertTo-Json -Depth 3 | Out-File "C:\Users\Alexander\Desktop\MovieDB.json"