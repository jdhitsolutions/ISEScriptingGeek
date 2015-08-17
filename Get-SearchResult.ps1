#requires -version 4.0

Function Get-SearchResult {
[cmdletbinding()]
Param(
[Parameter(Position=0)]
[ValidateNotNullorEmpty()]
[string]$Text = $psise.currentfile.editor.selectedText,
[ValidateSet("Bing","Google","Yahoo")]
[string]$SearchEngine="Google"
)

Switch ($SearchEngine) {
"Bing" {
        $lang = (get-culture).parent.name
        $url = "http://www.bing.com/search?q=$text+language%3A$lang"
        Break
       }
"Google" {
        $url = "http://www.google.com/search?q=$text"
         }
"Yahoo" {
        $url = "http://search.yahoo.com/search?p=$text"
        }
} #switch


write-Verbose "Opening $url in $SearchEngine"

Start $url


} #end function