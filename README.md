# ISEScriptingGeek Module

[![PSGallery Version](https://img.shields.io/powershellgallery/v/ISEScriptingGeek.png?style=for-the-badge&logo=powershell&label=PowerShell%20Gallery)](https://www.powershellgallery.com/packages/ISEScriptingGeek/) [![PSGallery Downloads](https://img.shields.io/powershellgallery/dt/ISEScriptingGeek.png?style=for-the-badge&label=Downloads)](https://www.powershellgallery.com/packages/ISEScriptingGeek/)


This module is a set of ISE add-ons and a few themes. It requires PowerShell 4.0 or higher.

_As of February 2019 I no longer intend to update or extend this module. VS Code is clearly Microsoft's choice for a scripting tool going forward. The PowerShell ISE isn't going away any time soon, but it is also no longer under active development so I need no point in continuing to develop this module. I will maintain it and address pull requests should members of the community wish to contribute, maintain or extend this module._

## Themes

The themes can be found and imported from the Themes subfolder of the module.
These are optional and are not connected to the add-ons.

## Add-ons

Once the module is imported, the add-ons will be listed under **ISE Scripting Geek** on the **Add-ons** menu in the ISE.
A number of the add-ons fall into grouped subfolders:

### Bookmarks

A set of functions for creating and working with "bookmarks" to files opened in the ISE.

### Convert

These handle various conversions such as:

- selected text to snippet, region
- case conversion
- alias expansion

### Dates and times

A set of functions for inserting date/time in different formats

### Files

A set of functions for working with open files and their associated folders

### Work

A set of functions for creating and managing a "work list" of files

### Misc

There are also other scripts directly off the **ISE Scripting Geek** menu, these functions provide various capabilities:
- Print, Run or Sign script
- Send script to Word (with or without color)
- Send selected text to different search engines
- Help functions
- New CIM Command, DSC Resource snippets, etc.

Please submit issues for defects, enhancements, or documentation.

*Last updated 21 February 2019*