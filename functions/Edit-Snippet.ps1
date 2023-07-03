Function Edit-Snippet {
    Param(
        [String]$Path = "$env:userprofile\Documents\WindowsPowerShell\Snippets"
    )

    #display snippets by name without the .snippet.ps1xml extension
    $snips = Get-ChildItem $path | Select-Object @{Name = 'Name'; Expression = { $_.name.split('.')[0] } } |
    Out-GridView -Title 'Select one or more snippets to edit' -OutputMode Multiple

    foreach ($snip in $snips) {
        $file = Join-Path -Path $path -ChildPath "$($snip.name).snippets.ps1xml"
        Open-EditorFile $file
    }

}

