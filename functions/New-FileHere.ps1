
Function New-FileHere {
    [CmdletBinding()]
    Param(
        [String]$Name = (New-InputBox -Prompt 'Enter a file name' -Title 'New File' -Default 'MyUntitled.ps1'),
        [Switch]$Open,
        [Switch]$PassThru
    )


    if ($name -match '\w+') {
        $NewPath = Join-Path -Path (Get-Location).Path -ChildPath $name
        if (Test-Path -Path $NewPath) {
            Write-Warning "A file with the name $name already exists. Please try again."
        }
        else {
            Write-Verbose "Adding $newFile"
            $head = @"
#Requires -version $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor)

<#
$Name

  ****************************************************************
  * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
  * THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK.  IF   *
  * YOU DO NOT UNDERSTAND WHAT THIS SCRIPT DOES OR HOW IT WORKS, *
  * DO NOT USE IT OUTSIDE OF A SECURE, TEST SETTING.             *
  ****************************************************************
#>


"@
            $head | Out-File -FilePath $NewPath -NoClobber

            #give the file a chance to be created
            Start-Sleep -Seconds 1

            #Open the file
            if ($Open) {
                psedit $NewPath
            }
            if ($PassThru) {
                Get-Item $NewPath
            }

        }
    }
    else {
        Write-Host 'Aborting' -ForegroundColor Yellow
    }
} #end function
