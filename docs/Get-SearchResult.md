---
external help file: ISEScriptingGeek-help.xml
Module Name: ISEScriptingGeek
online version: http://jdhitsolutions.com/blog/2014/09/friday-fun-creating-powershell-scripts-with-powershell
schema: 2.0.0
---

# Get-SearchResult

## SYNOPSIS

Search for selected text online

## SYNTAX

```yaml
Get-SearchResult [[-Text] <String>] [-SearchEngine <String>] [<CommonParameters>]
```

## DESCRIPTION

Use this command to search online for the selected text. The default is Google.

## PARAMETERS

### -SearchEngine

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Bing, Google, Yahoo

Required: False
Position: Named
Default value: Google
Accept pipeline input: False
Accept wildcard characters: False
```

### -Text

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS
