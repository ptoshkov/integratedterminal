# Integrated Terminal
![](integratedterminal/images/integratedTerminal.png)

VS Code-style integrated terminal for the MATLAB IDE.

## Getting Started Guide
1. Download and install the toolbox from the releases page (LINK TBD), the MATLAB Central (LINK TBD) or the Add-On Explorer inside the MATLAB IDE.
2. Click the APPS tab on the MATLAB Toolstrip.
3. Click the dropdown arrow to show all apps.
4. Click the Integrated Terminal app. An integrated terminal with the default profile will be opened.

## Tutorial
### Adding a Profile
Open a new terminal and right click anywhere on the terminal. Select "Edit Profile". A file browser will open showing the contents of the profiles folder.

Copy and paste *default.json*. Rename the new file to *custom.json*. Double click *custom.json*. The profile *custom.json* will be opened in the editor.

Go back to the terminal. Right click and select "Open Profile". Double click *custom.json*. A new integrated terminal will be created with the profile *custom.json*.

### Changing the Shell
### Changing the Size
### Changing the Font
### Changing the Theme
### Changing the Behavior
### Adding a Shortcut
### Changing the Default Profile
### Resetting the Default Profile

## Build From Source
In order to build `Integrated Terminal` from source the following prerequisites need to be installed and on the path:
- MATLAB R2023a or later (https://www.mathworks.com/products/matlab.html)
- Node.js with npm (https://nodejs.org/en)
- ncc (https://github.com/vercel/ncc)
- pkg (https://github.com/vercel/pkg)
- Pandoc (https://pandoc.org)
- WeasyPrint (https://weasyprint.org)
- Bash (on Windows you can use Git Bash or MSYS2)

Clone the repo and run build.sh. The toolbox installer will be located in the folder *build/*.

## FAQ
