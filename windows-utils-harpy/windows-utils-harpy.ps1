

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

#################################### default conent for pages\websites.md ############################################################

$DefaultWebsites=@"
# Websites Built with `harpy`

Send an email to sartimo [at] gmail [dot] com if you would like me to add your harpy-generated website to this list.

- none yet :)
"@

#################################### default conent for posts\markdown-examples.md ############################################################

$DefaultWebsites=@"
# Websites Built with `harpy`

Send an email to sartimo [at] gmail [dot] com if you would like me to add your harpy-generated website to this list.

- none yet :)
"@

$DefaultPost=@"
# Markdown Examples in `harpy`

2023-01-05

This following was lifted from [https://github.com/karlb/smu](https://github.com/karlb/smu)

`smu` Syntax
============

smu was started as a rewrite of
[markdown](http://daringfireball.net/projects/markdown/) but became something
more lightweight and consistent. It differs from [CommonMark](https://commonmark.org/) in the following ways:

* No support for _reference style links_
* Stricter indentation rules for lists
* Lists don't end paragraphs by themselves (blank line needed)
* Horizontal rules (`<hr>`) must use `- - -` as syntax
* Code fences have stricter syntax

Patches that increase the CommonMark compatibility are welcome as long as they don't increase the code complexity significantly.

This project is a fork of the [original smu](https://github.com/gottox/smu) by
[Enno Boland (gottox)](https://eboland.de). The main differences to the
original smu are:

* Support for code fences
* Improved [CommonMark](https://commonmark.org/) compatibility. E.g.
  * Code blocks need four spaces indentation instead of three
  * Skip empty lines at end of code blocks
  * Ignore single spaces around code spans
  * Keep HTML comments in output
  * Improved spec compliance for lists
  * Nesting code block in blockquotes works
  * "Empty" lines in lists behave identically, no matter how much whitespace they contain
  * No backslash escapes in code blocks
  * Use first number as start number for ordered lists
* Added a simple test suite to check for compliance and avoid regressions

Inline patterns
---------------

There are several patterns you can use to highlight your text:

* Emphasis
  * Surround your text with `*` or `_` to get *emphasised* text:
    	This *is* cool.
    	This _is_ cool, too.
  * Surround your text with `**` or `__` to get **strong** text:
    	This **is** cool.
    	This __is__ cool, too.
  * Surround your text with `***` or `___` to get ***strong and emphasised*** text:
    	This ***is*** cool.
    	This ___is___ cool, too.
  * But this example won't work as expected:
    	***Hello** you*
    This is a wontfix bug because it would make the source too complex.
    Use this instead:
    	***Hello*** *you*

* inline Code

  You can produce inline code by surrounding it with backticks.

  	Use `rm -rf /` if you're a N00b.
  	Use ``rm -rf /`` if you're a N00b.
  	Use ```rm -rf /``` if you're a N00b.

  Double and triple backticks can be used if the code itself contains backticks.


Titles
------

Creating titles in smu is very easy. There are two different syntax styles. The
first is underlining with at least three characters:

	Heading
	=======
	
	Topic
	-----

This is very intuitive and self explaining. The resulting sourcecode looks like
this:

	<h1>Heading</h1>
	<h2>Topic</h2>

Use the following prefixes if you don't like underlining:

	# h1
	## h2
	### h3
	#### h4
	##### h5
	###### h6

Links
-----

The simplest way to define a link is with simple `<>`.

	<http://s01.de>

You can do the same for E-Mail addresses:

	<yourname@s01.de>

If you want to define a label for the url, you have to use a different syntax

	[smu - simple mark up](http://s01.de/~gottox/index.cgi/proj_smu)

The resulting HTML-Code

	<a href="http://s01.de/~gottox/index.cgi/proj_smu">smu - simple mark up</a></p>

Lists
-----

Defining lists is very straightforward:

	* Item 1
	* Item 2
	* Item 3

Result:

	<ul>
	<li>Item 1</li>
	<li>Item 2</li>
	<li>Item 3</li>
	</ul>

Defining ordered lists is also very easy:

	1. Item 1
	2. Item 2
	3. Item 3

Only the first number in a list is meaningful. All following list items are
continously counted. If you want a list starting at 2, you could write:

	2. Item 1
	2. Item 2
	2. Item 3

and get the following HTML which will render with the numbers 2, 3, 4:

	<ol start="2">
	<li>Item 1</li>
	<li>Item 2</li>
	<li>Item 3</li>
	</ol>

Code & Blockquote
-----------------

Use the `> ` as a line prefix for defining blockquotes. Blockquotes are
interpreted as well. This makes it possible to embed links, headings and even
other quotes into a quote:

	> Hello
	> This is a quote with a [link](http://s01.de/~gottox)

Result:
	<blockquote><p>
	Hello
	This is a quote with a <a href="http://s01.de/~gottox">link</a></p>
	</blockquote>


You can define a code block with a leading Tab or with __4__ leading spaces

		this.is(code)
	
	    this.is(code, too)

Result:
	<pre><code>this.is(code)</code></pre>
	<pre><code>this.is(code, too)
	</code></pre>

Please note that you can't use HTML or smu syntax in a code block.

Another way to write code blocks is to use code fences:

	```json
	{"some": "code"}
	```

This has two advantages:
* The optional language identifier will be turned into a `language-` class name
* You can keep the original indentation which helps when doing copy & paste

Tables
------

Tables can be generated with the following syntax:

	| Heading1 | Heading2 |
	| -------- | -------- |
	| Cell 1   | Cell2    |

Aligning the columns make the input nicer to read, but is not necessary to get
correct table output. You could just write

	| Heading1 | Heading2 |
	| --- | --- |
	| Cell 1 | Cell2 |

To align the content of table cells, use `|:--|` for left, `|--:|` for right
and `|:--:|` for centered alignment in the row which separates the header from
the table body.

	| Heading1 | Heading2 | Heading3 |
	| :------- | :------: | -------: |
	| Left     | Center   | Right    |

Other interesting stuff
-----------------------

* to insert a horizontal rule simple add `- - -` into an empty line:

  	Hello
  	- - -
  	Hello2

  Result:
  	<p>
  	Hello
  	<hr />
  	
  	Hello2</p>

* Any ASCII punctuation character may escaped by precedeing them with a
  backslash to avoid them being interpreted:

  	!"#$%&'()*+,-./:;<=>?@[]^_`{|}~\

* To force a linebreak simple add two spaces to the end of the line:

  	No linebreak
  	here.
  	But here is  
  	one.

embed HTML
----------

You can include arbitrary HTML code in your documents. The HTML will be
passed through to the resulting document without modification. This is a good
way to work around features that are missing in smu. If you don't want this
behaviour, use the `-n` flag when executing smu to stricly escape the HTML
tags.
"@

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

    New-Item -ItemType Directory -Path $Directory -Force

    # creating all default files
    New-Item -ItemType File -Path "$Directory\index.md"
    New-Item -ItemType File -Path "$Directory\header.html" 
    New-Item -ItemType File -Path "$Directory\footer.html" 

    # set default content for the files
    Set-Content "$Directory\index.md" $DefaultIndexMD
    Set-Content "$Directory\header.html" $DefaultHeader
    Set-Content "$Directory\footer.html" $DefaultFooter

    # create directories for content and assets
    New-Item -Path $Directory -Name "build" -ItemType "directory"
    New-Item -Path $Directory -Name "pages" -ItemType "directory"
    New-Item -Path $Directory -Name "posts" -ItemType "directory"
    New-Item -Path $Directory -Name "public" -ItemType "directory"
    New-Item -Path "$Directory\public" -Name "images" -ItemType "directory"

    # add content for pages and posts
    New-Item "$Directory\pages\about.md"
    Set-Content "$Directory\pages\about.md" $DefaultIndexMD

    New-Item "$Directory\pages\websites.md"
    Set-Content "$Directory\pages\websites.md" $DefaultWebsites

    New-item "$Directory\posts\markdown-examples.md"
    Set-Content "$Directory\posts\markdown-examples.md" $DefaultPost
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
