
<#
The list is a simple text file with the complete path to scripts you are working on.
#>


Function Add-CurrentProject {

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


    [cmdletbinding()]
    Param(
        [Parameter(Position = 0, Mandatory)]
        [ValidateScript( {
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

    [cmdletbinding()]
    Param(
        [Parameter(Position = 0, Mandatory)]
        [ValidateScript( {
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