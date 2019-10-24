<powershell>
set-executionpolicy unrestricted -force

$id = ""
while ($id -eq "")
{
    Start-Sleep -Seconds 10
    ([string]$id = invoke-restmethod -uri 'http://169.254.169.254/latest/meta-data/instance-id')
}

Rename-Computer -NewName $("${hostname}-$($id.Substring($id.Length-4,4))")

${params}

if (Test-Path ${bootstrap_dir}) {
  foreach ($d in $(Get-ChildItem ${bootstrap_dir} -Directory)) {
      foreach ($f in $(Get-ChildItem $d -File -Filter *.ps1)) {
          & $f.FullName
      }
  }
}

${custrom_script}

Restart-Computer -Force
</powershell>