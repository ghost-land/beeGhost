![beeShop](https://i.imgur.com/ZWQt80t.png)

## How to use:

NOTE: Make sure your 3DS and the computer you're using beeShop on are on the same network if you're using the first or second install method. If they aren't, you won't be able to send the files/URLs over to your 3DS.

1. Download & extract the latest beeShop release (preferrably into a separate folder).
2. Get ahold of a database file (.CSV) in format composed of `Name,URL` (either made by yourself or from other sources) and put it somewhere easily accessible.
3. On your 3DS, open FBI > Remote Install > "Receive URL's over the Network" and note down the IP of your 3DS (don't close FBI after doing this).
4. Launch beeShop, and click on the Settings button to open the Settings menu. You can configure lots of stuff in there, but right now, you need to press on the `Select` button on the top right hand corner. This will open a file selection dialog. Select a database (.CSV) file whose values should be in this format: `Name,URL`. Then, write the IP Address of your 3DS in the text box below `IP:`, select your preferred install method, and finally click on `Save`. beeShop should ask you to restart. Allow it.



If your selected install method is `Download & Install on 3DS`:
1. Make sure your 3DS is in FBI > Remote Install > `Receive URLs over the Network`.
2. Select an entry of your choice from the list and click on `Install`. If everything went right, beeShop should send the download link for the selected entry to FBI, which will ask you to install. Press A to do so.

NOTE: beeShop will stay on `Status: Installing` while your 3DS is downloading in FBI.



If your selected install method is `Download on PC, install on 3DS`:
1. Make sure your 3DS is in FBI > Remote Install > `Receive URLs over the Network`.
2. Select an entry of your choice from the list and click on `Download`. The selected entry will now be downloaded and a message box will show `(entry) was successfully downloaded.` once it's done. Now, click on the `Install` button and choose the file (.CIA) that was downloaded (it will be located in the same directory where beeShop.exe is located). 

This will send the file to FBI, which will ask you whether you want to install or not on your 3DS. Press A to install.



If your selected install method is `custom-install`:
WARNING: custom-install is intended for advanced users only. Damage and or corruption may occur in some cases. Make sure you have a backup of your SD card just in case. You'll get shown this exact same warning when beeShop starts with custom-install as the selected install method.

1. Open the settings menu and click on the `Configure custom-install` button. This will open yet another window where you can specify the different files/paths needed for custom-install. Here's what you need:

- The SD card content encryption key from your 3DS (movable.sed)
- The ARM9 Bootrom of your 3DS (boot9.bin)
[How to dump various 3DS files](https://ianburgwin.net/ctr/dump/)
- A seed database for games that require seeds to function (seeddb.bin) (required, beeShop won't launch custom-install without this)

Specify a valid drive letter in the first text box (D:/ for example).
Select your movable.sed file in the second text box.
Select your boot9.bin file in the third text box.
Select the seeddb.bin in the fourth text box.

Click on save.

2. Get CIAs (app files). These must be sourced by yourself or by using the second install method.
3. Make sure you have your SD card inserted into your computer. (and that you have the correct drive letter specified in the custom-install settings).
4. On the main window, click on `Install`, which will open a file selection dialog. Select a .CIA file. If you have checked `Show custom-install command line window`, that window will open so you can see what's happening.
5. Once it finished installing, you have to use [custom-install-finalize](https://github.com/ihaveamac/custom-install/releases/tag/finalize-1.4) on your 3DS to install a ticket for the installed title.

## Credits:
* manuGMG & TimmSkiller
* DexterX12

**Tools used:**
* Steveice10 - ([servefiles.py and sendurls.py](https://github.com/Steveice10/FBI/tree/master/servefiles))
* ihaveamac - ([custom-install](https://github.com/ihaveamac/custom-install))

**Translators:**
* TimmSkiller (German Translation)
* CiN CiN (Italian Translation)
* raccoon (French Translation)
* Eidwood (Catalan Translation)
* GrabsZel (Portuguese Translation)

**Testers:**
* Mineplanet84
* MyPasswordIsWeak
* Mike
* Kaiju
* Kelonio

## Note:
beeShop does not encourage piracy and is only a way of gathering homebrew applications to a modded Nintendo 3DS System.
