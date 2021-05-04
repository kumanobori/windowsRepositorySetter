. ./RepositorySetter.ps1

$regKey = 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer'
$name = 'AltTabSettings'
$kind = 'DWord'
$value = 1
exec $regKey $name $kind $value
