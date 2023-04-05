# This is free and unencumbered software released into the public domain.

# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.

# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

# For more information, please refer to <https://unlicense.org>

# ----------------------------------------------------------------------
#region Readline (clink), colors and general shell options 

# Set the powershell readline behaviour to be more like bash.
Set-PSReadLineKeyHandler -Key Tab -Function Complete;

#endregion

# ----------------------------------------------------------------------
#region General aliases  


# Remove powershell pre-defined aliases that override our cyg commands.
Remove-Alias -Name ls;

<#
.SYNOPSIS
List information about files in horisontal view with color and hidden 
files displayed.
#>
function ls 
{
    & ls.exe -a --color=auto $args;
}

function  ll 
{
    & ls.exe -la --color=auto $args;
}

#endregion 

# Main prompt function.
function prompt()
{
    Update-ConsoleWindowTitleWithCurrentPath
    Write-Host;
    Write-Host "`u{250c}" -NoNewline;
    Write-CustomPropmtUserData;
    Write-CustomPromptFilePathData;
    Write-CustomPromptGitBranch;
    Write-Host " ";
    Write-Host "`u{2514}`u{2500}" -NoNewline;
    Write-Host "PS`u{27A4}" -NoNewline;
    return " ";
}

function Write-CustomPropmtUserData {
    Write-Host "`u{f007} $env:USERNAME@$env:COMPUTERNAME " -NoNewline -ForegroundColor (Get-CustomPromptUserColor);
}

function Write-CustomPromptFilePathData {
    Write-Host "`u{f07b} $(Split-Path -leaf -path (Get-Location)) " -NoNewline -ForegroundColor (Get-CustomPromptPathColor);
}

function Write-CustomPromptGitBranch {
    Write-Host "$(Get-GitBranch)" -NoNewline -ForegroundColor White;
}

function Update-ConsoleWindowTitleWithCurrentPath {
    Set-Title $(Split-Path -leaf -path (Get-Location));
}

function Get-CustomPromptUserColor
{
    return $( if(Test-Administrator) { [System.ConsoleColor]::DarkRed } else { [System.ConsoleColor]::DarkGreen } );
}

function Get-CustomPromptPathColor
{
    return $( if(Test-Administrator) { [System.ConsoleColor]::Red } else { [System.ConsoleColor]::Green } )
}

function Get-GitBranch 
{
    $isGitFolder = (git rev-parse --git-dir 2> $null);
    $currentBranch = "";

    if($isGitFolder)
    {
        $currentBranch = "`u{f126} $(git symbolic-ref --short HEAD)";
    }
    return $currentBranch;
}

function Test-Administrator  
{  
    [OutputType([bool])]
    param()
    process 
    {
        [Security.Principal.WindowsPrincipal]$user = [Security.Principal.WindowsIdentity]::GetCurrent();
        return $user.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator);
    }
}

function Set-Title
{
    param(
        [Parameter()]
        [string] $title = $null
    );

    if (-not [string]::IsNullOrEmpty($title))
    {
        $host.ui.RawUI.WindowTitle = $title;
    }

}

function Test-YuyoseiFileExistsInPaths
{
    [OutputType([bool])]
    param(
        [Parameter(Mandatory = $true)]
        [string] $file
    );

    process 
    {
        $env:Path -split ";" | ForEach-Object -Process
        {

        }

    }

}