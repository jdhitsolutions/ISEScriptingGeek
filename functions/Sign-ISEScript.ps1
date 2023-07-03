
Function Write-Signature {
    [cmdletbinding(SupportsShouldProcess)]
    Param()

    Set-StrictMode -Version Latest

    #get the code signing certificates that have not expired
    $cert = Get-ChildItem -Path Cert:\CurrentUser\My -CodeSigningCert | Where-Object { $_.Verify() }
    If ($cert.Count -eq '0') {
        Write-Warning 'No code signing certificate found.'
        Exit
    }
    ElseIf ($cert.Count -gt '1') {
        $cert = ($cert | Out-GridView -Title 'Select the desired code signing certificate' -OutputMode Single)
    }

    #save the file if necessary
    if (!$psISE.CurrentFile.IsSaved) {
        $psISE.CurrentFile.Save()
    }

    #if the file is encoded as BigEndian, re-save as Unicode
    if ($psISE.CurrentFile.Encoding.EncodingName -match 'Big-Endian') {
        $psISE.CurrentFile.Save([Text.Encoding]::Unicode) | Out-Null
    }

    #save the filepath for the current file so it can be re-opened later
    $filepath = $psISE.CurrentFile.FullPath

    #sign the file
    Try {
        Set-AuthenticodeSignature -FilePath $filepath -Certificate $cert -ErrorAction Stop
        #close the file
        $psISE.CurrentPowerShellTab.Files.Remove(($psISE.CurrentFile)) | Out-Null

        #reopen the file
        $psISE.CurrentPowerShellTab.Files.Add(($filepath)) | Out-Null
    }
    Catch {
        Write-Warning ('Script signing failed. {0}' -f $_.Exception.message)
    }
}#end function
