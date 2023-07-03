Function Get-SearchResult {
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]$Text = $psISE.CurrentFile.editor.selectedText,
        [ValidateSet("Bing", "Google", "Yahoo")]
        [String]$SearchEngine = "Google"
    )

    Switch ($SearchEngine) {
        "Bing" {
            $lang = (Get-Culture).parent.name
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


    Write-Verbose "Opening $url in $SearchEngine"

    Start-Process $url

} #end function
