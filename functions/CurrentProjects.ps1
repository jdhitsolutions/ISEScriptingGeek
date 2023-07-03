
<#
The list is a simple text file with the complete path to scripts you are working on.
#>


Function Add-CurrentProject {
    [CmdletBinding()]
    Param(
        [ValidateNotNullOrEmpty()]
        [String]$List = $currentProjectList
    )

    #add the current file path to the list if it isn't already there
    If ((Get-Content -Path $CurrentProjectList) -NotContains $psISE.CurrentFile.FullPath) {
        $psISE.CurrentFile.FullPath | Out-File -FilePath $list -Encoding ascii -Append
    }
    else {
        Write-Warning "$($psISE.CurrentFile.FullPath) already in $list"

    }
} #Add-CurrentProject

Function Edit-CurrentProject {

    [CmdletBinding()]
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
        [String]$List
    )

    Open-EditorFile $list

} #Edit-CurrentProject

Function Import-CurrentProject {
    [CmdletBinding()]
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
        [String]$List
    )

    #get the list of file paths filtering out any blank lines
    $items = Get-Content -Path $list | Where-Object { $_ }

    foreach ($item in $items) {
        if (Test-Path $item) {
            Open-EditorFile $item
        }
        else {
            Write-Warning "Can't find $item"
        }
    }

} #Import-CurrentProject
