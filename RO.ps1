$bank = 10000
$numcount = 100000
$numcount_orig = 100000
$limit = @{bethalf=4; betthird=4; half=13; third=21; multihalf=4; multithird=4}
$numbers = @{
G_U_1 = @{count=0;num=@(0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36);bet=0; betcount=0; op=@("G_U_2")};
G_U_2 = @{count=0;num=@(0, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35);bet=0; betcount=0; op=@("G_U_1")};
R_S_1 = @{count=0;num=@(0, 1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36);bet=0; betcount=0; op=@("R_S_2")};
R_S_2 = @{count=0;num=@(0, 2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35);bet=0; betcount=0; op=@("R_S_1")};
H_1 = @{count=0;num=@(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18);bet=0; betcount=0; op=@("H_2")};
H_2 = @{count=0;num=@(0, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36);bet=0; betcount=0; op=@("H_1")};
D_1 = @{count=0;num=@(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12);bet=0; betcount=0; op=@("D_2", "D_3")};
D_2 = @{count=0;num=@(0, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24);bet=0; betcount=0; op=@("D_1", "D_3")};
D_3 = @{count=0;num=@(0, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36);bet=0; betcount=0; op=@("D_1", "D_2")};
L_1 = @{count=0;num=@(0, 1, 4, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34);bet=0; betcount=0; op=@("L_2", "L_3")};
L_2 = @{count=0;num=@(0, 2, 5, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35);bet=0; betcount=0; op=@("L_1", "L_3")};
L_3 = @{count=0;num=@(0, 3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36);bet=0; betcount=0; op=@("L_1", "L_2")}
}
$win = 0
$loose = 0
$key = @("G_U_1", "G_U_2", "R_S_1", "R_S_2", "H_1", "H_2", "D_1", "D_2", "D_3", "L_1", "L_2", "L_3")
"Nummer:;Bank:;Un-Gerade:;Farbe:;Haelfte:;Drittel:;Linie:;Einsatz:;Gerade:;Ungerade:;Rot:;Schwarz:;1. Haelfte:;2. Haelfte:;1. Drittel:;2. Drittel:;3. Drittel:;1. Linie:;2. Linie:;3. Linie:;Count:;C_Gerade:;C_Ungerade:;C_Rot:;C_Schwarz:;C_1. Haelfte:;C_2. Haelfte:;C_1. Drittel:;C_2. Drittel:;C_3. Drittel:;C_1. Linie:;C_2. Linie:;C_3. Linie:;BetCount:;BC_Gerade:;BC_Ungerade:;BC_Rot:;BC_Schwarz:;BC_1. Haelfte:;BC_2. Haelfte:;BC_1. Drittel:;BC_2. Drittel:;BC_3. Drittel:;BC_1. Linie:;BC_2. Linie:;BC_3. Linie:" | Out-File "C:\Privat\RO.csv"
foreach($numkeys in $numbers.keys){
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
            if($num -ne 0){
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
        }
        else{
            if(($numbers[$numkeys].count -gt 0) -or ($num -ne 0)){
                $numbers[$numkeys].count++
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
                Write-Host $i $numkeys Loose $bettemp Bank: $bank LOOOOOOOOOOOOOOOOOOOOOSE
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
    $log | Out-File "C:\Privat\RO.csv" -Append
    if(($bank -lt 100) -and ($numcount -ne ($i + 1))){
        $numcount = $i + 2
    }
}
Write-Host 
Write-Host WIN: $win Loose: $loose Bank: $bank
$csv = Import-Csv "C:\Privat\RO.csv" -Delimiter ";"
$csv | Export-Csv -Path "C:\Privat\RO.csv" -Delimiter ";"