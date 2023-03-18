#NoEnv
WinWaitClose, BeeShop
RunWait, 7za.exe x -aoa "release.zip" -o"%A_WorkingDir%",,hide
FileDelete, release.zip
FileDelete, 7za.exe
MsgBox, 0,beeShop - Update, beeShop was successfully updated.
Run, beeShop.exe