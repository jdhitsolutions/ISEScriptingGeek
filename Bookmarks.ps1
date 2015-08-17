#requires -version 4.0

#create a script bookmarking system for the PowerShell ISE

Function Get-ISEBookmark {
[cmdletbinding()]
Param()

Write-Verbose "Importing bookmarks from $MyBookmarks"
Try {
    Import-CSV $MyBookmarks -ErrorAction Stop | 
    Out-GridView -Title "My ISE Bookmarks" -OutputMode Single 
}
Catch {
    Write-Warning "Failed to find or import bookmarks from $($MyBookmarks). Does file exist?"
}
} #close Get-ISEBookmark

Function Open-ISEBookmark {
[cmdletbinding()]
Param()

$bookmark = Get-ISEBookmark

if ($bookmark) {
    Write-Verbose "Processing bookmark $($bookmark.name) for $($bookmark.path)"
    
    #open the file
    psedit $bookmark.path

    #find the file in the collection of open files
    $search = $psise.CurrentPowerShellTab.files.where({$_.fullpath -eq $bookmark.path})

    #make the file the currently selected 
    $psise.CurrentPowerShellTab.files.SelectedFile = $search[0]

    #jump to the bookmark location
    Write-Verbose "Jumping to line $($Bookmark.LineNumber)"
    $search[0].editor.SetCaretPosition($bookmark.LineNumber,1)
} #if bookmark

}  #close Open-ISEBookmark

Function Remove-ISEBookmark {
[cmdletbinding(SupportsShouldProcess)]
Param()

$bookmark = Get-ISEBookmark

if ($bookmark) {
    Write-Verbose "Processing bookmark $($bookmark.name) for $($bookmark.path)"
    $save = Import-CSV -Path $MyBookmarks | where {$_.id -notmatch $bookmark.id}
    Write-Verbose "Updating $MyBookmarks"
    $save | Export-Csv -Path $MyBookmarks -Encoding ASCII

} #if bookmark

} #close Remove-ISEBookmark

Function Update-ISEBookmark {
[cmdletbinding()]
Param(
[Parameter(Position=0,ValueFromPipeline)]
[object]$Bookmark
)

$bookmark = Get-ISEBookmark

if ($bookmark) {
    Write-Verbose "Processing bookmark $($bookmark.name) for $($bookmark.path)"
    $line = New-Inputbox -Prompt "Enter the line number" -Title $MyInvocation.MyCommand -Default $Bookmark.LineNumber
    if ($line) {
        $name = New-Inputbox -Prompt "Enter the name" -Title $MyInvocation.MyCommand -Default $Bookmark.name
    }
    else {
        #nothing entered so bail out
        Write-Verbose "Cancelling"
        Return
    }

    If ($name) {

    #get all bookmarks
    $all = Get-content -Path $MyBookmarks | ConvertFrom-Csv

    #get matching bookmark by ID from CSV file
    $bmk = $all.where({$_.id -eq $bookmark.id})

    #update the entry
    $bmk[0].Linenumber = $line
    $bmk[0].name = $name
        
    #save the results back to the file
    $all | Export-Csv -Path $MyBookmarks
    } 
    else {
        #cancelling
        Write-Verbose "Cancelling"
    }
} #close if bookmark

} #close Update-ISEBookmark

Function Add-ISEBookmark {

$line = $psise.CurrentFile.Editor.CaretLine
$path = $psise.CurrentFile.FullPath
$name = New-Inputbox -Prompt "Enter a name or description for this bookmark." -Title "Add ISE Bookmark"

$obj = [pscustomobject]@{
 ID = [guid]::NewGuid().guid
 LineNumber = $line
 Name = $name
 Path = $Path
}
 $obj | Export-Csv -Path $MyBookmarks -Append -Encoding ASCII

} #close Add-ISEBookmark
