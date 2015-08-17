#requires -version 2.0

Function ConvertFrom-Alias {

Param (
    [Parameter(Position=0)]
    [ValidateNotNullorEmpty()]
    $Text=$psISE.CurrentFile.Editor.text
)

#make sure we are using the ISE
if ($host.name -match "ISE"){

#Turn the script into syntax tokens
Write-Verbose "Tokenizing"

#verify there are no syntax errors first by Tokenizing the script
$out=$null
$tokens = [System.Management.Automation.PSparser]::Tokenize($text, [ref]$out)

#if there are errors they will be directed to $out
if ($out) {
    #enumerate each parsing error in $out
    foreach ($problem in $out) {
        Write-Warning $problem.message
        Write-Warning "Line: $($problem.Token.Startline) at character: $($problem.token.StartColumn)"
    }
}
else {
    #if no errors then proceed to convert
    $tokens | Where-Object { $_.Type -eq 'Command'} | 
    Sort-Object StartLine, StartColumn -Descending |
      ForEach-Object {
          #handle the ? by escaping it
          if($_.content -eq '?') {
            Write-Verbose "Found a ?"
            $result = Get-Command -name '`?' -CommandType Alias
          } 
          else {
            $result = Get-Command -name $_.Content -CommandType Alias -ErrorAction SilentlyContinue
          }

          #check and see if Get-Command returned anything
          if($result) {
            #find each command and insert the corresponding command definition
            Write-Verbose "Replacing $($result.name) with $($result.definition)"
            $psISE.CurrentFile.Editor.Select($_.StartLine,$_.StartColumn,$_.EndLine,$_.EndColumn)
            $psISE.CurrentFile.Editor.InsertText($result.Definition)
          }
      } #foreach
 } #else $tokens exists and there were no parsing errors
} #if ISE
else {
    Write-Warning "You must be using the PowerShell ISE"
}

Write-Verbose "Finished"

} #end Function
