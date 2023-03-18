#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance,Force
Menu,TRAY,NoIcon

/*
Include Libs and Startup
*/

#Include libs\JSON.ahk
#Include libs\DownloadFile.ahk
#Include libs\ListBoxAdjustHSB.ahk
#Include libs\7Zip.ahk
#Include libs\Update.ahk

if(FileExist("update.exe")) {
    FileDelete, update.exe
}

if(!FileExist("settings.ini")) {
    FileAppend, [Settings]`nip=`nauto_update=0`nlanguage=1`ndb=`ninstall_method=1`nauto_install=0`nshow_ci=0`n`n[CiConfig]`ndrive_letter=`nmovable_path=`nboot9_path=`nseeddb_path=, settings.ini
}

CurrentRelease := 1.2

; read settings ini
IniRead, Ip, settings.ini, Settings, ip
IniRead, AutoUpdateIni, settings.ini, Settings, auto_update
IniRead, LanguageIni, settings.ini, Settings, language
IniRead, DatabaseIni, settings.ini, Settings, db
IniRead, InstallMethodIni, settings.ini, Settings, install_method
IniRead, AutoInstallIni, settings.ini, Settings, auto_install
IniRead, ShowCiIni, settings.ini, Settings, show_ci

; read ciconfig ini
IniRead, DriveLetter, settings.ini, CiConfig, drive_letter
IniRead, MovablePath, settings.ini, CiConfig, movable_path
IniRead, Boot9Path, settings.ini, CiConfig, boot9_path
IniRead, SeedDbPath, settings.ini, CiConfig, seeddb_path

;read configured language from ini
IniRead, txtDbMissing, languages.ini, %LanguageIni%, txtDbMissing
IniRead, txtBtnDownload, languages.ini, %LanguageIni%, txtBtnDownload
IniRead, txtBtnSettings, languages.ini, %LanguageIni%, txtBtnSettings
IniRead, txtStatus, languages.ini, %LanguageIni%, txtStatus
IniRead, txtDb, languages.ini, %LanguageIni%, txtDb
IniRead, txtSpeed, languages.ini, %LanguageIni%, txtSpeed
IniRead, txtSettings, languages.ini, %LanguageIni%, txtSettings
IniRead, txtLanguage, languages.ini, %LanguageIni%, txtLanguage
IniRead, txtSave, languages.ini, %LanguageIni%, txtSave
IniRead, txtCfu, languages.ini, %LanguageIni%, txtCfu
IniRead, txtUpdate, languages.ini, %LanguageIni%, txtUpdate
IniRead, txtAutoUpdate, languages.ini, %LanguageIni%, txtAutoUpdate
IniRead, txtCfuMsg, languages.ini, %LanguageIni%, txtCfuMsg
IniRead, txtUpdateFound, languages.ini, %LanguageIni%, txtUpdateFound
IniRead, txtNoUpdateFound, languages.ini, %LanguageIni%, txtNoUpdateFound
IniRead, txtNoGame, languages.ini, %LanguageIni%, txtNoGame
IniRead, txtDownloading, languages.ini, %LanguageIni%, txtDownloading
IniRead, txtInstalling, languages.ini, %LanguageIni%, txtInstalling
IniRead, txtIpNotConfigured, languages.ini, %LanguageIni%, txtIpNotConfigured
IniRead, txtSelectGame, languages.ini, %LanguageIni%, txtSelectGame
IniRead, txtIdle, languages.ini, %LanguageIni%, txtIdle
IniRead, txtRestart, languages.ini, %LanguageIni%, txtRestart
IniRead, txtAskRestart, languages.ini, %LanguageIni%, txtAskRestart
IniRead, txtFileSelect, languages.ini, %LanguageIni%, txtFileSelect
IniRead, txtSelect, languages.ini, %LanguageIni%, txtSelect
IniRead, txtClickText, languages.ini, %LanguageIni%, txtClickText
IniRead, txtSearch, languages.ini, %LanguageIni%, txtSearch
IniRead, txtProgress, languages.ini, %LanguageIni%, txtProgress
IniRead, txtBtnShowLink, languages.ini, %LanguageIni%, txtBtnShowLink
IniRead, txtLink, languages.ini, %LanguageIni%, txtLink
IniRead, txtSelInstallMethod, languages.ini, %LanguageIni%, txtSelInstallMethod
IniRead, txtDownloadOn3DS, languages.ini, %LanguageIni%, txtDownloadOn3DS
IniRead, txtDownloadOnPC, languages.ini, %LanguageIni%, txtDownloadOnPC
IniRead, txtConfigCustomInstall, languages.ini, %LanguageIni%, txtConfigCustomInstall
IniRead, txtFileNotSpecified, languages.ini, %LanguageIni%, txtFileNotSpecified
IniRead, txtInstall, languages.ini, %LanguageIni%, txtInstall
IniRead, txtCiWarning, languages.ini, %LanguageIni%, txtCiWarning
IniRead, txtSuccessDownload, languages.ini, %LanguageIni%, txtSuccessDownload
IniRead, txtInvalidSettings, languages.ini, %LanguageIni%, txtInvalidSettings
IniRead, txtNoAdmin, languages.ini, %LanguageIni%, txtNoAdmin
IniRead, txtNoSpecifyMvblNoExist, languages.ini, %LanguageIni%, txtNoSpecifyMvblNoExist
IniRead, txtNoSpecifyB9NoExist, languages.ini, %LanguageIni%, txtNoSpecifyB9NoExist
IniRead, txtNoSpecifySdbNoExist, languages.ini, %LanguageIni%, txtNoSpecifySdbNoExist
IniRead, txtNotCia, languages.ini, %LanguageIni%, txtNotCia
IniRead, txtDriveLetterInvalidOrNotExist, languages.ini, %LanguageIni%, txtDriveLetterInvalidOrNotExist
IniRead, txtAutoInstall, languages.ini, %LanguageIni%, txtAutoInstall
IniRead, txtShowCiCliWindow, languages.ini, %LanguageIni%, txtShowCiCliWindow
IniRead, txtMovableInvalid, languages.ini, %LanguageIni%, txtMovableInvalid
IniRead, txtB9Invalid, languages.ini, %LanguageIni%, txtB9Invalid
IniRead, txtSdbInvalid, languages.ini, %LanguageIni%, txtSdbInvalid
IniRead, txtInvalidDriveLetterFormat, languages.ini, %LanguageIni%, txtInvalidDriveLetterFormat
IniRead, txtDriveLetter, languages.ini, %LanguageIni%, txtDriveLetter
IniRead, txtInvalidDb, languages.ini, %LanguageIni%, txtInvalidDb

; read db and ciconfig paths / names
SplitPath, DatabaseIni, DbFileName,,,,
if (StrLen(DbFileName) > 11) {
    DbFileName := SubStr(DbFileName, 1, 9) . "..."
}

SplitPath, MovablePath, MovableName,,,,
if (StrLen(MovableName) > 11) {
    MovableName := SubStr(MovableName, 1, 9) . "..."
}

SplitPath, Boot9Path, Boot9Name,,,,
if (StrLen(Boot9Name) > 11) {
    Boot9Name := SubStr(Boot9Name, 1, 9) . "..."
}

SplitPath, SeedDbPath, SeedDbName,,,,
if (StrLen(SeedDbName) > 11) {
    SeedDbName := SubStr(SeedDbName, 1, 9) . "..."
}

/*
Functions
*/

EnableGui() {
    GuiControl, 1:Enable, BtnSettings
    GuiControl, 1:Enable, BtnInstall
    GuiControl, 1:Enable, GameList
    GuiControl, 1:Enable, Search

    IniRead, InstallMethodIni, settings.ini, Settings, install_method
    if (SelInstallMethod = 1) 
    {
        GuiControl, 1:Disable, BtnDownload
        GuiControl, 1:Disable, BtnShowLink
    } 
    else if (InstallMethodIni = 2) 
    {
        GuiControl, 1:Enable, BtnDownload
        GuiControl, 1:Enable, BtnShowLink
    }
    else 
    {
        GuiControl, 1:Disable, BtnDownload
        GuiControl, 1:Disable, BtnShowLink
    }
}

DisableGui() {
    GuiControl, 1:Disable, BtnSettings
    GuiControl, 1:Disable, BtnInstall
    GuiControl, 1:Disable, GameList
    GuiControl, 1:Disable, Search
    GuiControl, 1:Disable, BtnDownload
    GuiControl, 1:Disable, BtnShowLink
}

DisableGuiNoDb(text)
{
    GuiControl,, GameList, %text%
    GuiControl, 1:Disable, BtnDownload
    GuiControl, 1:Disable, BtnShowLink
    GuiControl, 1:Disable, Search
}

ShowFileExist(path, doesNotExistMessage) 
{
    if (!FileExist(path))
    {
        MsgBox, 0, beeShop, %txtFileNotSpecified%
    }
    else 
    {
        MsgBox, 0, beeShop, %path%
    }
}

/*
Main GUI Window
*/

Menu, tray, Icon , assets/icon.ico, 1, 1
Gui, 1:New,,beeShop
Gui, Add, Pic, x10 y10 vImg, assets\bee.png

; labels
Gui, Add, Text, x303 y18 w167 cFFFFFF vSpeedGui, %txtSpeed% N/A
Gui, Add, Text, w230 cFFFFFF vStatus, %txtStatus% %txtIdle%
Gui, Add, Text, cFFFFFF w230 vDatabase, %txtDb% %DbFileName%

; game list
Gui, Add, ListBox, x10 y119 w283 h290 vGameList hwndGameList +HScroll
ListBoxAdjustHSB("GameList")

; search
Gui, Add, Text, cFFFFFF x303 y100, %txtSearch%
Gui, Add, Edit, x303 y120 w127 vSearch

; buttons
Gui, Add, Button, x303 y151 w127 h30 vBtnDownload gDownload, %txtBtnDownload%
Gui, Add, Button, x303 y191 w127 h30 vBtnInstall gInstall, %txtInstall%
Gui, Add, Button, x303 y231 w127 h30 vBtnShowLink gShowLink, %txtBtnShowLink%
Gui, Add, Button, x303 y271 w127 h30 vBtnSettings gSettings, %txtBtnSettings%

; progress bar
Gui, Add, Text, cFFFFFF x303 y359, %txtProgress%
Gui, Add, Progress, x303 y379 w127 h30 vProgress cffda30, 0

Gui 1:-MaximizeBox
Gui, Color, 333e40
Gui, Show, w440 h419, BeeShop

if (FileExist(DatabaseIni)) {
    FileRead, games, %DatabaseIni%
    Sort, games
    games := StrSplit(games, "`n") 
    DbExists := 1
} 
else 
{
    DbExists := 0
}

EnableGui()

if (DbExists != 1) 
{
    DisableGuiNoDb(txtDbMissing)
}


if (InstallMethodIni = 3) 
{
    Msgbox, 0, beeShop, %txtCiWarning%
}

Loop, % games.MaxIndex()
{
    game := games[A_Index]
    game := StrSplit(game, ",")
    GuiControl,, GameList, % game[1]
}

GuiControl,, Img, assets\bee2.png

if (AutoUpdateIni = 1) {
    Goto, CheckForUpdates
}
return

Download:
Gui, Submit, NoHide

if (GameList = "") 
{
    MsgBox, 0, beeShop - Error, %txtNoGame%
} 
else
{
    IniRead, AutoInstallIni, settings.ini, Settings, AutoInstallIni
    GuiControl, Text, Status, %txtStatus% %txtDownloading%
    Loop, % games.MaxIndex()
    {
        game := games[A_Index]
        game := StrSplit(game, ",")
        If (game[1] = GameList) {
            DownloadFile(game[2], GameList . ".cia")
            GameName := GameList . ".cia"
            GuiControl,, Progress,  0
            GuiControl,, SpeedGui, %txtSpeed% N/A
            Sleep, 100
            GuiControl, Text, Status, %txtStatus% %txtIdle%
            Msgbox, 0, beeShop, "%GameName%" %txtSuccessDownload% 
            break
        }
    }
    if (AutoInstallIni = 1) 
    {
        Goto, Install
    }
    else 
    {
        EnableGui()
    }
}
return

ShowLink:
Gui, Submit, NoHide

if (GameList = "") {
    MsgBox, 0, beeShop - Error, %txtNoGame%
    if (DbExists != 1) 
    {
        DisableGuiNoDb(txtDbMissing)
    }
    
}
else {
    Loop, % games.MaxIndex()
    {
        game := games[A_Index]
        game := StrSplit(game, ",") 

        If (game[1] = GameList) {
            stuff := game[2]
            Gui, ShowLink:New,, %txtBtnShowLink%
            Gui, ShowLink:+LastFoundExist
            Gui, Color, 333e40
            Gui, Add, Text, x10 y10 cFFFFFF, %txtLink%
            Gui, Add, Edit, x10 y30 w230 h60, %stuff%
            Gui, Show, h100 w250,, %txtBtnShowLink%
        }
    }  
}
return

Install:
DisableGui()
if (InstallMethodIni = 1) {
    Goto, SendUrls
}
else if (InstallMethodIni = 2)
{
    Goto, Servefiles
}
else if (InstallMethodIni = 3) 
{
    Goto, CustomInstall
}
else {
    MsgBox, 0, beeShop, %txtInvalidSettings%
    EnableGui()
    if (DbExists != 1) 
    {
        DisableGuiNoDb(txtDbMissing)
    }
}
return

SendUrls:
    Gui, Submit, NoHide
    if (GameList = "") 
    {
        MsgBox, 0, beeShop - Error, %txtNoGame%
        EnableGui()
        if (DbExists != 1) 
        {
            DisableGuiNoDb(txtDbMissing)
        }
    }
    else
    {
        if (Ip != "") 
        {
            GuiControl,, Progress,  100
            GuiControl, Text, Status,  %txtStatus% %txtInstalling%

            Loop, % games.MaxIndex()
            {
                game := games[A_Index]
                game := StrSplit(game, ",")

                if (game[1] = GameList) {
                    gotUrl := game[2]
                }
            }

            StringTrimRight, currentUrl, gotUrl, 1
            RunWait, tools\serve.exe 2 "%Ip%" "%currentUrl%",, Hide
            GuiControl,, Progress, Progress,  0
            GuiControl, Text, Status,  %txtStatus% %txtIdle%
            EnableGui()
        }
        else 
        {
            MsgBox, 0, beeShop - Error, %txtIpNotConfigured%
            EnableGui()
            if (DbExists != 1) 
            {
                DisableGuiNoDb(txtDbMissing)
            }
        }
    }
return

Servefiles:
    if (GameName != "") {
        if FileExist(GameName) {
            if (Ip != "") {
                GuiControl,, Progress,  100
                GuiControl, Text, Status,  %txtStatus% %txtInstalling%
            
                RunWait, tools\serve.exe 1 "%Ip%" "%GameName%",, Hide
                GuiControl,, Progress,  0
                GuiControl, Text, Status,  %txtStatus% %txtIdle%
                GameName := ""
                EnableGui()
            } 
            else 
            {
                MsgBox, 1, beeShop - Error, %txtIpNotConfigured%
                EnableGui()
            }
        }    
        else 
        {
            MsgBox, 0, beeShop - Error, %txtNoGame%
            EnableGui()
            if (DbExists != 1) 
            {
                DisableGuiNoDb(txtDbMissing)
            }
        }
    } 
    else 
    {
        FileSelectFile, GameName, 1,, beeShop - %txtSelectGame%, CIAs (*.cia)
        if (GameName != "") {
            Goto, Install
        } 
        else 
        {
            EnableGui()
        }
    }
return

CustomInstall:
if (!A_IsAdmin)
{
    Msgbox, 0, beeShop, %txtNoAdmin%
    EnableGui()
    return
}
else 
{
    if (!FileExist(MovablePath)) 
    {
        Msgbox, 0, beeShop, %txtNoSpecifyMvblNoExist%
        Gui, Show,, %txtConfigCustomInstall%
        EnableGui()
        return
    }
    else if (!FileExist(Boot9Path)) 
    {
        Msgbox, 0, beeShop, %txtNoSpecifyB9NoExist%
        Gui, Show,, %txtConfigCustomInstall%
        EnableGui()
        return
    }
    else if (!FileExist(SeedDbPath)) 
    {
        Msgbox, 0, beeShop, %txtNoSpecifySdbNoExist%
        Gui, Show,, %txtConfigCustomInstall%
        EnableGui()
        return
    }

    FileSelectFile, CiaPath, 1,, beeShop, CIAs (*.cia)
    SplitPath, CiaPath,,, CiaPathExtension,,

    if (CiaPathExtension != "cia") 
    {
        Msgbox, 0, beeShop, %txtNotCia%
        EnableGui()
        return
    }
    N3DSFolder := DriveLetter . "Nintendo 3DS"
    if (!FileExist(N3DSFolder)) 
    {
        Msgbox, 0, beeShop, %txtDriveLetterInvalidOrNotExist%
        EnableGui()
        return
    }
    else 
    {
        if (ShowCiIni = 1)
        {
            ; -st 1 enables "Press any key to exit.." in custominstall.exe (modified by TimmSkiller)
            RunWait, tools\custominstall.exe -m "%MovablePath%" -b "%Boot9Path%" -s "%SeedDbPath%" -st 1 --sd %DriveLetter% "%CiaPath%"
        }
        else 
        {
            RunWait, tools\custominstall.exe -m "%MovablePath%" -b "%Boot9Path%" -s "%SeedDbPath%" --sd %DriveLetter% "%CiaPath%"
        }
        EnableGui()
        return
    }
    EnableGui()
    return
}

return

; Settings

Settings:
DisableGui()
; Read settings from config
IniRead, Ip, settings.ini, Settings, ip
IniRead, AutoUpdateIni, settings.ini, Settings, auto_update
IniRead, LanguageIni, settings.ini, Settings, language
IniRead, InstallMethodIni, settings.ini, Settings, install_method
IniRead, AutoInstallIni, settings.ini, Settings, auto_install
IniRead, ShowCiIni, settings.ini, Settings, show_ci

Gui, Settings:New,,Settings
; app icon
Menu, tray, Icon, assets/icon.ico, 1, 1
;database name, info to click on file names and select database button
Gui, Add, Text, x10 y12 cFFFFFF w140 gShowDbName vDbName, %txtDb% %DbFileName%
Gui, Add, Text, x10 y34 cFFFFFF, %txtClickText%
Gui, Add, Button, gSelectDb x240 y8 w70 h22, %txtSelect%
; IP Config
Gui, Add, Text, x10 y65 cFFFFFF, IP:
Gui, Add, Edit, vInputIp x75 y62 w100, %Ip%
; Language Config
Gui, Add, Text, cFFFFFF x10 y100 w70, %txtLanguage%
Gui, Add, DropDownList, x75 y95 w100 vLanguage Choose%LanguageIni% AltSubmit, English|Spanish|German|Italian|French|Catalan|Portuguese
; Preferred Install Method
Gui, Add, Text, cFFFFFF x10 y135, %txtSelInstallMethod%
Gui, Add, DropDownList, x10 y155 w230 vSelInstallMethod Choose%InstallMethodIni% AltSubmit, %txtDownloadOn3DS%|%txtDownloadOnPC%|custom-install
; Custom-Install config button
Gui, Add, Button, x10 y180 w150 cFFFFFF gCustomInstallSettings, %txtConfigCustomInstall%
; Auto-install checkbox
Gui, Add, Checkbox, vAutoInstall x10 y220 cFFFFFF Checked%AutoInstallIni%, %txtAutoInstall%
; Show Custom-install checkbox
Gui, Add, Checkbox, vCiShow x10 y260 cFFFFFF Checked%ShowCiIni%, %txtShowCiCliWindow%
; Automatic Update Config
Gui, Add, Text, x10 y292 vText c3DCEFC gCheckForUpdates, %txtCfu%
Gui, Add, CheckBox, vAutoUpdate x10 y240 cFFFFFF Checked%AutoUpdateIni%, %txtAutoUpdate%
; Save settings button
Gui, Add, Button, x230 y287 w80 gSave, %txtSave%
; remove maximize and minimize buttons
Gui Settings:-MaximizeBox
Gui Settings:-MinimizeBox
Gui, Show, h320 w320,, %txtSettings%
Gui, Color, 333e40
return

CustomInstallSettings:
IniRead, DriveLetter, settings.ini, CiConfig, drive_letter
IniRead, MovablePath, settings.ini, CiConfig, movable_path
IniRead, Boot9Path, settings.ini, CiConfig, boot9_path
IniRead, SeedDbPath, settings.ini, CiConfig, seeddb_path

Gui, 3:New,, %txtConfigCustomInstall%
Gui, Color, 333e40
; drive letter
Gui, Add, Text, x10 y15 w100 cFFFFFF gShowDriveLetter, %txtDriveLetter%
Gui, Add, Edit, x160 y10 w80 vBoxDrvLetter, %DriveLetter%
; movable.sed
Gui, Add, Text, x10 y52 w150 cFFFFFF gShowMovablePath vLabelMvbleName, Movable: %MovableName%
Gui, Add, Button, x160 y47 w80 cFFFFFF gSelectMovable, %txtSelect%
; boot9.bin
Gui, Add, Text, x10 y87 w150 cFFFFFF gShowBoot9Path vLabelBoot9Name, ARM9 Bootrom: %Boot9Name%
Gui, Add, Button, x160 y82 w80 cFFFFFF gSelectBoot9, %txtSelect%
; seeddb.bin
Gui, Add, Text, x10 y122 w150 cFFFFFF gShowSeedDbPath vLabelSeedDbName, SeedDB: %SeedDbName%
Gui, Add, Button, x160 y117 w80 cFFFFFF gSelectSeedDb, %txtSelect%
; info to click on file names
Gui, Add, Text, x10 y165 w210 cFFFFFF, %txtClickText%
; save ciconfig to ini
Gui, Add, Button, x160 y187 w80 gSaveCiIni cFFFFFF, Save

Gui, Show, h220 w250, %txtConfigCustomInstall%
; remove minimize and maximize buttons
Gui 3:-MaximizeBox
Gui 3:-MinimizeBox
return

SelectMovable:
FileSelectFile, MovablePath, 1,, beeShop, Movable.sed (*.sed)
SplitPath, MovablePath, MovableName,, MvbleExtension,,
if (MovablePath = "") 
{
    return
}
else if (MvbleExtension != "sed") {
    MsgBox, 0, beeShop, %txtMovableInvalid%
}
else {
    GuiControl, 3:Text, LabelMvbleName, Movable: %MovableName%
}
return

SelectBoot9:
FileSelectFile, Boot9Path, 1,, beeShop, boot9.bin (*.bin)
SplitPath, Boot9Path, Boot9Name,, Boot9Extension,,
if (Boot9Path = "") 
{
    return
}
else if (Boot9Extension != "bin") {
    MsgBox, 0, beeShop, %txtB9Invalid%
}
else {
    GuiControl, 3:Text, LabelBoot9Name, ARM9 Bootrom: %Boot9Name%
}
return

SelectSeedDb:
FileSelectFile, SeedDbPath, 1,, beeShop, seeddb.bin (*.bin)
SplitPath, SeedDbPath, SeedDbName,, SeedDbExtension,,
if (SeedDbPath = "") 
{
    return
}
else if (SeedDbExtension != "bin") {
    MsgBox, 0, beeShop, %txtSdbInvalid%
}
else 
{
    GuiControl, 3:Text, LabelSeedDbName, SeedDB: %SeedDbName%
}
return

ShowDriveLetter:
ShowFileExist(DriveLetter, txtFileNotSpecified)
return

ShowMovablePath:
ShowFileExist(MovablePath, txtFileNotSpecified)
return

ShowBoot9Path:
ShowFileExist(Boot9Path, txtFileNotSpecified)
return

ShowSeedDbPath:
ShowFileExist(SeedDbPath, txtFileNotSpecified)
return

SaveCiIni:
Gui, 3:Submit

if (StrLen(BoxDrvLetter) = 3) {
    DrvLetterRegex := RegExMatch(BoxDrvLetter, "[A-Z]:\\" ,DrvRegex,StartingPosition := 1)
    if (DrvLetterRegex != 1) 
    {
        Msgbox, 0, beeShop, %txtInvalidDriveLetterFormat%
        Gui, Show,, %txtConfigCustomInstall%
        return
    }
    else 
    {
        SelDriveLetter := BoxDrvLetter
    }
}
else 
{
    Msgbox, 0, beeShop, %txtInvalidDriveLetterFormat%
    Gui, Show,, %txtConfigCustomInstall%
    return
}

if (!FileExist(MovablePath)) {
    Msgbox, 0, beeShop, %txtNoSpecifyMvblNoExist%
    Gui, Show,, %txtConfigCustomInstall%
    return
}
else if (!FileExist(Boot9Path)) {
    Msgbox, 0, beeShop, %txtNoSpecifyB9NoExist%
    Gui, Show,, %txtConfigCustomInstall%
    return
}
else if (!FileExist(SeedDbPath)) {
    Msgbox, 0, beeShop, %txtNoSpecifySdbNoExist%
    Gui, Show,, %txtConfigCustomInstall%
    return
}

IniWrite, %SelDriveLetter%, settings.ini, CiConfig, drive_letter
IniWrite, %MovablePath%, settings.ini, CiConfig, movable_path
IniWrite, %Boot9Path%, settings.ini, CiConfig, boot9_path
IniWrite, %SeedDbPath%, settings.ini, CiConfig, seeddb_path
return

ShowDbName:
if (DatabaseIni = "") {
    MsgBox, 0, beeShop, %txtFileNotSpecified%
}
else 
{
    MsgBox,, beeShop, %DatabaseIni%
}
return

SelectDb:
FileSelectFile, ChosenDb, 1, %A_WorkingDir%, beeShop - %txtFileSelect%, Database CSV (*.csv)
SplitPath, ChosenDb, DbFileName,, DbExtension,,
if (ChosenDb = "") 
{
    return
}
else if (DbExtension != "csv") {
    Msgbox, 0, beeShop, %txtInvalidDb%
}
if (ChosenDb != "") {
    if (StrLen(DbFileName) > 11) {
        DbFileName := SubStr(DbFileName, 1, 9) . "..."
    }
} 
GuiControl, Settings:Text, DbName, %txtDb% %DbFileName%
return

CheckForUpdates:
if (AutoUpdateIni = 1) {
    MsgBox, 4, beeShop - %txtUpdate%, %txtCfuMsg%
    IfMsgBox, No
    return
}
url := "https://api.github.com/repos/manuGMG/beeShop/releases/latest"
whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
whr.Open("GET", url, false)
whr.Send()
    
JsonResponse := JSON.Load(whr.responseText)
LastRelease := JsonResponse.tag_name
    
if (LastRelease = "") {
    MsgBox, 0,beeShop - %txtUpdate%, % JsonResponse.message
    return
}
    
if (LastRelease != CurrentRelease) 
{
    MsgBox, 4, beeShop - %txtUpdate%, %txtCfuMsg%
    IfMsgBox, Yes
        LastReleaseURL := JsonResponse.assets[1].browser_download_url
        DownloadFile(LastReleaseURL, "release.zip", True, False)
        Extract_7Zip("7za.exe")
        While !FileExist( "7za.exe")
            Sleep 250
        Extract_Update("update.exe")
        While !FileExist( "update.exe")
            Sleep 250
        Run, update.exe
        ExitApp
    IfMsgBox, No
        EnableGui()
        return
} 
else 
{
    MsgBox, 0, beeShop - %txtUpdate%, %txtNoUpdateFound% %CurrentRelease%
}
return

Save:
Gui, Settings:Submit
EnableGui()
CurrentLang := LanguageIni
CurrentDb := DatabaseIni

if (InputIp == "") 
{
    MsgBox, 0, beeShop - Error, %txtIpNotConfigured%
    Gui, Show,,Settings
} 
else if (InputIp != Ip) 
{
    IniWrite, %InputIp%, settings.ini, Settings, ip
}
IniWrite, %AutoUpdate%, settings.ini, Settings, auto_update
IniWrite, %Language%, settings.ini, Settings, language
IniWrite, %AutoInstall%, settings.ini, Settings, auto_install
IniWrite, %CiShow%, settings.ini, Settings, show_ci

if (FileExist(ChosenDb)) 
{
    IniWrite, %ChosenDb%, settings.ini, Settings, db
}

if (InstallMethodIni != SelInstallMethod) 
{
    IniWrite, %SelInstallMethod%, settings.ini, Settings, install_method
}
IniRead, SavedLang, settings.ini, Settings, language
IniRead, InstallMethodIni, settings.ini, Settings, install_method
IniRead, SavedDb, settings.ini, Settings, db

if (SavedLang != CurrentLang and InputIp != "") 
{
   Goto, AskForRestart
}
if (CurrentDb != SavedDb and InputIp != "") 
{
    Goto, AskForRestart
}

if (SelInstallMethod = 3) 
{
    Msgbox, 0, beeShop, %txtCiWarning%
}

EnableGui()

return

AskForRestart:
MsgBox, 4, beeShop - %txtRestart%, %txtAskRestart%
IfMsgBox, Yes
    Reload
return

Esc::
Gui, ShowLink:Destroy
return

Enter::
Send, {Enter}
Gui,1:Submit,NoHide
GuiControl, ChooseString, GameList, %Search%
return

SettingsGuiClose:
EnableGui()
if (DbExists != 1) 
{
    DisableGuiNoDb(txtDbMissing)
}
Gui, Cancel
return

GuiClose:
ExitApp
return
