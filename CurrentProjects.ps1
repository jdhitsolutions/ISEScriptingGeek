#requires -version 4.0

<#
The list is a simple text file with the complete path to scripts you are working on.
#>


Function Add-CurrentProject {
<#
.Synopsis
Add the file to the current project list file
.Description
This command adds the current file path to the current project list. The list is simply a text file with full file names to a group of scripts that you might be working on. The ISEScriptingGeek module uses a built-in variable, $currentProjectList.

.Link
Edit-CurrentProject
Import-CurrentProject
#>


[cmdletbinding()]
Param(
[ValidateNotNullorEmpty()]    
[string]$List = $currentProjectList
)

#add the current file path to the list if it isn't already there
If ((Get-Content -path $CurrentProjectList) -notcontains $psise.CurrentFile.FullPath) {
    $psise.CurrentFile.FullPath | Out-File -FilePath $list -Encoding ascii -Append
}
else {
    write-warning "$($psise.CurrentFile.FullPath) already in $list"

}
} #Add-CurrentProject

Function Edit-CurrentProject {
<#
.Synopsis
Edit the current project list file
.Description
Open the current project list in the PowerShell ISE to view or edit. You will need to manually remove items. The list is simply a text file with full file names to a group of scripts that you might be working on. The ISEScriptingGeek module uses a built-in variable, $currentProjectList.

.Link
Add-CurrentProject
Import-CurrentProject
#>

[cmdletbinding()]
Param(
[Parameter(Position=0,Mandatory)]
[ValidateScript({
if (Test-Path $_) {
   $True
}
else {
   Throw "Cannot validate path $_"
}
})]     
[string]$List
)

psedit $list

} #Edit-CurrentProject

Function Import-CurrentProject {
<#
.Synopsis
Open files from the project list
.Description
Read the current project list and open each file in the ISE. The list is simply a text file with full file names to a group of scripts that you might be working on. The ISEScriptingGeek module uses a built-in variable, $currentProjectList.
.Link
Add-CurrentProject
Edit-CurrentProject

#>
[cmdletbinding()]
Param(
[Parameter(Position=0,Mandatory)]
[ValidateScript({
if (Test-Path $_) {
   $True
}
else {
   Throw "Cannot validate path $_"
}
})]     
[string]$List
)

#get the list of file paths filtering out any blank lines
$items = Get-Content -Path $list | where {$_}

foreach ($item in $items) {
  if (Test-Path $item) {
    psedit $item
  }
  else {
    write-warning "Can't find $item"
  }
}

} #Import-CurrentProject