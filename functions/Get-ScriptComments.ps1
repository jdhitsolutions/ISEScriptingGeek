
#parse a script file for comments only

Function Get-ScriptComments {
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = 'Enter the path of a PS1 file',
            ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('PSPath', 'Name')]
        [ValidateScript( { Test-Path $_ })]
        [ValidatePattern('\.ps(1|m1)$')]
        [String]$Path
    )

    Begin {
        #Begin scriptblock
        Write-Verbose -Message "Starting $($MyInvocation.MyCommand)"
        #initialization commands
        #explicitly define some AST variables
        New-Variable $AstTokens -Force
        New-Variable astErr -Force
    } #close begin

    Process {
        #Process scriptblock
        #convert each path to a nice filesystem path
        $Path = Convert-Path -Path $Path

        Write-Verbose -Message "Parsing $Path"
        #Parse the file
        $AST = [System.Management.Automation.Language.Parser]::ParseFile($Path, [ref]$AstTokens, [ref]$astErr)

        #filter tokens for comments and display text
        $AstTokens.where( { $_.kind -eq 'comment' }) |
        Select-Object -ExpandProperty Text
    } #close process

    End {
        Write-Verbose -Message "Ending $($MyInvocation.MyCommand)"
    } #close end

} #close function
