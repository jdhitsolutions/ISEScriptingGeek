#requires -version 4.0

Function New-DSCResourceSnippet {

<#
.Synopsis
Create ISE snippets for DSC Resources
.Description
This command will convert the syntax for a DSC resource into an ISE snippet. Snippets will be created in the default location. Snippet names will take the name "DSC <resource name>". The snippet description uses the format "<Resource Name> resource from module <module name> <vendor>". You will end up with a description like this:

xWinEventLog resource from module xWinEventLog Microsoft Corporation

You must run this command in the PowerShell ISE.

.Example
PS C:\> New-DSCResourceSnippet -name xsmbshare -author "Jeff Hicks" -passthru


    Directory: C:\Users\Jeff\documents\WindowsPowerShell\Snippets


Mode                LastWriteTime     Length Name                                                              
----                -------------     ------ ----                                                              
-a---        10/20/2014   8:48 AM       1157 DSC xSmbShare Resource.snippets.ps1xml            

Create a snippet from a single resource.
.Example
PS C:\> Get-DSCResource | New-DSCResourceSnippet

This command will create snippets for every installed DSC resource. Existing snippet files will be overwritten.
.Notes
Last Updated: October 20, 2014
Version     : 1.0

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

  ****************************************************************
  * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
  * THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK.  IF   *
  * YOU DO NOT UNDERSTAND WHAT THIS SCRIPT DOES OR HOW IT WORKS, *
  * DO NOT USE IT OUTSIDE OF A SECURE, TEST SETTING.             *
  ****************************************************************

.Link
Get-DSCResource
New-ISESnippet
#>

[cmdletbinding(SupportsShouldProcess=$True,DefaultParameterSetName="Name")]
Param(
[Parameter(Position=0,Mandatory=$True,HelpMessage="Enter the name of a DSC resource",
ParameterSetName="Name")]
[ValidateNotNullorEmpty()]
[string[]]$Name,
[Parameter(Position=0,Mandatory=$True,HelpMessage="Enter the name of a DSC resource",
ValueFromPipeline=$True,ParameterSetName="Resource")]
[ValidateNotNullorEmpty()]
[Microsoft.PowerShell.DesiredStateConfiguration.DscResourceInfo[]] $DSCResource,
[ValidateNotNullorEmpty()]
[string]$Author = $env:username,
[Switch]$Passthru
)

Begin {
    Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"  
} #begin

Process {

if ($PSCmdlet.ParameterSetName -eq 'Name') {
    #get the resource from the name
    Try {
        Write-Verbose "Getting DSC Resource $Name"
        $DSCResource = Get-DscResource -Name $Name -ErrorAction Stop
    }
    Catch {
        Throw
    }
}

foreach ($resource in $DSCResource) {

#create the entry based on resource properties
[string[]]$entry = "`n$($resource.name) <ResourceID> {`n"

    Write-Verbose "Creating resource entry for $($resource.name)"
    $entry+= "`t#from module $($resource.module.name)"
    $entry+=  foreach ($item in $resource.Properties) {
     if ($item.IsMandatory) {
       $resourcename="`t*$($item.name)"
     }
     else {
     $resourcename = "`t$($item.name)"
     }

     if ($item.PropertyType -eq '[bool]') {
       $possibleValues = "`$True | `$False"
     }
    elseif ($item.values) {
      $possibleValues = "'$($item.Values -join "' | '")'"
     }
    else {
      $possibleValues=$item.PropertyType
    } 
    "$resourcename = $($possibleValues)"

    } #foreach

$entry+="`n} #end $($resource.name) resource`n`n"

$title = "DSC $($resource.name) Resource"
$description = "$($resource.name) resource from module $($resource.module) $($resource.CompanyName)"

Write-Verbose "Creating snippet $title"
Write-Verbose $description
Write-Verbose ($entry | Out-String)

$paramHash = @{
 Title = $Title
 Description = $description
 Text = ($Entry | Out-String)
 Author = $Author
 Force = $True
 ErrorAction = "Stop"
}

Write-Verbose ($paramHash | Out-String)
if ($PSCmdlet.ShouldProcess($Resource.name)) {
    
    Try {
      Write-Debug "Creating snippet file"
      New-IseSnippet @paramHash
    
        if ($Passthru) {
            #build the path
            $snippath = join-path -path "$env:Userprofile\documents\WindowsPowerShell\Snippets" -ChildPath "$title.snippets.ps1xml"
            Get-Item -path $snippath
        }
    } 
    Catch {
        Throw
    }

} #if shouldprocess
} #foreach resource

} #process

End {
    #import the new snippets into the current session. They will 
    #automatically be loaded next time.
    Write-Verbose "Importing new snippets"
    Import-IseSnippet -Path "$env:Userprofile\documents\WindowsPowerShell\Snippets"
    Write-Verbose -Message "Ending $($MyInvocation.Mycommand)"
} #end


} #end function