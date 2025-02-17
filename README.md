# Blynk Local Server Installer For Windows 10/11 64 bit

Below are the instructions to install **Blynk Local Server** and **Blynk Library For Arduino IDE** on a Windows-64 bit OS


## Steps to install blynk local server on Windows 10/11 - 64 bit?
1. Install Java 11 from **[OpenLogic](https://builds.openlogic.com/downloadJDK/openlogic-openjdk-jre/11.0.26+4/openlogic-openjdk-jre-11.0.26+4-windows-x64.msi)**.
2. Make a folder with name **rawFolder** on your desktop.
3. Download a script **[BlynkServerAutoInstallerWin.ps1](https://raw.githubusercontent.com/msanaullahsahar/Blynk-Local-Server-Auto-Installer-For-Windows-OS/master/BlynkServerAutoInstallerWin.ps1)** and put it in the _rawFolder_.
4. Run windows Powershell as Administrator.
5. Change the directory of powershell to _rawFolder_ by pasting the command below in powershell.
```
cd C:\Users\$env:UserName\Desktop\rawFolder
```
6. Copy and paste the following command in powershell window and hit ENTER key.

```
Set-ExecutionPolicy RemoteSigned -Force
```
7. Now to run the _installation script_, copy and paste the following command in powershell window and again hit ENTER Key.

```
.\BlynkServerAutoInstallerWin.ps1
```
   
8. Wait for the process to complete.
9. Access admin page of _blynk local server_ at https://127.0.0.1:9443/admin (Email is: admin@blynk.cc  Password: 12345)
10. Super easy. Isn't it? As usual, report any error while using this script: [Report Issue](https://github.com/msanaullahsahar/Blynk-Local-Server-Auto-Installer-For-Windows-OS/issues/new)
