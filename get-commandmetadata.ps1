#requires -version 3.0

#run this in the PowerShell ISE for best results

Function Get-CommandMetadata {

<#
.Synopsis
Create a proxy function of a PowerShell command.
.Description
This command will create a proxy version of a PowerShell cmdlet, function or alias. The intent is to simplify creating a new function from command metadata. You can give your command and opt to remove help references for the original command. 

If you run this in the PowerShell ISE, code for the new function will be inserted into a new Powershell tab.
.Parameter Command
The name of a PowerShell command to proxy. This can be a cmdlet, function or alias.
.Parameter NewName
The name you want to use for your new command.
.Parameter NoHelp
Remove references to existing command help. Using this parameter will insert a comment-based help outline.
.Example
PS C:\> Get-CommandMetadata Get-WMIObject -nohelp -newname Get-MyOS

Create a proxy function for Get-WMIObject that will be called Get-MyOS. Help references will be replaced with a comment-help block.
.Notes
Last Updated: Sept. 3, 2014
Version     : 1.1

.Link
http://jdhitsolutions.com/blog/2014/09/friday-fun-creating-powershell-scripts-with-powershell

#>
[cmdletbinding()]
Param(
[Parameter(Position=0,Mandatory,HelpMessage="Enter the name of a PowerShell command")]
[ValidateNotNullorEmpty()]
[string]$Command,
[string]$NewName,
[switch]$NoHelp
)

Try {
    Write-Verbose "Getting command metadata for $command"
    $gcm = Get-Command -Name $command -ErrorAction Stop
    #allow an alias or command name
    if ($gcm.CommandType -eq 'Alias') {
       $cmdName = $gcm.ResolvedCommandName
    }
    else {
        $cmdName = $gcm.Name
    }
    Write-Verbose "Resolved to $cmdName"
    $cmd = New-Object System.Management.Automation.CommandMetaData ($gcm)
}
Catch {
    Write-Warning "Failed to create command metadata for $command"
    Write-Warning $_.Exception.Message
}

if ($cmd) {
    #create the metadata
        
    if ($NewName) {
        $Name = $NewName
    }
    else {
        $Name = $cmd.Name
    }

    if ($noHelp) {
        #remove help link
        $cmd.HelpUri = $Null

        Write-Verbose "Defining a new comment based help block"
        #define outline for comment based help
$myHelp = @"

.Synopsis
PUT SYNTAX HERE
.Description
PUT DESCRIPTION HERE
.Notes
Created:`t$(Get-Date -format d) 

.Example
PS C:\> $Name

.Link
$cmdname

"@
    Write-Verbose "Creating proxy command with help" 
    $metadata = [System.Management.Automation.ProxyCommand]::Create($cmd,$myHelp)

    } #nohelp
    else {
        Write-Verbose "Creating proxy command" 
        $metadata = [System.Management.Automation.ProxyCommand]::Create($cmd)
    }

   Write-Verbose "Cleaning up parameter names"
   [regex]$rx="[\s+]\$\{\w+\}[,|)]"
   $metadata = $metadata.split("`n") | foreach {
     If ($rx.ismatch($_)) {
     #strip off { } around parameter names 
      $rx.Match($_).Value.Replace("{","").Replace("}","")
     # "`n"
    }
    else {
     #just write the line
     $_
     }
    } #foreach

#define the text for the new command
    $text = @"
#requires -version $($PSVersionTable.psversion)

Function $Name {

$metadata

} #end function $Name
"@
    if ($host.Name -match "PowerShell ISE") {
    #open in a new ISE tab
    $tab = $psise.CurrentPowerShellTab.Files.Add()

    Write-Verbose "Opening metadata in a new ISE tab"
    $tab.editor.InsertText($Text)

    #jump to the top
    $tab.Editor.SetCaretPosition(1,1)
    }
    else {
      $Text
    }
}
Write-Verbose "Ending $($MyInvocation.MyCommand)"

} #end function

Set-Alias -Name gcmd -Value Get-CommandMetaData