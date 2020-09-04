param($bank = 10000,
$numcount = 100000,
$limitbethalf=4,
$limitbetthird=4,
$limithalf=14,
$limitthird=27,
$limitmultihalf=4,
$limitmultithird=4)
$limit = @{bethalf=$limitbethalf; betthird=$limitbetthird; half=$limithalf; third=$limitthird; multihalf=$limitmultihalf; multithird=$limitmultithird}
$numbers = @{
G_U_1 = @{count=0;num=@(2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36)};
G_U_2 = @{count=0;num=@(1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35)};
R_S_1 = @{count=0;num=@(1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36)};
R_S_2 = @{count=0;num=@(2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35)};
H_1 = @{count=0;num=@(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18)};
H_2 = @{count=0;num=@(19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36)};
D_1 = @{count=0;num=@(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)};
D_2 = @{count=0;num=@(13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24)};
D_3 = @{count=0;num=@(25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36)};
L_1 = @{count=0;num=@(1, 4, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34)};
L_2 = @{count=0;num=@(2, 5, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35)};
L_3 = @{count=0;num=@(3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36)}
}
$win = 0
$loose = 0
$logall = @()
$key = @("G_U_1", "G_U_2", "R_S_1", "R_S_2", "H_1", "H_2", "D_1", "D_2", "D_3", "L_1", "L_2", "L_3")
$startTime = Get-Date
$numcount_orig = $numcount
"Nummer:;Bank:;Un-Gerade:;Farbe:;Haelfte:;Drittel:;Linie:;Einsatz:;Gerade:;Ungerade:;Rot:;Schwarz:;1. Haelfte:;2. Haelfte:;1. Drittel:;2. Drittel:;3. Drittel:;1. Linie:;2. Linie:;3. Linie:;Count:;C_Gerade:;C_Ungerade:;C_Rot:;C_Schwarz:;C_1. Haelfte:;C_2. Haelfte:;C_1. Drittel:;C_2. Drittel:;C_3. Drittel:;C_1. Linie:;C_2. Linie:;C_3. Linie:;BetCount:;BC_Gerade:;BC_Ungerade:;BC_Rot:;BC_Schwarz:;BC_1. Haelfte:;BC_2. Haelfte:;BC_1. Drittel:;BC_2. Drittel:;BC_3. Drittel:;BC_1. Linie:;BC_2. Linie:;BC_3. Linie:" | Out-File "C:\Privat\RO.csv"
foreach($numkeys in $numbers.keys){
    $numbers[$numkeys].count = 0
    $numbers[$numkeys].bet = 0
    $numbers[$numkeys].betcount = 0
    $numbers[$numkeys].maxcount = 0
    $numbers[$numkeys].counts = [System.Collections.ArrayList] @()
    for($i=0; $i -le 30; $i++){
        $temp = $numbers[$numkeys].counts.Add(0)
    }
    
    if($numkeys.startswith("G") -or $numkeys.startswith("R") -or $numkeys.startswith("H")){
        $numbers[$numkeys].win = 2
        $numbers[$numkeys].limit = $limit.half
        $numbers[$numkeys].betlimit = $limit.bethalf
        $numbers[$numkeys].multi = $limit.multihalf
    }
    else{
        $numbers[$numkeys].win = 3
        $numbers[$numkeys].limit = $limit.third
        $numbers[$numkeys].betlimit = $limit.betthird
        $numbers[$numkeys].multi = $limit.multithird
    }
}
for($i=0;$i -lt $numcount; $i++){
    if(($i -ne 0) -and (([math]::floor(($i/10000))*10000) -eg $i)){
        $logall | Out-File "C:\Privat\RO.csv" -Append
        $logall = @()
    }
    $num = Get-Random -Minimum 0 -Maximum 37
    $log = ""
    if($num -eq 0){
        $log += "null;null;null;null;null;"
    }
    foreach($numkeys in $key){
        if($numbers[$numkeys].num.contains($num)){
            if(($numbers[$numkeys].bet -gt 0) -and ($num -ne 0)){
                $wintemp = ($numbers[$numkeys].bet * $numbers[$numkeys].win) - $numbers[$numkeys].bet
                $bank += $numbers[$numkeys].bet * $numbers[$numkeys].win
                Write-Host $i $numkeys WIN $wintemp Bank: $bank
                $win++
                $numcount = $numcount_orig
                $numbers[$numkeys].bet = 0
                $numbers[$numkeys].betcount = 0
            }
            if($numbers[$numkeys].count -ne 0){
                $numbers[$numkeys].counts[$numbers[$numkeys].count]++
            }
            $numbers[$numkeys].count = 0
            switch($numkeys){
                "G_U_1" {$log += "Gerade;"; break;}
                "G_U_2" {$log += "Ungerade;"; break;}
                "R_S_1" {$log += "Rot;"; break;}
                "R_S_2" {$log += "Schwarz;"; break;}
                "H_1" {$log += "1.;"; break;}
                "H_2" {$log += "2.;"; break;}
                "D_1" {$log += "1.;"; break;}
                "D_2" {$log += "2.;"; break;}
                "D_3" {$log += "3.;"; break;}
                "L_1" {$log += "1.;"; break;}
                "L_2" {$log += "2.;"; break;}
                "L_3" {$log += "3.;"; break;}
            }
        }
        else{
            if(($numbers[$numkeys].count -gt 0) -or ($num -ne 0)){
                $numbers[$numkeys].count++
                if($numbers[$numkeys].count -gt $numbers[$numkeys].maxcount){
                    $numbers[$numkeys].maxcount = $numbers[$numkeys].count
                    if($numbers[$numkeys].counts[$numbers[$numkeys].count] -eq $null){
                        $temp = $numbers[$numkeys].counts.Add(0)
                    }
                    #$maxtemp = $numbers[$numkeys].maxcount
                    #Write-Host $i $numkeys newMaxCount: $maxtemp
                }
            }
        }
    }
    $log += " ;"
    foreach($numkeys in $key){
        if($numbers[$numkeys].count -eq $numbers[$numkeys].limit){
            $numbers[$numkeys].bet = [math]::floor(($bank/10000))*100
            if(($numbers[$numkeys].bet -eq 0) -and ($bank -gt 0)){
                $numbers[$numkeys].bet = [math]::floor(($bank/1000))*10
            }
            if(($numbers[$numkeys].bet -eq 0) -and ($bank -gt 0)){
                $numbers[$numkeys].bet = [math]::floor(($bank/100))
            }
            $bank -= $numbers[$numkeys].bet
            $numbers[$numkeys].betcount++
        }
        elseif($numbers[$numkeys].count -gt $numbers[$numkeys].limit){
            if($numbers[$numkeys].betcount -lt $numbers[$numkeys].betlimit){
                if($numbers[$numkeys].bet -gt 0){
                    $numbers[$numkeys].bet = $numbers[$numkeys].bet * $numbers[$numkeys].multi
                    if($numbers[$numkeys].bet -gt $bank){
                        $numbers[$numkeys].bet = $bank
                    }
                    $bank -= $numbers[$numkeys].bet
                    $numbers[$numkeys].betcount++
                }
            }
            else{
                $bettemp = $numbers[$numkeys].bet
                $maxtemp = $numbers[$numkeys].count
                Write-Host $i $numkeys Loose $bettemp Bank: $bank
                $loose++
                
                $numbers[$numkeys].bet = 0
                $numbers[$numkeys].betcount = 0
            }
        }
        $log += "" + $numbers[$numkeys].bet + ";"
    }
    $log += " ;"
    foreach($numkeys in $key){
        $log += "" + $numbers[$numkeys].count + ";"
    }
    
    $log += " ;"
    foreach($numkeys in $key){
        $log += "" + $numbers[$numkeys].betcount + ";"
    }
    
    $log = "$num;$bank;" + $log
    $logall += $log
    if(($bank -lt 100) -and ($numcount -ne ($i + 1))){
        $numcount = $i + 2
    }
}
Write-Host 

$logall | Out-File "C:\Privat\RO.csv" -Append
foreach($numkeys in $key){
    $temp = $numbers[$numkeys].maxcount
    Write-Host $numkeys - maxcount: $temp
    for($i=0; $i -lt $numbers[$numkeys].counts.length.length; $i++){
        if($numbers[$numkeys].counts[$i] -ne 0){
            Write-Host Anzahl: $i - Male: $numbers[$numkeys].counts[$i]
        }
    }
    Write-Host 
}
Write-Host WIN: $win Loose: $loose Bank: $bank
Write-Host 
$csv = Import-Csv "C:\Privat\RO.csv" -Delimiter ";"
$csv | Export-Csv -Path "C:\Privat\RO.csv" -Delimiter ";"
$temp = ("Elapsed time: " + ((New-TimeSpan -Start $startTime -End (Get-Date)).ToString("hh\:mm\:ss")))
Write-Host $temp