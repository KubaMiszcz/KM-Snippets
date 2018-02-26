# Some Snippets for VS Code
** current version: 0.0.143**
<!-- ![VS Code Marketplace](http://vsmarketplacebadge.apphb.com/version-short/HookyQR.beautify.svg) -->
<!-- publish-> vsce publish -->

This extension for Visual Studio Code adds snippets for Angular for TypeScript and HTML.

## Usage

Type part of a snippet, press `enter`, and the snippet unfolds.

### TypeScript Angular Snippets

| Snippet                      | Purpose                    |
|------------------------------|----------------------------|
| `km-log`                     | Log selected textmark to console |
| `km-log-this-variable`       | Log selected textmark and output to console |
| `km-log-json-this-variable`  | Log selected textmark and stringified output to console |
| `km-if`                      | If statement |
| `km-if-else`                 | If else statement |
| `km-output`                  | property with @Output decorator|
| `km-input`                   | property with @Input decorator|
| `km-event-emitter`           | property EventEmitter with handling function|
| `km-emit-event-value`        | Function emits eventload|

### HTML Snippets

| Snippet                      | Purpose                             |
|------------------------------|-------------------------------------|
| `km-routerLink`              | just `[routerLink]` with path and param template|
| `km-click-event`             | click event in source HTML|
| `km-handle-event`            | handle event in target HTML|


Alternatively, press `Ctrl`+`Space` (Windows, Linux) or `Cmd`+`Space` (OSX) to activate snippets from within the editor.

## Installation

1. Install Visual Studio Code 1.10.0 or higher
1. Launch Code
1. From the command palette `Ctrl`-`Shift`-`P` (Windows, Linux) or `Cmd`-`Shift`-`P` (OSX)
1. Select `Install Extension`
1. Choose the extension
1. Reload Visual Studio Code