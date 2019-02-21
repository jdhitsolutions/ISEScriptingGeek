---
external help file: ISEScriptingGeek-help.xml
Module Name: ISEScriptingGeek
online version: http://jdhitsolutions.com/blog/2014/09/friday-fun-creating-powershell-scripts-with-powershell
schema: 2.0.0
---

# Get-ScriptComments

## SYNOPSIS

Get comments from a PowerShell script file.

## SYNTAX

```yaml
Get-ScriptComments [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION

This command will use the AST parser to go through a PowerShell script, either a .ps1 or .psm1 file, and display only the comments.

## PARAMETERS

### -Path

Enter the path of a PS1 file

```yaml
Type: String
Parameter Sets: (All)
Aliases: PSPath, Name

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS
