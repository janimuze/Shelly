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
    # FontAwesome Glyphs -------
    solid_user              = "`u{f007}";   # Common user icon.
    solid_user_tie          = "`u{f508}";   # Administrative user icon.
    solid_folder            = "`u{f07b}";   # Folder icon.
    solid_folder_open       = "`u{f07c}";   # Rolder open icon.
    solid_code_branch       = "`u{f126}";   # Code branch icon.
    solid_terminal          = "`u{f120}";   # Terminal icon.
    solid_point_right       = "`u{f0a4}";   # Hand pointing right.
    solid_point_left        = "`u{f0a5}";   # Hand pointing left.
    solid_computer          = "`u{e4e5}";   # Computer
    solid_exclamation       = "`u{f071}";   # Alert exclimation
    solid_arrow_right_left  = "`u{f0ec}";   # Double arrows right and left
    solid_arrow_right       = "`u{f061}";   # Single arrow right
    solid_arrow_left        = "`u{f060}";
    # Box icons ----------------
    box_left_top            = "`u{250c}";
    box_left_bottom         = "`u{2514}";
    box_line                = "`u{2500}";
    box_arrow_right         = "`u{27A4}";
    # Brand icons --------------
    brand_keybase           = "`u{f4f5}";
    brand_github            = "`u{f09b}";
    brand_microsoft         = "`u{f3ca}";
    brand_windows           = "`u{f17a}";
    brand_gitlab            = "`u{f296}";
    brand_gitkraken         = "`u{f3a6}";
    brand_bitbucket         = "`u{f171}";
    brand_digital_ocean     = "`u{f391}";
    brand_git_alt           = "`u{f841}";

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
    if ( $command = ( Get-Command "ls" -CommandType Application -ErrorAction SilentlyContinue ).Source )
    {
        &$command --color=auto $args;
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
    if ( $command = ( Get-Command "ls" -CommandType Application -ErrorAction SilentlyContinue ).Source )
    {
        &$command -la --color=auto $args;
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

# ---------------
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

    $glyph      = $Global:YuyoseiGlyphs.solid_user;
    $color      = [System.ConsoleColor]::White;
    $userName   = [System.Environment]::UserName;

    if (Test-Administrator)
    {
        $glyph      = $Global:YuyoseiGlyphs.solid_user_tie;
        $color      = [System.ConsoleColor]::Red;
    }

    Write-Host "$( $glyph ) " -NoNewline -ForegroundColor $color;
    Write-Host "$( $userName )";
}

# ---------------
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
        Write-Host "$( $Global:YuyoseiGlyphs.solid_point_right ) " -NoNewline -ForegroundColor White;
        Write-Host "$( $command.Source )";
    }
    else {
        Write-Host "$( $Global:YuyoseiGlyphs.solid_exclamation ) " -NoNewline -ForegroundColor Yellow;
        Write-Host "$( $commandName ): not found.";
    }
}

#endregion 

# ---------------
function prompt()
{
    <#
    .SYNOPSIS
    Displays the custom user prompt and updates the terminal/console window title.
    
    .NOTES
    Called automatically by Powershell.
    #>
    Update-ConsoleWindowTitleWithCurrentPath;   # Sync terminal title with current working directory.
    Update-GitProjectFolders;                   # Update git data if we are in a git project directory.
    Write-Host;                                 # Initial blank line.
    Write-CustomPromptTopLine;                  # Top line, user@computer, directory and git.
    Write-CustomPromptBottomLine                # Bottom line, arrow prompt. 
    return " ";
}

# ---------------
function Write-CustomPromptTopLine 
{
    <#
    .SYNOPSIS
    Writes the first (top) line of the custom shell prompt.
    #>
    Write-Host "$( $Global:YuyoseiGlyphs.box_left_top )" -NoNewline;    # Border of line top row.
    Write-CustomPropmtUserData -NoNewLine;                              # User@Computer prompt.
    Write-CustomPromptFilePathData -NoNewLine                           # Current directory prompt.
    Write-CustomPromptGitBranch;                                        # Git branch prompt.

}

# ---------------
function Write-CustomPromptBottomLine 
{
    <#
    .SYNOPSIS
    Writes the seccond (bottom) line of the custom shell prompt.
    #>
    Write-Host "$($Global:YuyoseiGlyphs.box_left_bottom )" -NoNewline;  # Border of line bottom row.
    Write-Host "$($Global:YuyoseiGlyphs.box_line )" -NoNewline;         # Line between border and arrow.
    Write-Host "$($Global:YuyoseiGlyphs.box_arrow_right )" -NoNewline;  # Arrow of prompt line.
}

# ---------------
function Write-CustomPropmtUserData 
{
    <#
    .SYNOPSIS
    Writes the custom prompts user data.
    
    .DESCRIPTION
    Mimics other POSIX-line shells: displays in the form of USER@HOST 
    format. The color of the prompt depends on id the user has 
    administrator / root permissions in the current session. If the user
    is elevated, it displays red with a tie glyph, otherwise it is
    green with a normal glyph.
    
    .PARAMETER NoNewLine
    SKips adding a new line after printing the prompt. 
    
    .EXAMPLE
    Write-CustomPropmtUserData -NoNewline
    
    .NOTES
    TODO: Add link to the Yuyosei/Shelly spec (once published).
    #>
    param(
        [Parameter(Mandatory=$false)]
        [switch] $NoNewLine,
        [Parameter(Mandatory=$false)]
        [switch] $OnlyUser
    );

    $glyph      = $Global:YuyoseiGlyphs.solid_user;
    $color      = [System.ConsoleColor]::DarkGreen;
    $userName   = [System.Environment]::UserName;
    $hostName   = [System.Environment]::MachineName.ToLower();

    # Change glyph and color if user is an admin / root.
    if ( Test-Administrator )
    {  
        $glyph  = $Global:YuyoseiGlyphs.solid_user_tie;
        $color  = [System.ConsoleColor]::DarkRed;

    }

    # Option to display only the username
    if ( $OnlyUser )
    {
        $display = "$( $glyph ) $( $userName )";
    }
    else
    {
        $display    = "$( $glyph ) $( $userName )@$( $hostName )";
    }

    Write-Host "$( $display ) " -NoNewline:$NoNewLine -ForegroundColor ( $color );
}

# ---------------
function Write-CustomPromptFilePathData 
{
    <#
    .SYNOPSIS
    Displays the directory name or path portion of the shell prompt.
    
    .DESCRIPTION
    Generally displays the path to the current working, but will
    shorten folders in the users "Home" directory with a tiddle 
    (~) as is the case with other POSIX-like shells.
    A special case is used for git projects where it'll also 
    shorten the path to just the project directory and it's sub
    directories. This makes more space to display the branch
    without breaking the line. 
    
    .EXAMPLE
    Write-CustomPromptFilePathData
    
    .NOTES
    TODO: Add link to the Yuyosei/Shelly spec (once published).
    #>
    param(
        [Parameter(Mandatory=$false)]
        [switch] $NoNewLine
    );

    $cwd         = (Get-Location).Path;
    $display_dir = $cwd.Replace($HOME, "~");
    $glyph       = $Global:YuyoseiGlyphs.solid_folder;
    $color       = [System.ConsoleColor]::Green;
    $is_user_dir = $cwd.StartsWith($HOME);

    # Set the color to be used as the directory prompt if not within
    # the or a subdirectory of the users HOME directory.
    #   - If the user is an administrator, mark the directory yellow
    #     to indicate a warning that they may not be in safe territory.
    #   - If the user is not an administrator, mark the directory red
    #     to indicate the user may need to elevate/su/sudo to work here.
    if ( -not $is_user_dir )
    {
        if ( Test-Administrator )
        {
            $color = [System.ConsoleColor]::Yellow;
        }
        else 
        {
            $color = [System.ConsoleColor]::Red;
        }
    }

    # Special scenario for git project directories. Shortens the path to
    # just the project directory but show inner path to ant sub directories
    # within the project (for navigation). Also change the glyps to hint
    # that it's an "opened" folder.
    if ( $Global:YuyoseiGitFolders.is_git_dir )
    {
        $cwd            = $Global:YuyoseiGitFolders.git_root_dir;
        $display_dir    = Format-Path "$( Split-Path $cwd -Leaf )";
        $glyph          = $Global:YuyoseiGlyphs.solid_folder_open;

        if ( $git_dir = $Global:YuyoseiGitFolders.git_relitave_dir )
        {
            $display_dir    = Format-Path "$( Split-Path $cwd -Leaf )/$git_dir";
        }
    }

    # Display the prompt.
    Write-Host "$( $glyph ) $( $display_dir ) " -NoNewline:$NoNewLine -ForegroundColor $color;
}

function Write-CustomPromptGitBranch 
{
    param(
        [Parameter(Mandatory=$false)]
        [switch] $NoNewLine
    );

    # $branch = $Global:YuyoseiGitFolders.git_branch;
    # Write-Host $(if (-not [string]::IsNullOrEmpty($branch)) { "$($Global:YuyoseiGlyphs.solid_code_branch) $($branch)"} else { "" } ) -NoNewline:$NoNewLine -ForegroundColor White;

    if ( $Global:YuyoseiGitFolders.is_git_dir )
    {
        if ( $Global:YuyoseiGitFolders.source_icon )
        {
            Write-Host "$( $Global:YuyoseiGitFolders.source_icon ) / " -ForegroundColor White -NoNewline;
        }
        Write-Host "$( $Global:YuyoseiGlyphs.solid_code_branch ) $( $Global:YuyoseiGitFolders.git_branch )" -ForegroundColor White -NoNewline:$NoNewLine;
    }
    elseif ( -not $NoNewLine ) {
        Write-Host;
    }
}

function Update-ConsoleWindowTitleWithCurrentPath 
{
    Set-Title $(Split-Path -leaf -path (Get-Location));
}

function Get-CustomDirectoryAliasPath 
{
    return (Get-Location).Path.Replace($HOME, "~");
    
}

function Get-CustomPromptUserColor
{
    return $( if(Test-Administrator) { [System.ConsoleColor]::DarkRed } else { [System.ConsoleColor]::DarkGreen } );
}

function Get-CustomPromptUserGlyph
{
    return $( if ( Test-Administrator ) { $Global:YuyoseiGlyphs.solid_user_tie } else {  $Global:YuyoseiGlyphs.solid_user } );
}

# ----------------------------------------------------------------------
#region Git project functions.

# ---------------
function Update-GitProjectFolders
{
    <#
    .SYNOPSIS
    Updates the global git directory information.
    
    .DESCRIPTION
    Gets the git branch, relitave directory and project directory and 
    updates the global with the data.
    
    .NOTES
    This function is used to get all relitave git information in one
    swoop to improve performance.
    #>
    Set-Variable -Scope global -Name YuyoseiGitFolders -Value @{ 
        git_branch          = "";
        git_relitave_dir    = "";
        git_root_dir        = "";
        is_git_dir          = $false;
        source_icon         = $null;
    }

    if (git rev-parse --git-dir 2> $null)
    {
        $Global:YuyoseiGitFolders.git_root_dir      = "$( git rev-parse --show-toplevel )";
        $Global:YuyoseiGitFolders.git_branch        = "$( git symbolic-ref --short HEAD )";
        $Global:YuyoseiGitFolders.git_relitave_dir  = "$( git rev-parse --show-prefix   )";
        $Global:YuyoseiGitFolders.is_git_dir        = $true;

        $uri = "$( git remote -v )".Split([System.Environment]::NewLine)[0];

        if ( $uri.Contains( "keybase:" ) )
        {
            $Global:YuyoseiGitFolders.source_icon = $Global:YuyoseiGlyphs.brand_keybase;
        }
        elseif ( $uri.Contains( "github.com" ) )
        {
            $Global:YuyoseiGitFolders.source_icon = $Global:YuyoseiGlyphs.brand_github;
        }
        elseif ( $uri.Contains( "azure.com" ) ) {
            $Global:YuyoseiGitFolders.source_icon = $Global:YuyoseiGlyphs.brand_windows;
        }
        else {
            $Global:YuyoseiGitFolders.source_icon = $Global:YuyoseiGlyphs.brand_git_alt;
        }
    }
}

#endregion

function Test-Administrator  
{  
    [OutputType([bool])]
    param()

    [Security.Principal.WindowsPrincipal]$user = [Security.Principal.WindowsIdentity]::GetCurrent();
    return $user.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator);
    
}

function Format-Path
{
    param(
        [Parameter()]
        [string] $path = $null
    );

    $path = $path.Replace("/", [IO.Path]::DirectorySeparatorChar).Replace("\", [IO.Path]::DirectorySeparatorChar);
    if ( $path.Substring( $path.Length - 1 ) -eq [IO.Path]::DirectorySeparatorChar )
    {
        $path = $path.TrimEnd( [IO.Path]::DirectorySeparatorChar );
    }

    $path;
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