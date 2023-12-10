<#
.SYNOPSIS
An example of how to next commands.

.DESCRIPTION
USAGE
    .\4-nest.ps1 <command>

COMMANDS
    speak       speak some text
    logs        view logs
#>

#################################### app parameters ############################################################
param(
    [Parameter(Position=0)]
    [ValidateSet("init", "build", "serve")]
    [string]$Command,

    [Parameter(Position=1, ValueFromRemainingArguments=$true)]
    $Rest
)

if (!$Command) {
    Get-Help $PSCommandPath
    exit
}

################################### function for initializing data structure ##################################
function Command-Init {
    param (
        [Parameter(Position=0, Mandatory=$True)]
        [string]$Directory
    )


    Write-Host "initializing Harpy structure at: $Directory"

    if (!$Directory) {
        Write-Host "initializing Harpy structure in current path"
    }
}

################################## function for building static site ##########################################
function Command-Build {
    Write-Host "Building static site at .\build\*"
}

################################## function for serving static site locally ##################################
function Command-Serve {
    Write-Host "Serving site at http://localhost:8000"
}

################################## argument assignment #######################################################
switch ($Command) {
    "init" { Command-Init $Rest }
    "build" { Command-Build $Rest }
    "serve" { Command-Serve $Rest}
}
