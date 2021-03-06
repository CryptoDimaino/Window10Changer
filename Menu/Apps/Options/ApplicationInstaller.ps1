New-Item -Force -ItemType directory -Path C:\InstallerApps

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12


$output2 = "C:\InstallerApps\Chromex64.exe"
$output3 = "C:\InstallerApps\Firefoxx64.exe"
$output4 = "C:\InstallerApps\NotePad++x64.exe"
$output5 = "C:\InstallerApps\VLCMediaPlayerx64.exe"


$url2 = "https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B0DC43149-738D-EB7C-0875-4A907A9D5AD3%7D%26lang%3Den%26browser%3D4%26usagestats%3D1%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx64-stable-statsdef_1%26installdataindex%3Dempty/chrome/install/ChromeStandaloneSetup64.exe"
$url3 = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/64.0.2/win32/en-US/Firefox%20Installer.exe"
$url4 = "https://notepad-plus-plus.org/repository/7.x/7.6.2/npp.7.6.2.Installer.x64.exe"
$url5 = "https://mirror.sfo12.us.leaseweb.net/videolan/vlc/3.0.6/win32/vlc-3.0.6-win32.exe"


#(New-Object System.Net.WebClient).DownloadFile($url2, $output2)
#(New-Object System.Net.WebClient).DownloadFile($url3, $output3)
#(New-Object System.Net.WebClient).DownloadFile($url4, $output4)
#(New-Object System.Net.WebClient).DownloadFile($url5, $output5)


$InstallList = @(
	#"InstallBraveBrowser",
	"InstallGoogleChrome"
	#"InstallFireFox"
)

Function CheckIfInstalled($Software)
{
	$Value = $FALSE
	#Checks if OS Architecture is 64-Bit or 32-Bit
	if ([IntPtr]::Size -eq 4)
	{
        $installed32 = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -eq $Software }) -ne $null
		$installed64 = $FALSE
    }
    else
	{
		$installed32 = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -eq $Software }) -ne $null
		$installed64 = (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*  | Where { $_.DisplayName -eq $Software }) -ne $null
    }
	If(-Not $installed32 -and -Not $installed64)
	{
		$Value = $TRUE
		Write-Host "'$Software' is NOT installed.";
	} 
	else
	{
		$Value = $FALSE
		Write-Host "'$Software' is installed."
	}
	return $Value
}

Function PinBraveBrowserToTaskBar
{
	if([System.IO.File]::Exists('%appdata%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar'))
	{
		Write-Host "Brave Browser is already on the taskbar."
	}
	else
	{
		$Location = Split-Path -Path $PSScriptRoot
		$Location = Split-Path -Path $Location -Parent
		$Location = Split-Path -Path $Location -Parent
		$CMD =  Join-Path -Path $Location -ChildPath "Menu\Tools\Options\syspin.exe"
		$arg1 = 'C:\Program Files (x86)\BraveSoftware\Brave-Browser\Application\brave.exe'
		$arg2 = 'c:"Pin to Taskbar"'
		& $CMD $arg1 $arg2
		Write-Host "Brave Browser was pinned to the taskbar."
	}
}

Function InstallBraveBrowser()
{
	if(CheckIfInstalled('Brave'))
	{
		$output1 = "C:\InstallerApps\Bravex64.exe"
		$url1 = "https://laptop-updates.brave.com/latest/winx64"
		Write-Host "Downloading Brave Browser x64 Version..."
		(New-Object System.Net.WebClient).DownloadFile($url1, $output1)
		
		Write-Host "Installing Brave Browser x64 Version..."
		Start-Process -FilePath 'C:\InstallerApps\Bravex64.exe' -PassThru

		$BraveLoop = $false

		Do
		{
			$Bravestatus =  Get-Process -Name "brave" -ErrorAction SilentlyContinue
			if(!($Bravestatus))
			{
				Write-Host 'Installing Brave Browser...' ;
				Start-Sleep -S 2
			}
			else
			{
				$BraveLoop = $true
			}
		}
		Until($BraveLoop)
		Start-Sleep -S 2
		Write-Host "Stopping Brave Browser and Installer..."
		Stop-Process -Name "BraveUpdate" -Force
		Stop-Process -Name "brave" -Force
		PinBraveBrowserToTaskBar
		Write-Host 'Brave Browser has been installed!' ;
	}
	else
	{
		Write-Host 'Brave Browsers appears to already be installed.'
	}
}


Function PinChromeBrowserToTaskBar
{
	if([System.IO.File]::Exists('%appdata%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar'))
	{
		Write-Host "Chrome Browser is already on the taskbar."
	}
	else
	{
		$Location = Split-Path -Path $PSScriptRoot
		$Location = Split-Path -Path $Location -Parent
		$Location = Split-Path -Path $Location -Parent
		$CMD =  Join-Path -Path $Location -ChildPath "Menu\Tools\Options\syspin.exe"
		$arg1 = 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe'
		$arg2 = 'c:"Pin to Taskbar"'
		& $CMD $arg1 $arg2
		Write-Host "Chrome Browser was pinned to the taskbar."
	}
}

Function InstallGoogleChrome()
{
	if(CheckIfInstalled('Chrome'))
	{
		$output2 = "C:\InstallerApps\Chromex64.exe"
		$url2 = "https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B0DC43149-738D-EB7C-0875-4A907A9D5AD3%7D%26lang%3Den%26browser%3D4%26usagestats%3D1%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx64-stable-statsdef_1%26installdataindex%3Dempty/chrome/install/ChromeStandaloneSetup64.exe"
		#$url2 = "https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B5037592E-477A-46DB-207A-2C2C27C53C51%7D%26lang%3Den%26browser%3D4%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dtrue%26ap%3Dx64-stable-statsdef_0%26brand%3DGCEB/dl/chrome/install/GoogleChromeEnterpriseBundle64.zip"
		Write-Host "Downloading Chrome Browser x64 Version..."
		(New-Object System.Net.WebClient).DownloadFile($url2, $output2)
		
		#Expand-Archive -LiteralPath 'C:\InstallerApps\Chromex64.zip' -DestinationPath 'C:\InstallerApps\Chromex64' -Force
		
		
		Write-Host "Installing Chrome Browser x64 Version..."
		Start-Process -Wait -FilePath 'C:\InstallerApps\Chromex64.exe' -PassThru
		#msiexec.exe /i "C:\InstallerApps\Chromex64\Installers\GoogleChromeStandaloneEnterprise64.msi" /quiet
		#$params = '/i', 'C:\InstallerApps\Chromex64\Installers\GoogleChromeStandaloneEnterprise64.msi', '/quiet'
		#$p = Start-Process 'msiexec.exe' -ArgumentList $params -NoNewWindow -Wait -PassThru
		#$p.ExitCode
		#Start-Process -FilePath C:\Windows\System32\msiexec.exe -ArgumentList "/i C:\InstallerApps\Chromex64\Installers\GoogleChromeStandaloneEnterprise64.msi" -wait
		#msiexec: /i googlechrome.msi /quiet Remove-Item C:\Users\Public\Desktop\Google Chrome.lnk
		Start-Sleep -S 2
		
		Stop-Process -Name "chrome" -Force
		Write-Host "Stopping Chrome Browser and Installer..."
		PinChromeBrowserToTaskBar
		
		#Remove-Item -path 'C:\Users\Public\Desktop\Google Chrome.lnk'  -Force
		Write-Host 'Chrome Browser Desktop Icon has been Deleted.' ;
		Write-Host 'Chrome Browser has been installed!' ;
		
	}
	else
	{
		Write-Host 'Chrome Browsers appears to already be installed.'
	}
}

# Call the Installs
$InstallList | ForEach { Invoke-Expression $_ }









