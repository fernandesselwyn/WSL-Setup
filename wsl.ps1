#Script to install WSL
function PreReqs(){
#Pre-requisites
#Check version is above Windows 10 - Ver. 1903 Build 18362 or above
mkdir /tmp
winver
#add logic to read this output
#add logic to check user permission for local administrative privledge
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
echo "Prereq" >prereq.txt
#Reboot
shutdown -f -r -t 00
}

function WSLInstall(){
Invoke-webrequest -uri https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi -OutFile wsl_update_x64.msi -UseBasicParsing 
.\wsl_update_x64.msi
wsl --set-default-version 2
}

function downloadUbuntu{
Invoke-WebRequest -Uri https://aka.ms/wslubuntu2004 -OutFile Ubuntu.appx -UseBasicParsing
Add-AppxPackage .\Ubuntu.appx
}

function downloadDebian{
Invoke-WebRequest -Uri https://aka.ms/wsl-debian-gnulinux -OutFile Debian.appx -UseBasicParsing
Add-AppxPackage .\Debian.appx
}

if(%path%/tmp/prereq.txt){
#Wrap things into a function to be able to jump around 
.\WSLInstall
.\downloadUbuntu
.\downloadDebian
}
else{ 
echo "System will be rebooted"
.\PreReqs
}

<#
References / Notes
Ubuntu
#Set username (recommend to match ldap/ad username
Apt-get update && apt-get upgrade -y

# WSL per distro configuration (/etc/wsl.conf)
Update /etc/wsl.conf with various options to setup specific values like
* Start on boot (this can then cascade to also allow cronjobs to run)
* Setup Custom DNS resolvers (YOU NEED THIS!!)
* Setup default user
* See: https://docs.microsoft.com/en-us/windows/wsl/wsl-config#configure-per-distro-launch-settings-with-wslconf
GLOBAL Options: https://docs.microsoft.com/en-us/windows/wsl/wsl-config#configure-global-options-with-wslconfig 

#Need to add the link about DNS and time sync issues
#>
