---
external help file: ISEScriptingGeek-help.xml
Module Name: ISEScriptingGeek
online version:
schema: 2.0.0
---

# New-FileHere

## SYNOPSIS

Create a new file in the current path.

## SYNTAX

```yaml
New-FileHere [[-Name] <String>] [-Open] [-Passthru] [<CommonParameters>]
```

## DESCRIPTION

When you create a new file, the ISE wants to create it in the directory you were in when you started the ISE.
I often want to create a new file in the current location. This command has no parameters. You will be prompted for a new file name if you don't specify one.


## PARAMETERS

### -Name

Enter the name of the new file. If you don't specify one you will be prompted.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: (New-Inputbox -Prompt "Enter a file name" -Title "New File" -Default "MyUntitled.ps1")
Accept pipeline input: False
Accept wildcard characters: False
```

### -Open

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Passthru

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
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
