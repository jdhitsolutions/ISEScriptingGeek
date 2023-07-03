#copy selected ISE text to Microsoft Word

Function Copy-ToWord {
    [CmdletBinding()]
    Param(
        [ValidatePattern("\S+")]
        [string[]]$Text = $psISE.CurrentFile.Editor.SelectedText,
        [Switch]$Colorized
    )

    If (($null -eq $global:word.Application) -OR -NOT (Get-Process WinWord)) {
        #remove any variables that might be left over just to be safe
        Remove-Variable -Name doc, selection -Force -ErrorAction SilentlyContinue

        #create a Word instance if the object doesn't already exist
        $global:word = New-Object -ComObject word.application

        #create a new document
        $global:doc = $global:word.Documents.add()

        #create a selection
        $global:selection = $global:word.Selection

        #set font and paragraph for fixed width content
        $global:selection.Font.Name = "Consolas"
        $global:selection.font.Size = 10
        $global:selection.paragraphFormat.SpaceBefore = 0
        $global:selection.paragraphFormat.SpaceAfter = 0

        #show the Word document
        $global:word.Visible = $True
    }

    if ($Colorized) {
        #copy the selection to the clipboard and paste
        #This is a shortcut hack that may not always work the first time
        $wshell = New-Object -ComObject Wscript.shell
        #must be lower-case c otherwise you will end up sending
        #ctrl+shift+c
        $wshell.SendKeys("^c")
        #timing is everything with SendKeys. This could be a lower value
        start-sleep -Milliseconds 500
        $global:selection.Paste()
    }
    else {
        #insert the text
        $global:selection.TypeText($text)
    }

    #insert a new paragraph (ENTER)
    $global:selection.TypeParagraph()

} #end Function

