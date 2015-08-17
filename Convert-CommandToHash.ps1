#requires -version 3.0

#Convert the named parameter part of a command into a hash table in the ISE

Function Convert-CommandtoHash {
[cmdletbinding()]
Param(
[ValidateNotNullorEmpty()]
[string]$Text = $psise.currentfile.editor.SelectedText
)

Set-StrictMode -Version latest

New-Variable astTokens -force
New-Variable astErr -force

Write-verbose "Converting $text"

$ast = [System.Management.Automation.Language.Parser]::ParseInput($Text,[ref]$astTokens,[ref]$astErr)

#resolve the command name
$cmdType = Get-Command $asttokens[0].text
if ($cmdType.CommandType -eq 'Alias') {
    $cmd = $cmdType.ResolvedCommandName
}
else {
    $cmd = $cmdType.Name
}

Write-Verbose "Command is $cmd"
Write-Verbose ($astTokens | out-string)

#last item is end of input token

$r= for ($i = 1;$i -lt $astTokens.count-2 ;$i++) { 
if ($astTokens[$i].ParameterName) {
   $p = $astTokens[$i].ParameterName
   write-verbose "Parameter name = $p"
   write-verbose ($astTokens[$i] | out-string)
   $v=""
   #check next token
   if ($astTokens[$i+1].Kind -match 'Parameter|NewLine|EndOfInput') {
     #the parameter must be a switch
     $v= "`$True"
   }
   else {
   While ($astTokens[$i+1].Kind -notmatch 'Parameter|NewLine|EndOfInput') {
     #break out of loop if there is no text
     write-verbose "While: $($astTokens[$i])"
     $i++
     #test if value is a string and if it is quoted, if not include quotes
     if ($astTokens[$i].Text -match "\D" -AND $astTokens[$i].Text -notmatch """\w+.*""" -AND $astTokens[$i].Text -notmatch "'\w+.*'") {
       #ignore commas and variables
       if ($astTokens[$i].Kind -match 'Comma|Variable') {
        $value = $astTokens[$i].Text 
       }
       else {
         #Assume text and quote it
         Write-Verbose "Quoting $($astTokens[$i].Text)"
         $value="'$($astTokens[$i].Text)'"
       }
     }
     else {
       Write-Verbose "Using text as is for $($astTokens[$i].Text)" 
       $value = $astTokens[$i].Text 
     }

     Write-Verbose "Adding $Value to `$v"
     $v+= $value
   }
  } #while
   
   "$p = $v`r"
   Write-Verbose "hashentry -> $p = $v`r"
}

} #for

Write-Verbose "Finished processing AST"
Write-verbose ($r | out-string)

#create text
$hashtext = @"
`$paramHash = @{
 $r}

$cmd @paramHash
"@

#insert the text which should replace the highlighted line
$psise.CurrentFile.Editor.InsertText($hashtext)

}


