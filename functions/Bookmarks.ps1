
#create a script bookmarking system for the PowerShell ISE

Function Get-ISEBookmark {
    [CmdletBinding()]
    Param()

    Write-Verbose "Importing bookmarks from $MyBookmarks"
    Try {
        Import-Csv $MyBookmarks -ErrorAction Stop |
        Out-GridView -Title 'My ISE Bookmarks' -OutputMode Single
    }
    Catch {
        Write-Warning "Failed to find or import bookmarks from $($MyBookmarks). Does file exist?"
    }
} #close Get-ISEBookmark

Function Open-ISEBookmark {
    [CmdletBinding()]
    Param()

    $bookmark = Get-ISEBookmark

    if ($bookmark) {
        Write-Verbose "Processing bookmark $($bookmark.name) for $($bookmark.path)"

        #open the file
        Open-EditorFile $bookmark.path

        #find the file in the collection of open files
        $search = $psISE.CurrentPowerShellTab.files.where( { $_.FullPath -eq $bookmark.path })

        #make the file the currently selected
        $psISE.CurrentPowerShellTab.files.SelectedFile = $search[0]

        #jump to the bookmark location
        Write-Verbose "Jumping to line $($Bookmark.LineNumber)"
        $search[0].editor.SetCaretPosition($bookmark.LineNumber, 1)
    } #if bookmark

}  #close Open-ISEBookmark

Function Remove-ISEBookmark {
    [CmdletBinding(SupportsShouldProcess)]
    Param()

    $bookmark = Get-ISEBookmark

    if ($bookmark) {
        Write-Verbose "Processing bookmark $($bookmark.name) for $($bookmark.path)"
        $save = Import-Csv -Path $MyBookmarks | Where-Object { $_.id -notmatch $bookmark.id }
        Write-Verbose "Updating $MyBookmarks"
        $save | Export-Csv -Path $MyBookmarks -Encoding ASCII

    } #if bookmark

} #close Remove-ISEBookmark

Function Update-ISEBookmark {
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, ValueFromPipeline)]
        [object]$Bookmark
    )

    $bookmark = Get-ISEBookmark

    if ($bookmark) {
        Write-Verbose "Processing bookmark $($bookmark.name) for $($bookmark.path)"
        $line = New-Inputbox -Prompt 'Enter the line number' -Title $MyInvocation.MyCommand -Default $Bookmark.LineNumber
        if ($line) {
            $name = New-Inputbox -Prompt 'Enter the name' -Title $MyInvocation.MyCommand -Default $Bookmark.name
        }
        else {
            #nothing entered so bail out
            Write-Verbose 'Cancelling'
            Return
        }

        If ($name) {

            #get all bookmarks
            $all = Get-Content -Path $MyBookmarks | ConvertFrom-Csv

            #get matching bookmark by ID from CSV file
            $bmk = $all.where( { $_.id -eq $bookmark.id })

            #update the entry
            $bmk[0].LineNumber = $line
            $bmk[0].name = $name

            #save the results back to the file
            $all | Export-Csv -Path $MyBookmarks
        }
        else {
            #cancelling
            Write-Verbose 'Cancelling'
        }
    } #close if bookmark

} #close Update-ISEBookmark

Function Add-ISEBookmark {

    $line = $psISE.CurrentFile.Editor.CaretLine
    $path = $psISE.CurrentFile.FullPath
    $name = New-Inputbox -Prompt 'Enter a name or description for this bookmark.' -Title 'Add ISE Bookmark'

    $obj = [PSCustomObject]@{
        ID         = [guid]::NewGuid().guid
        LineNumber = $line
        Name       = $name
        Path       = $Path
    }
    $obj | Export-Csv -Path $MyBookmarks -Append -Encoding ASCII

} #close Add-ISEBookmark
