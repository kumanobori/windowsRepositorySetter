. ./RepositorySetter.ps1

$regKey = 'Registry::HKEY_CURRENT_USER\Control Panel\Accessibility'
$name = 'MessageDuration'
$kind = 'DWord'
$value = 86400
exec $regKey $name $kind $value
