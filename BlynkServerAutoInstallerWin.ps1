# Check for Administrator Privileges
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    [System.Windows.MessageBox]::Show("You are not running this script as an administrator. Run it again as an administrator.", "Admin Access Required", [System.Windows.MessageBoxButton]::Ok, [System.Windows.MessageBoxImage]::Warning)
    Write-Warning "You are not running this script as an administrator. Run it again as administrator."
    exit
}

# Check whether Java is installed
$javaVersionOutput = & java -version 2>&1 | Out-String
if ($javaVersionOutput -notmatch "OpenJDK") {
    Write-Host "OpenJDK is not installed. Installing OpenJDK..."
    $javaInstaller = "https://builds.openlogic.com/downloadJDK/openlogic-openjdk-jre/11.0.26+4/openlogic-openjdk-jre-11.0.26+4-windows-x64.msi"
    $javaInstallerPath = "$PSScriptRoot\openjdk.msi"
    Invoke-WebRequest -Uri $javaInstaller -OutFile $javaInstallerPath
    Start-Process "msiexec.exe" -ArgumentList "/i $javaInstallerPath /qn" -Wait
    Remove-Item $javaInstallerPath -Force
    exit
}

Write-Host "`r`n"
Write-Host "This script will download and install Blynk Local Server on your PC/Laptop." -ForegroundColor Red -BackgroundColor Yellow
Write-Host "`r`n"

# Remove old Blynk files
$basePath = "C:\Users\$env:UserName\Documents\Arduino"
$folders = @("Blynk", "BlynkESP8266_Lib", "Time", "TinyGSM")
foreach ($folder in $folders) {
    $fullPath = Join-Path -Path $basePath -ChildPath $folder
    if (Test-Path $fullPath) {
        Remove-Item -Path $fullPath -Recurse -Force
        Write-Host "Removed: $fullPath"
    }
}

# Download and install Blynk Library
Write-Host "Fetching Blynk Library from GitHub..." -ForegroundColor Red -BackgroundColor Yellow
$blynkZip = "$PSScriptRoot\Blynk_Release_v0.6.1.zip"
Invoke-WebRequest -Uri "https://github.com/blynkkk/blynk-library/releases/download/v0.6.1/Blynk_Release_v0.6.1.zip" -OutFile $blynkZip
Expand-Archive -Path $blynkZip -DestinationPath $basePath -Force
Remove-Item -Path $blynkZip -Force

# Define Blynk Server location
$ServerPath = "C:\Users\$env:UserName\Documents\BlynkLocalServer"
Remove-Item -Path $ServerPath -Recurse -Force -ErrorAction Ignore
New-Item -ItemType Directory -Path $ServerPath | Out-Null

# Download Blynk Local Server
Write-Host "Downloading Blynk Local Server..."
Invoke-WebRequest -Uri "https://github.com/Peterkn2001/blynk-server/releases/download/v0.41.17/server-0.41.17.jar" -OutFile "$ServerPath\server-0.41.17.jar"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/msanaullahsahar/Blynk-Local-Server-Auto-Installer-For-Windows-OS/refs/heads/master/server.properties" -OutFile "$ServerPath\server.properties"

# Configure firewall rules
$ports = @(80, 443, 8080, 9443)
foreach ($port in $ports) {
    if (-not (netsh advfirewall firewall show rule name="OpenPort $port" | Select-String "$port")) {
        netsh advfirewall firewall add rule name="OpenPort $port" dir=in action=allow protocol=TCP localport=$port
    }
}

# Create Auto Start for Blynk Server
$batFilePath = "C:\Users\$env:UserName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\start-blynk.bat"
$batContent = "@echo off`njava -jar `"$ServerPath\server-0.41.17.jar`" -dataFolder `"$ServerPath`""
Set-Content -Path $batFilePath -Value $batContent

# Start Blynk Server
Write-Host "Starting Blynk Server..." -ForegroundColor Red -BackgroundColor Yellow
Write-Host "Blynk URL: https://127.0.0.1:9443/admin" -ForegroundColor Red -BackgroundColor Yellow
Write-Host "Admin Email: admin@blynk.cc" -ForegroundColor Red -BackgroundColor Yellow
Write-Host "Admin Password: 12345" -ForegroundColor Red -BackgroundColor Yellow
#Start-Process "java" -ArgumentList "-jar `"$ServerPath\server-0.41.17.jar`" -dataFolder `"$ServerPath`"" -NoNewWindow
Start-Job -ScriptBlock {
    Start-Process "java" -ArgumentList "-jar `"$using:ServerPath\server-0.41.17.jar`" -dataFolder `"$using:ServerPath`"" -WindowStyle Hidden
}
