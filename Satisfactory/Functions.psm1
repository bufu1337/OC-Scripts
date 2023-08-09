using namespace System.Collections
class Functions{
    static [Hashtable] GetJsonHash([String] $Path){
        $content = Get-Content $Path
        $contentJson = $content | ConvertFrom-Json
        return [Functions]::ConvertPSCustomObject($contentJson)
    }
    static [Hashtable] ConvertPSCustomObject([PSCustomObject] $Object){
        $hashtable = @{}
        foreach($property in $Object.psobject.properties.name){
            if(($null -ne $Object.$property) -and ($Object.$property -is [Array])){
                $hashtable[$property] = [Functions]::ConvertPSCustomArray($Object.$property)
            }
            elseif(($null -ne $Object.$property) -and ($Object.$property -is [PSCustomObject])){
                $hashtable[$property] = [Functions]::ConvertPSCustomObject($Object.$property)
            }
            else{
                $hashtable[$property] = $Object.$property
            }
        }
        return $hashtable
    }
    static [Arraylist] ConvertPSCustomArray([Array] $Object){
        [Arraylist] $array = @()
        foreach($item in $Object){
            if($item -is [Array]){
                $item = [Functions]::ConvertPSCustomArray($item)
            }
            elseif($item -is [PSCustomObject]){
                $item = [Functions]::ConvertPSCustomObject($item)
            }
            [void] $array.Add($item)
        }
        return $array
    }
}