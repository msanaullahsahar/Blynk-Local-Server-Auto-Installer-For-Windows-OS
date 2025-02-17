# Blynk Local Server Installer For Windows OS

Below are the instructions to install **Blynk Local Server** and **Blynk Library For Arduino IDE** on a Windows-64 bit OS


## How to install Blynk local server on Windows OS - 64 bit?
1. Install Java 11 from **[OpenLogic](https://builds.openlogic.com/downloadJDK/openlogic-openjdk-jre/11.0.26+4/openlogic-openjdk-jre-11.0.26+4-windows-x64.msi)**
2. Make a folder with name **rawFolder** on your desktop
3. Download a script **[BlynkServerAutoInstallerWin.ps1](https://raw.githubusercontent.com/msanaullahsahar/Blynk-Local-Server-Auto-Installer-For-Windows-OS/master/BlynkServerAutoInstallerWin.ps1)** and put it in the rawFolder,
4. Run windows Powershell as Administrator.
5. Change the directory of powershell to rawFolder you just created by pasting the command below in powershell.
```
cd C:\Users\$env:UserName\Desktop\rawFolder
```
6. Type the following command in powershell window, reply with **A** and Hit ENTER Key.

```
set-executionpolicy remotesigned
```
7. Type the following command in powershell window and Hit Enter Key.

```
.\BlynkServerAutoInstallerWin.ps1
```
   
8. Wait for the process to complete.
9. Access admin page of Blynk local server at https://127.0.0.1:9443/admin (Admin Email is: admin@blynk.cc  Admin Password: 12345)
10. Super easy. Isn't it?
11. Report any error if you encounter while using this script at here: [Report Issue](https://github.com/msanaullahsahar/Blynk-Local-Server-Auto-Installer-For-Windows-OS/issues/new)
