. ./RepositorySetter.ps1

$regKey = 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\238C9FA8-0AAD-41ED-83F4-97BE242C8F20\7bc4a2f9-d8fc-4469-b07b-33eb785aaca0'
$name = 'Attributes'
$kind = 'DWord'
$value = 2
exec $regKey $name $kind $value
