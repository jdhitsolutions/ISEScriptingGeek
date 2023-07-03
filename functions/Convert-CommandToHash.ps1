
#Convert the named parameter part of a command into a hash table in the ISE

Function Convert-CommandToHash {
    [CmdletBinding()]
    Param(
        [ValidateNotNullOrEmpty()]
        [String]$Text = $psISE.CurrentFile.editor.SelectedText
    )

    Set-StrictMode -Version latest

    New-Variable $AstTokens -Force
    New-Variable astErr -Force

    Write-Verbose "Converting $text"

    $AST = [System.Management.Automation.Language.Parser]::ParseInput($Text, [ref]$AstTokens, [ref]$astErr)

    #resolve the command name
    $cmdType = Get-Command $AstTokens[0].text
    if ($cmdType.CommandType -eq 'Alias') {
        $cmd = $cmdType.ResolvedCommandName
    }
    else {
        $cmd = $cmdType.Name
    }

    Write-Verbose "Command is $cmd"
    Write-Verbose ($AstTokens | Out-String)

    #last item is end of input token

    $r = for ($i = 1; $i -lt $AstTokens.count - 2 ; $i++) {
        if ($AstTokens[$i].ParameterName) {
            $p = $AstTokens[$i].ParameterName
            Write-Verbose "Parameter name = $p"
            Write-Verbose ($AstTokens[$i] | Out-String)
            $v = ''
            #check next token
            if ($AstTokens[$i + 1].Kind -match 'Parameter|NewLine|EndOfInput') {
                #the parameter must be a switch
                $v = "`$True"
            }
            else {
                While ($AstTokens[$i + 1].Kind -notmatch 'Parameter|NewLine|EndOfInput') {
                    #break out of loop if there is no text
                    Write-Verbose "While: $($AstTokens[$i])"
                    $i++
                    #test if value is a string and if it is quoted, if not include quotes
                    if ($AstTokens[$i].Text -match '\D' -AND $AstTokens[$i].Text -notmatch '"\w+.*"' -AND $AstTokens[$i].Text -notmatch "'\w+.*'") {
                        #ignore commas and variables
                        if ($AstTokens[$i].Kind -match 'Comma|Variable') {
                            $value = $AstTokens[$i].Text
                        }
                        else {
                            #Assume text and quote it
                            Write-Verbose "Quoting $($AstTokens[$i].Text)"
                            $value = "'$($AstTokens[$i].Text)'"
                        }
                    }
                    else {
                        Write-Verbose "Using text as is for $($AstTokens[$i].Text)"
                        $value = $AstTokens[$i].Text
                    }

                    Write-Verbose "Adding $Value to `$v"
                    $v += $value
                }
            } #while

            "$p = $v`r"
            Write-Verbose "hashentry -> $p = $v`r"
        }

    } #for

    Write-Verbose 'Finished processing AST'
    Write-Verbose ($r | Out-String)

    #create text
    $HashText = @"
`$paramHash = @{
 $r}

$cmd @paramHash
"@

    #insert the text which should replace the highlighted line
    $psISE.CurrentFile.Editor.InsertText($HashText)

}


