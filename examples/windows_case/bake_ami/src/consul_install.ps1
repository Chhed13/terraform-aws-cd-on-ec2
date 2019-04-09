$version = "1.4.4"
$Url= "https://releases.hashicorp.com/consul/$version/consul_$version`_windows_amd64.zip"
$path = "c:\consul"

New-Item -ItemType Directory -Force "$path\config"
New-Item -ItemType Directory -Force "$path\data"

[System.Net.ServicePointManager]::SecurityProtocol = 'Tls12'
iwr -Uri $Url -OutFile "$path\consul.zip"
Expand-Archive "$path\consul.zip" -DestinationPath $path -Force

New-Service -Name consul -BinaryPathName "$path\consul.exe agent -config-file=$path\consul.json -config-dir=$path\config -data-dir=$path\data" -StartupType Automatic

#Disable DNS response caching"
Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters -Name MaxNegativeCacheTtl -Value 0 -Type DWord

New-NetFirewallRule -DisplayName consul -Direction Inbound -LocalPort 8600,8500,8400,8301,8302,8300 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName consul -Direction Inbound -LocalPort 8600,8301,8302 -Protocol UDP -Action Allow
