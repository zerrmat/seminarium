# seminarium

# Useful links:
## .gitignore:
- Ignoring a previously committed file: https://www.atlassian.com/git/tutorials/saving-changes/gitignore

# Useful info:
## CC65 / CA65:
### Generate \*.dbg files
- Add -g flag to ca65.exe
- Add --dbgfile {name} flag to ld65.exe; {name} preferably should be the same as ROM name but with the \*.dbg extension, to use Mesen's auto-import labels feature. Otherwise it is necessary to import labels manually by opening debugger window, File -> Workspace -> Import labels


# Region compatibility idea for calculations:
- each frame in main loop should check for "compensation" frame (PAL & Dendy) - then code should execute main loop two times
