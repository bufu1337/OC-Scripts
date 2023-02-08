$mainPath = "D:\Y-Downloads\Minecraft\OC-Scripts\BCGAME"
$a = Get-Content (Join-Path $mainPath "BCGameTest.json")
for($i=0; $i -lt $a.count; $i++){
$a[$i] = $a[$i].replace("mode: base", 'mode: "base"').replace("mode: high", 'mode: "high"').replace("mode: midlow", 'mode: "midlow"').replace("mode: low", 'mode: "low"').replace("mode: mid", 'mode: "mid"').replace(", ",", """).replace(":",""":").replace("{","{""")
}
$a[$a.count-2] = $a[$a.count-2].Substring(0, $a[$a.count-2].Length-1)
$d = $a | ConvertFrom-Json
$d | Export-Csv (Join-Path $mainPath "BCGameTest.csv") -Delimiter ';'