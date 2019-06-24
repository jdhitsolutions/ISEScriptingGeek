# ChangeLog for ISEScriptingGeek Module

## v3.4.1

+ Replaced `Out-Null` references to using `[void]`
+ Cleaned up incorrect exported aliases
+ Code clean up and reformatting

## v3.4.0

+ code cleanup as some commands have moved to the PSScriptTools module.
+ Moved help to external files (Issue #11)
+ Renamed `changelog.txt` to `changelog.md`
+ module restructuring
+ Updated `README.md`

## v3.3.0.0

+ Added New-FileHere command
+ Fixed Open-SelectedISE to trim spaces from selected text and write a warning if file not found.
+ Added ChangeLog.txt file.
+ Added #requires -module PSDesiredStateConfiguration to New-DSCResourceSnippet.ps1
+ Switched to MIT license

## v3.3.1.0

+ Fixed a bug with New-CommentHelp to accept no parameters
+ Updated New-CommentHelp to ignore new Information related common parameters in v5

## v3.3.1.1

+ Updated New-FileHere function

## v3.3.1.2

+ Published to PowerShell Gallery with a v5 manifest.

## v3.3.1.3

+ updated module manifest
+ Updated script signing to support multiple certificates
+ Updated author name in manifest
