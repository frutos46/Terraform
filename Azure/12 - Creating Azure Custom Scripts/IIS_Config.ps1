import-module servermanager
add-windowsfeature web-server -IncludeAllSubFeature
Add-WindowsFeature web-asp-net45
Add-WindowsFeature net-framework-features
$date=Get-Date
Set-Content -Path "C:\inetpub\wwwroot\Default.html" -Value "It works! $($date)"