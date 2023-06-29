
Function New-FileHere {

    [cmdletbinding()]
    Param(
        [string]$Name = (New-Inputbox -Prompt "Enter a file name" -Title "New File" -Default "MyUntitled.ps1"),
        [switch]$Open,
        [switch]$Passthru
    )


    if ($name -match "\w+") {
        $newpath = Join-path -Path (Get-Location).Path -ChildPath $name
        if (Test-Path -Path $newpath) {
            Write-Warning "A file with the name $name already exists. Please try again."
        }
        else {
            write-verbose "Adding $newFile"
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
            $head | Out-File -FilePath $newPath -NoClobber

            #give the file a chance to be created
            start-sleep -Seconds 1

            #Open the file
            if ($Open) {
                psedit $newpath
            }
            if ($Passthru) {
                Get-Item $newpath
            }

        }
    }
    else {
        Write-host "Aborting" -ForegroundColor Yellow
    }
} #end function