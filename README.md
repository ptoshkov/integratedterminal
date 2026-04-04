# Integrated Terminal
![](integratedterminal/images/integratedTerminal.png)

VS Code-style integrated terminal for the MATLAB IDE.

## Getting Started Guide
1. Download and install the toolbox from the releases page (https://github.com/ptoshkov/integratedterminal/releases), the MATLAB Central (LINK TBD) or the Add-On Explorer inside the MATLAB IDE.
2. Click the APPS tab on the MATLAB Toolstrip.
3. Click the dropdown arrow to show all apps.
4. Click the Integrated Terminal app. An integrated terminal with the default profile will be opened.

## Tutorial
### Adding a Profile
Open a new terminal and right click anywhere on the terminal. Select "Edit Profile".

![](integratedterminal/images/contextMenu.png)

A file browser will open showing the contents of the profiles folder. Copy and paste *default.json*. Rename the new file to *custom.json*. Double click *custom.json*. The profile *custom.json* will be opened in the editor.

![](integratedterminal/images/customProfile.png)

Go back to the terminal. Right click and select "Open Profile". Double click *custom.json*. A new integrated terminal will be created with the profile *custom.json*.

### Changing the Shell
The shell that a profile uses is controlled by the key "Shell Path" in the profile JSON. Assuming you have the shell **magic.exe** installed at **C:/Magic/magic.exe**, you can make a profile use the shell by setting "Shell Path" to:

```
"Shell Path": "C:/Magic/magic.exe",
```

### Changing the Size
The size of the terminal is controlled by the "cols" and "rows" keys in the profile JSON:

```
"cols": 80,
"rows": 24,
```

### Changing the Font
You can set the key "fontFamily" to any CSS font family string. Refer to <https://www.w3.org/Style/Examples/007/fonts.en.html> for examples. To set the font to Times 8 pt. with fallback Times New Roman and last fallback serif family:

```
"fontFamily": "Times, Times New Roman, serif",
"fontSize": 8,
```

### Changing the Theme
The easiest way to change the color theme is to go to <https://glitchbone.github.io/vscode-base16-term/#/>, choose the theme you want and click "Copy to clipboard". Paste the theme in the "theme" key:

```
"theme": {
    "terminal.background":"#E3EFEF",
    "terminal.foreground":"#6D828E",
    "terminalCursor.background":"#6D828E",
    "terminalCursor.foreground":"#6D828E",
    "terminal.ansiBlack":"#E3EFEF",
    "terminal.ansiBlue":"#868CB3",
    "terminal.ansiBrightBlack":"#98AFB5",
    "terminal.ansiBrightBlue":"#868CB3",
    "terminal.ansiBrightCyan":"#86B3B3",
    "terminal.ansiBrightGreen":"#87B386",
    "terminal.ansiBrightMagenta":"#B386B2",
    "terminal.ansiBrightRed":"#B38686",
    "terminal.ansiBrightWhite":"#485867",
    "terminal.ansiBrightYellow":"#AAB386",
    "terminal.ansiCyan":"#86B3B3",
    "terminal.ansiGreen":"#87B386",
    "terminal.ansiMagenta":"#B386B2",
    "terminal.ansiRed":"#B38686",
    "terminal.ansiWhite":"#6D828E",
    "terminal.ansiYellow":"#AAB386"
},
```

Remove all occurences of `terminal.`. Replace all occurences of `terminalCursor.` with `cursor.`. The key should look like this in the end:

```
"theme": {
    "background":"#E3EFEF",
    "foreground":"#6D828E",
    "cursor.background":"#6D828E",
    "cursor.foreground":"#6D828E",
    "ansiBlack":"#E3EFEF",
    "ansiBlue":"#868CB3",
    "ansiBrightBlack":"#98AFB5",
    "ansiBrightBlue":"#868CB3",
    "ansiBrightCyan":"#86B3B3",
    "ansiBrightGreen":"#87B386",
    "ansiBrightMagenta":"#B386B2",
    "ansiBrightRed":"#B38686",
    "ansiBrightWhite":"#485867",
    "ansiBrightYellow":"#AAB386",
    "ansiCyan":"#86B3B3",
    "ansiGreen":"#87B386",
    "ansiMagenta":"#B386B2",
    "ansiRed":"#B38686",
    "ansiWhite":"#6D828E",
    "ansiYellow":"#AAB386"
},
```

Now this profile will have the Brushtrees theme:

![](integratedterminal/images/brushtrees.png)

### Changing the Behavior
### Adding a Shortcut
### Changing the Default Profile
Whichever profile is named *default.json* will be used as the default profile.

### Resetting the Default Profile
Delete *default.json* to reset the default profile to factory settings.

## Build From Source
In order to build `Integrated Terminal` from source the following prerequisites need to be installed and on the path:
- MATLAB R2023a or later (https://www.mathworks.com/products/matlab.html)
- Node.js with npm (https://nodejs.org/en)
- pkg (https://github.com/vercel/pkg)
- GNU Make
- Pandoc (https://pandoc.org)
- WeasyPrint (https://weasyprint.org)
- Bash (on Windows you can use Git Bash or MSYS2)

Clone the repo and run **build.sh**. The toolbox installer will be located in the folder *build/*.

## FAQ
### What operating systems are supported?
Windows, macOS and Linux.

### Does the toolbox work in MATLAB Online?
Yes, the MATLAB Online servers use Ubuntu so you can install the terminal.

Upload the installer to your MATLAB Drive, run it and when it says *100%* click the `x` to stop the installation. The terminal will still be installed correctly.

![](integratedterminal/images/online.png)
