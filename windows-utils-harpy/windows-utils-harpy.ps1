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
#################################### default content for index.md ############################################################
$DefaultIndexMD=@"
# harpy

**harpy is an extremely minimal static-site generator for powershell.**

**harpy** = blogs are really fun

---

### Articles
"@
#################################### default content for header.html ############################################################
$DefaultHeader=@"
<!doctype html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="icon" href="data:,">
	<title>{{TITLE}}</title>
	<link href="/atom.xml" type="application/atom+xml" rel="alternate" title="Atom feed for blog posts" />
	<style>*{box-sizing:border-box;}body{font-family:sans-serif;margin:0 auto;max-width:650px;padding:1rem;}img{max-width:100%;}pre{overflow:auto;}</style>
</head>

<nav>
	<a href="#menu">Menu &darr;</a>
</nav>

<main>
"@

#################################### default content for footer.html ############################################################
$DefaultFooter=@"
<footer role="contentinfo">
    <hr>
    <h3 id="menu">Menu Navigation</h3>
    <ul>
        <li><a href="/">Home</a></li>
        <li><a href="/about">About</a></li>
        <li><a href="/websites">Websites</a></li>
        <li><a href="https://github.com/sartimo/windows-utils/blob/main/windows-utils-harpy/windows-utils-harpy.ps1">Source Code</a></li>
    </ul>
    <small>
        Built with <a href="https://github.com/sartimo/windows-utils/blob/main/windows-utils-harpy/windows-utils-harpy.ps1">harpy</a>. <br>
        The <a href="https://github.com/sartimo/windows-utils/tree/main/windows-utils-harpy">code for this site</a> is MIT.
    </small>
</footer>
"@


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
