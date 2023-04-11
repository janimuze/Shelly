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

# Set the glyphs used to create charecters in various prompts.
# NOTE: The codes defined here imply the use of FontAwesome v6.x and
#       assume that the font set is installed on the local system. To
#       use a different font/charecters (or no charecters), change 
#       the string value here. FontAwesome available at 
#       https://fontawesome.com
Set-Variable -Scope global -Option ReadOnly -Name YuyoseiGlyphs -Value @{
    solid_user          = "`u{f007}";       # Common user icon.
    solid_user_tie      = "`u{f508}";       # Administrative user icon.
    solid_folder        = "`u{f07b}";       # Folder icon.
    solid_code_branch   = "`u{f126}";       # Code branch icon.
    solid_terminal      = "`u{f120}";       # Terminal icon.
    solid_point_right   = "`u{f0a4}";       # Hand pointing right.
    solid_point_left    = "`u{f0a5}";       # Hand pointing left.
    solid_computer      = "`u{e4e5}";

    # TODO: Add more icons...?
};

#endregion

# ----------------------------------------------------------------------
#region General aliases/function replacements

# ---------------
Remove-Alias -Name ls;
function ls 
{
    <#
        .SYNOPSIS
        List directory information in horisontal view with color and hidden 
        files displayed.

        For more details, type ls --help.
        .DESCRIPTION
        Wrapper for the 'ls' command.
    #>

    if (Test-CommandExeExists "ls")
    {
        & ls.exe -a --color=auto $args;
    }
    else {
        Get-ChildItem $args;
    }
}

# ---------------
function  ll 
{
    <#
        .SYNOPSIS
        List directory information in long (vertical) view with color and hidden 
        files displayed.

        For more details, type ls --help.
        .DESCRIPTION
        Wrapper for the 'ls' command.
    #>
    if (Test-CommandExeExists "ls")
    {
        & ls.exe -la --color=auto $args;
    }
    else {
        Get-ChildItem $args;
    }
}

# ---------------
Remove-Alias -Name pwd;
 function pwd 
{
    <#
    .SYNOPSIS
    Print the full filename of the current working directory. 
    
    .DESCRIPTION
    NOTE: This version is a custom function provided by the Yuyosei custom
    powershell profile script.
    
    .EXAMPLE
    See issue #0000129 for details about examples.
    
    .NOTES
    This version of the function is incomplete. See issue #0000128 for details.
    #>
    Write-Host "$( $Global:YuyoseiGlyphs.solid_folder ) $( (Get-Location).Path )";
}


function whoami
{
    <#
    .SYNOPSIS
    Shows the current user name, system name shell version.
    
    .DESCRIPTION
    NOTE: This version is a custom function provided by the Yuyosei custom
    powershell profile script.
    
    .EXAMPLE
    See issue #0000129 for details about examples.
    #>
    Write-Host "$( Get-CustomPromptUserGlyph ) $( $env:USERNAME )" -ForegroundColor (Get-CustomPromptUserColor) -NoNewline;
    Write-Host "$( if ( Test-Administrator ) { " (administrator)" })" -ForegroundColor (Get-CustomPromptUserColor) -NoNewline;
    Write-Host " on $($Global:YuyoseiGlyphs.solid_computer)$( $env:COMPUTERNAME.ToLower() )" -NoNewline;
    Write-Host " using $($Global:YuyoseiGlyphs.solid_terminal) PowerShell $( $PSVersionTable.PSEdition ) version" -NoNewline;
    Write-Host " $( $PSVersionTable.PSVersion.Major )" -NoNewline;
    Write-Host ".$( $PSVersionTable.PSVersion.Minor )" -NoNewline;
    Write-Host ".$( $PSVersionTable.PSVersion.Patch )" -NoNewline;
    Write-Host " $( $PSVersionTable.PSVersion.PreReleaseLabel )" -NoNewline;
    Write-Host " $( $PSVersionTable.PSVersion.BuildLabel )" -NoNewline;
}

function whereis
{
    <#
    .SYNOPSIS
    Gets the location of a command executable.
    
    .DESCRIPTION
    Gets the location of a command executable. Does not (currently) include script 
    functions, aliases or scripts. Only executables are shown.
    
    .PARAMETER commandName
    The command to search for.
    
    .EXAMPLE
    whareis ssh
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string] $commandName
    );

    if ( $command = Get-Command -Name $commandName -CommandType Application -ErrorAction SilentlyContinue )
    {
        Write-Host "$( $Global:YuyoseiGlyphs.solid_point_right ) $( $command.Source )";
    }
    else {
        Write-Host "`"$commandName`" not found.";
    }
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
    Write-Host "`u{27A4}" -NoNewline;
    return " ";
}

function Write-CustomPropmtUserData 
{
    Write-Host "$( Get-CustomPromptUserGlyph ) $( $env:USERNAME )@$( $env:COMPUTERNAME.ToLower() ) " `
        -NoNewline -ForegroundColor (Get-CustomPromptUserColor);
}

function Write-CustomPromptFilePathData 
{
    
    Write-Host "$( $Global:YuyoseiGlyphs.solid_folder ) $(Split-Path -leaf -path (Get-Location)) " `
        -NoNewline -ForegroundColor (Get-CustomPromptPathColor);
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

function Get-CustomPromptUserGlyph
{
    return $( if ( Test-Administrator ) { $Global:YuyoseiGlyphs.solid_user_tie } else {  $Global:YuyoseiGlyphs.solid_user } );
}

function Get-CustomPromptPathColor
{
    if ( ( Get-Location ).Path.StartsWith( $HOME ) )
    {
        # Use GREEN for all paths within the users home directory.
        return [System.ConsoleColor]::Green;
    }
    else 
    {
        if ( Test-Administrator )
        {
            # If we are ADMIN/ROOT, use yellow as a warning, indicating the folder content
            # CAN be modified but we're outside the comfort zone of the HOME folder...
            return [System.ConsoleColor]::Yellow;
        }
        else 
        {
            # If we are NOT ADMIN/ROOT, use red to indicate that we might need to elevate
            # or sudo to be able to modify the content here.
            [System.ConsoleColor]::Red;
        }
    }
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

    [Security.Principal.WindowsPrincipal]$user = [Security.Principal.WindowsIdentity]::GetCurrent();
    return $user.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator);
    
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

function Test-CommandExeExists 
{
    [OutputType([bool])]
    param (
        
        [Parameter(Mandatory=$true)]
        [string] $commandName
    );
    return [bool](Get-Command $commandName -CommandType Application -ErrorAction SilentlyContinue);
}

function Test-IsConEmuTerminal 
{
    [OutputType([bool])]
    param ()

    if ( $global:IsWindows )
    {
        if ( ( Test-CommandExeExists "ConEmuC64" ) -and ( [System.Environment]::Is64BitProcess ) )
        {
            $macroCommand = "ConEmuC64";
        }
        elseif ( Test-CommandExeExists "ConEmuC" )
        {
            $macroCommand = "ConEmuC";
        }

        if ( -not [string]::IsNullOrEmpty( $macroCommand ) )
        {
            & $macroCommand /GuiMacro IsConEmu >> $null;

            if ( 0 -eq $LASTEXITCODE )
            {
                return $true;
            }
        }
    }

    return $false;
}