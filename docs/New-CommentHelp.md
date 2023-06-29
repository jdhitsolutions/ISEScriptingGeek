---
external help file: ISEScriptingGeek-help.xml
Module Name: ISEScriptingGeek
online version:
schema: 2.0.0
---

# New-CommentHelp

## SYNOPSIS

Auto-generate comment based help.

## SYNTAX

```yaml
New-CommentHelp [-Name] <String> [-Synopsis] <String> [-Description] <String> [<CommonParameters>]
```

## DESCRIPTION

This will generate comment based help based on a loaded command and insert it into the current file in the ISE.

## PARAMETERS

### -Description

Enter a description. You can expand and edit later

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name

What is the name of your function or command?

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Synopsis

Enter a brief synopsis

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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
