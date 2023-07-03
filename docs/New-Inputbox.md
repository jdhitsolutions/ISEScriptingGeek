---
external help file: ISEScriptingGeek-help.xml
Module Name: ISEScriptingGeek
online version: https://bit.ly/43bAgo3
schema: 2.0.0
---

# New-InputBox

## SYNOPSIS

Display a Visual Basic style InputBox.

## SYNTAX

```yaml
New-InputBox [-Prompt] <String> [[-Title] <String>] [[-Default] <String>] [<CommonParameters>]
```

## DESCRIPTION

This function will display a graphical InputBox, like the one from VisualBasic and VBScript. You must specify a messag prompt. You can specify a title, the default is "Input". You can also specify a default value. The InputBox will write  whatever is entered into it to the pipeline. If you click Cancel the InputBox will still write a string to the pipeline with a length of 0. It is recommended that you validate input.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> $c = New-InputBox -prompt "Enter the Netbios name of a domain computer." -title "Enter a computername" -default $env:computername
PS C:\> get-service -computer $c
```

## PARAMETERS

### -Prompt

Enter a message prompt

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

### -Title


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Input
Accept pipeline input: False
Accept wildcard characters: False
```

### -Default

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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

### [string]

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS
