$version_tag = $env:VERSION.Replace(".","_")
$name = "MyService"
$low_name = $name.ToLower() # do not make camel case for DNS names. Better use lower everywhere
$port = 8000

# run under NSSM
#$nssmurl="http://nssm.cc/release/nssm-2.24.zip"
#$nssmExe = "C:\$low_name\nssm.exe"
#
#[System.Net.ServicePointManager]::SecurityProtocol = 'Tls12'
#iwr -Uri $nssmurl -OutFile "C:\$low_name\nssm.zip"
#Expand-Archive "C:\$low_name\nssm.zip" -DestinationPath "C:\$low_name\nssm" -Force
#Move-Item  "C:\$low_name\nssm\nssm-2.24\win64\nssm.exe" $nssmExe
#Remove-Item -Recurse "C:\$low_name\nssm\"

& nssm install $low_name C:\Python36\python.exe C:\$low_name\run.py
& nssm set $low_name AppDirectory C:\$low_name

@"
{
  "services": [
    {
      "id": "$low_name",
      "name": "$low_name",
      "port": $port,
      "tags": ["$version_tag"],
      "checks": [
        {
          "http": "http://127.0.0.1:$port/health",
          "interval": "30s",
          "timeout": "5s"
        }
      ]
    }
  ]
}
"@ | Out-File -Encoding ascii -FilePath "c:\consul\config\$low_name.json"

New-NetFirewallRule -DisplayName $name -Direction Inbound -LocalPort $port -Protocol TCP -Action Allow