Begin {
	if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
	{
	Add-Type -AssemblyName PresentationCore,PresentationFramework
	$ButtonType = [System.Windows.MessageBoxButton]::Ok
	$MessageIcon = [System.Windows.MessageBoxImage]::Warning
	$MessageBody = "You are not running this script as an administrator. Run it again as an administrator."
	$MessageTitle = "Admin Access Required"
	$Result = [System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)
	#Write-Warning "You are not running this script as an administrator. Run it again as administrator." ;
	break
	}

# Check Java	
$javaVer=(Get-Command java | Select-Object -ExpandProperty Version).tostring()
$javaCheck=$javaVer.Split(".")

if ($javaCheck[0] -lt 11){
	Start-Process https://www.oracle.com/technetwork/java/javase/overview/index.html
	Add-Type -AssemblyName PresentationCore,PresentationFramework
	$ButtonType = [System.Windows.MessageBoxButton]::Ok
	$MessageIcon = [System.Windows.MessageBoxImage]::Warning
	$MessageBody = "Please install latest java. If you have already installed it then add it to environment variables."
	$MessageTitle = "Java Required"
	$Result = [System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)
	break
}


$BlynkServerVer="0.41.11"
$LibraryVer="0.6.1"

Write-Host "This script will download and install Blynk Local Server on your PC/Laptop." -ForegroundColor Red -BackgroundColor Yellow
Write-Host "`r`n"

# First Download and install Blynk Library
Write-Host "Fetch Blynk Library from GitHub" -ForegroundColor Red -BackgroundColor Yellow
$url = "https://github.com/blynkkk/blynk-library/releases/download/v" + $LibraryVer + "/Blynk_Release_v" + $LibraryVer + ".zip"
$output = "$PSScriptRoot\Blynk_Release_v$LibraryVer.zip"
Invoke-WebRequest -Uri $url -OutFile $output

# Unzip Library in Arduino Folder
$LibraryPath = "C:\Users\$env:UserName\Documents\Arduino"
expand-archive "Blynk_Release_v$LibraryVer.zip" -destinationpath $LibraryPath -Force

# Remove downloaded Library
Remove-Item Blynk_Release_v$LibraryVer.zip

# Define Server location
$ServerPath = "C:\Users\$env:UserName\Documents\BlynkLocalServer"

# Remove blynk server folder if already present.
Remove-Item $ServerPath -Force -Recurse -ErrorAction Ignore

# Create folder for putting blynk server .jar file.
New-Item -ItemType "directory" -Path $ServerPath

# Fetch Blynk Local server from GitHub
$url = "https://github.com/blynkkk/blynk-server/releases/download/v" + $BlynkServerVer + "/server-" + $BlynkServerVer + ".jar"
$output = "$PSScriptRoot\server-$BlynkServerVer.jar"
Invoke-WebRequest -Uri $url -OutFile $output

# Move server file to server folder
Move-Item "server-$BlynkServerVer.jar" -Destination $ServerPath

# Allow Less Secure Apps Access:ON
Start-Process "https://myaccount.google.com/lesssecureapps"
# Wait for process to complete
Add-Type -AssemblyName PresentationCore,PresentationFramework
$ButtonType = [System.Windows.MessageBoxButton]::Ok
$MessageIcon = [System.Windows.MessageBoxImage]::Information
$MessageBody = "Check the webpage opened for you. Please Allow Less Secure Apps: ON and then press OK button. DO NOT press OK Button before moving the slider to right hand side position."
$MessageTitle = "Grant Gmail Access"
$Result = [System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)

# Enable mail on local server
$gMail = Read-Host -Prompt "What is your gmail address? :"
Write-Host "`r`n"
$gMailPass = Read-Host -Prompt "What is your gmail password? :"
New-Item mail.properties
Set-Content mail.properties mail.smtp.auth=true
Add-Content mail.properties mail.smtp.starttls.enable=true
Add-Content mail.properties mail.smtp.host=smtp.gmail.com
Add-Content mail.properties mail.smtp.port=587
Add-Content mail.properties mail.smtp.username=$gMail
Add-Content mail.properties mail.smtp.password=$gMailPass

# Move mail properties file to server folder
Move-Item mail.properties -Destination $ServerPath -Force

# Open ports for blynk
netsh advfirewall firewall add rule name="OpenPort 80" dir=in action=allow protocol=TCP localport=80
netsh advfirewall firewall add rule name="OpenPort 443" dir=in action=allow protocol=TCP localport=443
netsh advfirewall firewall add rule name="OpenPort 8080" dir=in action=allow protocol=TCP localport=8080
netsh advfirewall firewall add rule name="OpenPort 9443" dir=in action=allow protocol=TCP localport=9443

# Create Auto Start for Blynk Server
New-Item start-blynk.bat
$BlynkCMD = "java -jar $ServerPath\server-"+ $BlynkServerVer+".jar -dataFolder $ServerPath"
Set-Content start-blynk.bat $BlynkCMD
Move-Item start-blynk.bat -Destination "C:\Users\${env:UserName}\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"

# Run Blynk Server
java -jar "$ServerPath\server-$BlynkServerVer.jar" -dataFolder $ServerPath
}
