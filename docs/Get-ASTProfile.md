---
external help file: ISEScriptingGeek-help.xml
Module Name: ISEScriptingGeek
online version: https://bit.ly/46zLt4M
schema: 2.0.0
---

# Get-ASTProfile

## SYNOPSIS

Profile a PowerShell script

## SYNTAX

```yaml
Get-ASTProfile [[-Path] <String>] [-FilePath <String>] [<CommonParameters>]
```

## DESCRIPTION

This script will parse a PowerShell script using the AST to identify elements and any items that might be dangerous.
The output is a text report which by default is turned into a help topic stored in your Windows PowerShell folder under Documents, although you can specify an alternate location.

DETAILS
The script takes the name of a script to profile. You can specify a ps1 or psm1 filename. Using the AST the script will prepare a text report showing you any script requirements, script parameters, commands and type names.
You will see all commands used including those that can't be resolved as well as those that I thought might be considered potentially dangerous such as cmdlets that use the verbs Remove or Stop.

Because some people might invoke methods from .NET classes directly I've also captured all typenames.
Most of them will probably be related to parameters but as least you'll know what to look for.

The report won't detail parameters from nested functions but you'll still see what commands they will use.
The script uses Get-Command to identify commands which might entail loading a module. Most of the time this shouldn't be an issue but you still might want to profile the script in virtualized or test environment.

Any unresolved command you see is either from a module that couldn't be loaded or it might be an internally defined command. Once you know what to look for you can open the script in your favorite editor and search for the mystery commands.

Note that if the script uses application names like Main or Control for function names, they might be misinterpreted.
In that case, search the script for the name, ie "main".

This version will only analyze files with an extension of .ps1, .psm1 or .txt.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Get-ASTProfile c:\download\UnknownScript.ps1
```

This will analyze the script UnknownScript.ps1 and show the results in a help window.
It will also create a text file in your Documents\WindowsPowerShell folder called UnknownScript.help.txt.

### EXAMPLE 2

```powershell
PS C:\> Get-ASTProfile c:\download\UnknownScript.ps1 -filepath c:\work
```

This command is the same as the first example except the help file will be created in C:\Work.

## PARAMETERS

### -Path

The path to the script file. It should have an extension of .ps1, .psm1 or .bat.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $(Read-Host "Enter the filename and path to a PowerShell script")
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilePath

The path for the report file. The default is your WindowsPowerShell folder. This parameter has aliases of fp and out.

```yaml
Type: String
Parameter Sets: (All)
Aliases: fp, out

Required: False
Position: Named
Default value: "$env:userprofile\Documents\WindowsPowerShell"
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### Help topic

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-Command]()

[Get-Alias]()

