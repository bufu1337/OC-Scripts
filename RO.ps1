$bank = 10000
$numcount = 100
$limit = @{bet=7; half=5; thrid=7}
$numbers = @{
G_U_1 = @{count=0;num=@(0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36);bet=0; betcount=0};
G_U_2 = @{count=0;num=@(0, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35);bet=0; betcount=0};
R_S_1 = @{count=0;num=@(0, 1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36);bet=0; betcount=0};
R_S_2 = @{count=0;num=@(0, 2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35);bet=0; betcount=0};
H_1 = @{count=0;num=@(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18);bet=0; betcount=0};
H_2 = @{count=0;num=@(0, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36);bet=0; betcount=0};
D_1 = @{count=0;num=@(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12);bet=0; betcount=0};
D_2 = @{count=0;num=@(0, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24);bet=0; betcount=0};
D_3 = @{count=0;num=@(0, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36);bet=0; betcount=0};
L_1 = @{count=0;num=@(0, 1, 4, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34);bet=0; betcount=0};
L_2 = @{count=0;num=@(0, 2, 5, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35);bet=0; betcount=0};
L_3 = @{count=0;num=@(0, 3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36);bet=0; betcount=0}
}
for($i=0;$i -lt $numcount; $i++){
    $num = Get-Random -Minimum 0 -Maximum 37
    foreach($numkeys in $numbers.keys){
        if($numbers[$numkeys].num.contains($num) -and ($numbers[$numkeys].bet -gt 0)){
            $numbers[$numkeys].bet++
        }
        else{
            $numbers[$numkeys].bet = $numbers[$numkeys].bet * 2
            $numbers[$numkeys].betcount++
        }
    }
    foreach($numkeys in $numbers.keys){
        if($numbers[$numkeys].num.contains($num)){
            $numbers[$numkeys].count++
        }
        else{
            $numbers[$numkeys].count = 0
        }
    }
}