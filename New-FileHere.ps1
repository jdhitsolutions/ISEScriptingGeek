#requires -version 4.0

<#
#>
Function New-FileHere {

<#
.Synopsis
Create a new file in the current path.
.Description
When you create a new file, the ISE wants to create it in the directory you were in when you started the ISE. I often want to create a new file in the current location. This command has no parameters. You will be prompted for a new file name.

#>
[cmdletbinding()]
Param()

[string]$name = New-Inputbox -Prompt "Enter a file name" -Title "New File" -Default "MyUntitled.ps1"
if ($name -match "\w+") {
    $newpath = Join-path -Path (Get-Location).Path -ChildPath $name
    if (Test-Path -Path $newpath) {
        Write-Warning "A file with the name $name already exists. Please try again."
    }
    else {
        write-verbose "Adding $newFile"
        "#requires -version $($PSVersionTable.PSVersion.tostring())" | Out-File -FilePath $newPath -NoClobber
        $newfile = $psise.CurrentPowerShellTab.Files.add($newpath)
        start-sleep -Seconds 1
        $newfile.editor.SetCaretPosition(2,1)
        $newfile.editor.InsertText("`n")
    }
}
else {
    Write-host "Aborting" -ForegroundColor Yellow
}
} #end function