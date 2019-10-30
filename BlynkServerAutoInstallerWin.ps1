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
$BlynkServerVer="0.41.11"	
$start_time = Get-Date
Write-Host "`r`n"
Write-Host "This script will download and install Blynk Local Server on your PC/Laptop." -ForegroundColor Red -BackgroundColor Yellow
Write-Host "`r`n"

#================================================================================================
# Remove folder and files if there were already downloaded.
#Remove-Item BlynkLocalServer -Force -Recurse -ErrorAction Ignore
rmdir C:\BlynkLocalServer

#================================================================================================
# Create folder
#New-Item BlynkLocalServer -ItemType "directory"
mkdir C:\BlynkLocalServer

#================================================================================================
# Go to created folde
cd C:\BlynkLocalServer
[console]::beep(2000,500)

#================================================================================================
# Fetch blynk local server from GitHub
$url = "https://github.com/blynkkk/blynk-server/releases/download/v" + $BlynkServerVer + "/server-" + $BlynkServerVer + ".jar"
$output = "$PSScriptRoot\server-$BlynkServerVer.jar"
Invoke-WebRequest -Uri $url -OutFile $output

#================================================================================================
# Allow Less Secure Apps Access:ON
Start-Process "https://myaccount.google.com/lesssecureapps"
# Wait for process to complete
Add-Type -AssemblyName PresentationCore,PresentationFramework
$ButtonType = [System.Windows.MessageBoxButton]::Ok
$MessageIcon = [System.Windows.MessageBoxImage]::Information
$MessageBody = "Check the webpage opened for you. Please Allow Less Secure Apps: ON and then press OK button. DO NOT press OK Button before moving the slider to right hand side position."
$MessageTitle = "Grant Gmail Access"
$Result = [System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)

#================================================================================================
# Enable mail on local server
Write-Host "`r`n"
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

#================================================================================================
# Open ports for blynk
netsh advfirewall firewall add rule name="OpenPort 80" dir=in action=allow protocol=TCP localport=80
netsh advfirewall firewall add rule name="OpenPort 443" dir=in action=allow protocol=TCP localport=443
netsh advfirewall firewall add rule name="OpenPort 8080" dir=in action=allow protocol=TCP localport=8080
netsh advfirewall firewall add rule name="OpenPort 9443" dir=in action=allow protocol=TCP localport=9443

#================================================================================================
# Run Blynk Server
java -jar server-$BlynkServerVer.jar -dataFolder BlynkLocalServer


#================================================================================================
# Create Auto Start for Blynk Server
New-Item start-blynk.bat
Set-Content start-blynk.bat 'java -jar server-$BlynkServerVer.jar -dataFolder BlynkLocalServer'
Move-Item start-blynk.bat -Destination "C:\Users\${env:UserName}\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
[console]::beep(2000,500)

#================================================================================================
# New line for spacing
Clear-Host
Write-Host "`r`n"
Write-Host "`nYou can access blynk server admin page at https://127.0.0.1:9443/admin`n"
Write-Host "`r`n"
Write-Host "`r`n"
Write-Host "`nPlease restart your laptop/PC `n"

#================================================================================================
Write-Host "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Red -BackgroundColor Yellow
[console]::beep(2000,500)
(New-Object -com SAPI.SpVoice).speak("Blynk local server is installed successfully.")
# Display Ok Box
Add-Type -AssemblyName PresentationCore,PresentationFramework
$ButtonType = [System.Windows.MessageBoxButton]::Ok
$MessageIcon = [System.Windows.MessageBoxImage]::Information
$MessageBody = "Your laptop/PC will be restarted now."
$MessageTitle = "Server Installed"
$Result = [System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)
restart-computer
}
