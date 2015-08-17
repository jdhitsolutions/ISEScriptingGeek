#requires -version 3.0

Function Convert-CodetoSnippet {
[cmdletbinding(SupportsShouldProcess=$True)]

Param(
[Parameter(Position=0,Mandatory=$True,
HelpMessage="Enter some code text or break, select text in the ISE and try again.")]
[ValidateNotNullorEmpty()]
[string]$Text
)

Add-Type -AssemblyName "Microsoft.VisualBasic"

$title = [Microsoft.VisualBasic.Interaction]::InputBox("Enter a title for your snippet",$MyInvocation.mycommand.name)

if ($title) {
    $description = [Microsoft.VisualBasic.Interaction]::InputBox("Enter a description for your snippet",$MyInvocation.mycommand.name,"This is required")
    if ($description) {
        $author = [Microsoft.VisualBasic.Interaction]::InputBox("Enter an author for your snippet",$MyInvocation.mycommand.name,$env:username)
        if (!$author) {
            $author=" "
        } #if author
    } #if description
    else {
        #if no description assume user cancelled
        Write-Warning -Message "No description was specified. Operation cancelled."
        Return
    }
    
    if ($PSCmdlet.ShouldProcess($title) ) {
      Try {
        New-IseSnippet -Title $title -Text $Text -description $Description -author $Author
      }
      Catch {
        $message = ("There was an error creating the snippet. `n`n{0} `n`nDo you want to force an overwrite?" -f $_.exception.message)
        $returnValue=[microsoft.visualbasic.interaction]::Msgbox($message,"YesNo,Exclamation",$MyInvocation.MyCommand.name)
        if ($returnValue -eq "yes") {
            #re-run the command but this time with -Force
            New-IseSnippet -Title $title -Text $Text -description $Description -author $Author -Force
        }
      }
    } #shouldprocess
}

} #end Convert-CodeToSnippet

Set-Alias ccs Convert-CodeToSnippet

