

#dot source the scripts
Get-ChildItem $psScriptRoot\functions\*.ps1 |
    Foreach-Object {. $_.FullName}

<#
Add an ISE Menu shortcut to save all open files.
This will only save files that have previously been saved
with a title. Anything that is untitled still needs
to be manually saved first.
#>

$SaveAll = {
    $psISE.CurrentPowerShellTab.files |
        Where-Object {-Not ($_.IsUntitled)} |
        ForEach-Object {
        $_.Save()
    }
}

#a function to display scripting about topics
Function Get-ScriptingHelp {
    Param()
    Get-Help about_Scripting* | Select-Object Name, Synopsis |
        Out-GridView -Title "Select one or more help topics" -OutputMode Multiple |
        ForEach-Object { $_ | Get-Help -ShowWindow}
}

#a function to for parameters for the current script
#using Show-Command
Function Start-MyScript {
    Param([string]$Path = $psISE.CurrentFile.FullPath)
    If (Test-path $Path) {
        Show-Command -Name $path
    }
    else {
        Write-Warning "No file found"
    }

} #end function

#set location to current script location
Function Set-ScriptLocation {
    [cmdletbinding()]
    [alias("sd")]
    Param()

    $path = Split-Path -Path $psISE.CurrentFile.FullPath
    set-location -path $path
    clear-host

}

#create a custom sub menu
$ScriptingGeek = $psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("ISE Scripting Geek", $null, $null)
#create some child menus for better organization
$Book = $ScriptingGeek.Submenus.add("Bookmarks", $Null, $Null)
$convert = $ScriptingGeek.Submenus.Add("Convert", $Null, $null)
$dates = $ScriptingGeek.submenus.Add("Dates and Times", $Null, $Null)
$files = $ScriptingGeek.Submenus.Add("Files", $Null, $null)
$work = $ScriptingGeek.submenus.Add("Work", $Null, $null)

#add my menu addons in sort of alphabetical order
[void]$ScriptingGeek.submenus.Add("Add Help", {New-CommentHelp}, "ALT+H")

[void]$convert.submenus.Add("Convert All Aliases", {ConvertTo-Definition $psISE.CurrentFile.Editor.SelectedText}, $Null)
[void]$convert.submenus.Add("Convert Help to Comment Help", {ConvertTo-CommentHelp}, "Ctrl+Shift+H")

[void]$convert.submenus.Add("Convert Code to Snippet", {Convert-CodeToSnippet -Text $psISE.CurrentFile.Editor.SelectedText}, "CTRL+ALT+S")

[void]$convert.submenus.Add("Convert Selected to Region", {
        $psISE.CurrentFile.Editor.InsertText("#region`r`r$($psISE.CurrentFile.Editor.SelectedText)`r`r#endregion")}, $null)
[void]$convert.submenus.Add("Convert Selected From Alias", {ConvertFrom-Alias}, $Null)
[void]$convert.submenus.Add("Convert Single Selected to Alias", {Convert-AliasDefinition $psISE.CurrentFile.Editor.SelectedText -ToAlias}, $Null)
[void]$convert.submenus.Add("Convert Single Selected to Command", {Convert-AliasDefinition $psISE.CurrentFile.Editor.SelectedText -ToDefinition}, $Null)
[void]$convert.Submenus.Add("Convert to lowercase",{$psISE.CurrentFile.editor.InsertText($psISE.CurrentFile.Editor.SelectedText.toLower())}, "CTRL+ALT+L")
[void]$convert.Submenus.Add("Convert to parameter hash", {Convert-CommandToHash}, "Ctrl+ALT+H")
[void]$convert.submenus.Add("Convert to text file", {ConvertTo-TextFile}, "ALT+T")
[void]$convert.Submenus.Add("Convert to uppercase", {$psISE.CurrentFile.editor.InsertText($psISE.CurrentFile.Editor.SelectedText.toUpper())}, "CTRL+ALT+U")

[void]$ScriptingGeek.Submenus.add("Create new DSC Resource Snippets", {Get-DSCResource | New-DSCResourceSnippet}, $Null)
[void]$ScriptingGeek.submenus.add("Edit your ISE profile", {
        If (Test-Path $Profile) {
            Open-EditorFile $profile
        }
        else {
            write-warning "Cannot find $profile"
        }
    }, $Null)
[void]$convert.Submenus.Add("Convert to block comment", {ConvertTo-MultiLineComment}, "Ctrl+Alt+B")

[void]$convert.Submenus.Add("Convert from block comment", {ConvertFrom-MultiLineComment}, "Ctrl+Alt+C")

[void]$files.Submenus.Add("Close All Files", {CloseAllFiles}, "Ctrl+Alt+F4")
[void]$files.Submenus.Add("Close All Files Except Active", {CloseAllFilesButCurrent}, "Ctrl+Shift+F4")

[void]$files.submenus.Add("Edit snippets", {Edit-Snippet}, $Null)

[void]$files.submenus.Add("Get Script Profile", {Get-ASTProfile}, $Null)

[void]$ScriptingGeek.submenus.Add("Get Scripting Help", {Get-ScriptingHelp}, $Null)

[void]$files.Submenus.add("Find in File", {Find-InFile}, "Ctrl+Shift+F")
[void]$files.Submenus.Add("New File", {New-FileHere}, "Ctrl+Alt+N")

[void]$dates.submenus.Add("Insert DateTime", {$psISE.CurrentFile.Editor.InsertText(("{0} {1}" -f (get-date), (get-wmiobject win32_timezone -property StandardName).standardName))}, "ALT+F5")
[void]$dates.submenus.Add("Insert Short Date", {$psISE.CurrentFile.editor.InsertText((Get-Date).ToShortDateString())}, "ALT+F6")
[void]$dates.submenus.Add("Insert Short Time", {$psISE.CurrentFile.editor.InsertText((Get-Date).ToShortTimeString())}, "ALT+F7")
[void]$dates.submenus.Add("Insert Short Date Time", {$psISE.CurrentFile.editor.InsertText((Get-Date -Format g))}, "ALT+F8")
[void]$dates.submenus.Add("Insert Long Date", {$psISE.CurrentFile.editor.InsertText((Get-Date -displayhint Date))}, "ALT+F9")
[void]$dates.submenus.Add("Insert UTC Date", {$psISE.CurrentFile.editor.InsertText((Get-Date -format u))}, "ALT+F10")
[void]$dates.submenus.Add("Insert GMT Date", {$psISE.CurrentFile.editor.InsertText((Get-Date -format r))}, "ALT+F11")


[void]$ScriptingGeek.Submenus.add("New CIM Command", {New-CimCommand}, $Null)
[void]$files.submenus.Add("Open Current Script Folder", {Invoke-Item (split-path $psISE.CurrentFile.FullPath)}, "ALT+O")
[void]$files.Submenus.Add("Open Selected File", {Open-SelectedISE}, "Ctrl+Alt+F")
[void]$files.Submenus.Add("Reload Selected File", {Reset-ISEFile}, "Ctrl+Alt+R")
[void]$ScriptingGeek.submenus.Add("Print Script", {Send-ToPrinter}, "CTRL+ALT+P")
[void]$ScriptingGeek.submenus.Add("Run Script", {Start-MyScript}, "CTRL+SHIFT+Z")
[void]$files.Submenus.Add("Save All Files", $SaveAll, "Ctrl+Shift+A")
[void]$files.submenus.Add("Save File as ASCII", {$psISE.CurrentFile.Save([Text.Encoding]::ASCII)}, $null)
[void]$ScriptingGeek.Submenus.Add("Search selected text with Bing", {Get-SearchResult -SearchEngine Bing}, "Shift+Alt+B")
[void]$ScriptingGeek.Submenus.Add("Search selected text with Google", {Get-SearchResult -SearchEngine Google}, "Shift+Alt+G")
[void]$ScriptingGeek.Submenus.Add("Send to Word", {Copy-ToWord}, "Ctrl+Alt+W")
[void]$ScriptingGeek.Submenus.Add("Send to Word Colorized", {Copy-ToWord -Colorized}, $Null) #
[void]$ScriptingGeek.submenus.Add("Sign Script", {Write-Signature}, $null)
[void]$ScriptingGeek.Submenus.Add("Switch next tab", {Get-NextISETab}, "Ctrl+ALT+T")
[void]$ScriptingGeek.Submenus.Add("Use local help", {$psISE.Options.UseLocalHelp = $True}, $Null)
[void]$ScriptingGeek.Submenus.Add("Use online help", {$psISE.Options.UseLocalHelp = $False}, $Null)
[void]$book.Submenus.Add("Add ISE Bookmark", {Add-ISEBookmark}, "Ctrl+Shift+N")
[void]$book.Submenus.Add("Clear ISE Bookmarks", {Remove-Item $MyBookmarks}, "Ctrl+Shift+C")
[void]$book.Submenus.Add("Get ISE Bookmark", {Get-ISEBookmark}, "Ctrl+Shift+G")
[void]$book.Submenus.Add("Open ISE Bookmark", {Open-ISEBookmark}, "Ctrl+Shift+O")
[void]$book.Submenus.Add("Remove ISE Bookmark", {Remove-ISEBookmark}, "Ctrl+Shift+K")
[void]$book.Submenus.Add("Update ISE Bookmark", {Update-ISEBookmark}, "Ctrl+Shift+X")
[void]$work.submenus.Add("Add current file to work", {Add-CurrentProject -List $currentProjectList}, "CTRL+Alt+A")
[void]$work.submenus.Add("Edit current work file", {Edit-CurrentProject -List $currentProjectList}, "CTRL+Alt+E")
[void]$work.submenus.Add("Open current work files", {Import-CurrentProject -List $currentProjectList}, "CTRL+Alt+I")


#define some ISE specific variables
$MySnippets = "$Env:USERPROFILE\Documents\WindowsPowerShell\Snippets"
$MyModules = Join-Path -Path $env:userprofile -ChildPath "documents\WindowsPowerShell\Modules"
$MyPowerShell = "$env:userprofile\Documents\WindowsPowerShell"
$MyBookmarks = Join-Path -path $myPowerShell -ChildPath "myISEBookmarks.csv"
$CurrentProjectList = Join-Path -Path $env:USERPROFILE\Documents\WindowsPowerShell -ChildPath "currentWork.txt"

Export-ModuleMember -Variable 'MySnippets','MyModules','MyPowerShell','MyBookmarks','CurrentProjectList' -alias 'ccs', 'gcmd', 'glcm''tab', 'sd'

