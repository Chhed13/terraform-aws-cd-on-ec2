$version_tag = $env:version.Replace(".","_")
$name = "MyService"
$consul_name = $name.ToLower() # do not make camel case for DNS names. Better use lower everywhere
$port = 8000

Write-Host "service install"
New-Service -Name $name -BinaryPathName "C:\Python36\python.exe C:\$consul_name\run.py" -StartupType Automatic

Write-Host "consul check install"

@"
{
  "services": [
    {
      "id": "$consul_name",
      "name": "$consul_name",
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
"@ | Out-File -Encoding ascii -FilePath "c:\consul\config\$consul_name.json"

Write-Host "fw install"

New-NetFirewallRule -DisplayName $name -Direction Inbound -LocalPort $port -Protocol TCP -Action Allow

Write-Host "done"