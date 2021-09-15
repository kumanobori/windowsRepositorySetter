# �J�����g�f�B���N�g�����X�N���v�g�̂���f�B���N�g���ɕύX����
# �i�X�N���v�g�������O��Ƃ��Ă��Ȃ��Ȃ�s�v�j
Set-Location -Path $PSScriptRoot

# �Ǘ��Ҍ����łȂ��ꍇ�A���݂̃X�N���v�g���Ǘ��Ҍ����Ŏ��s���Ď����͏I��
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    $commandPath = $PSCommandPath
    
    # �������A�Ǘ��Ҍ������s�p�ɍ�蒼��
    # �������A�N�H�[�g���ꂽ�󔒂��܂ޕ�����ł���ꍇ��z��B
    # �����܂ōl���Ȃ��ł����Ȃ�AStart-Process �� $argsToAdminProcess �̑����$Args�����Ă����Ȃ��B
    $argsToAdminProcess = ""
    $Args.ForEach{
        $argsToAdminProcess += " `"$PSItem`""
    }

    # ���s
    Start-Process powershell.exe "-File `"$commandPath`" $argsToAdminProcess"  -Verb RunAs
    exit
}




function exec ($aKey, $aName, $aKind, $aValue) {

	Write-Host 'aKey='$aKey', aName='$aName', aKind='$aKind', aValue='$aValue'.'
	
	# ���W�X�g���L�[�̑��݊m�F
	If (!(Test-Path $aKey)) {
		Write-Host 'key not exixt.'
		exit(1)
	}
	
    # ���W�X�g���L�[�̎擾	
    $key = Get-Item -Path $aKey
    
    # �l�̎擾�ƃ`�F�b�N
    $value = $key.getValue($aName, '')
    if ($value -ne '') {
        $alreadyExists = $TRUE
        Write-Host '$alreadyExists = true'
    } else {
        $alreadyExists = $FALSE
        Write-Host '$alreadyExists = false'
    }
    
    # �^�̎擾�ƃ`�F�b�N
    $kind = $key.getValueKind($aName)
    if ($alreadyExists -and $kind -ne $aKind) {
        Write-Host 'kind not match. expected='$aKind', actually='$kind'.'
        exit (1)
    }

    # �l�̐ݒ�
    if ($alreadyExists) {
        Set-ItemProperty $aKey -name $aName -Value $aValue
    } else {
        New-ItemProperty -Path $aKey -Name $aName -Value $aValue
    }

	# ���ʃ��b�Z�[�W
	Write-Host 'Target='$aKey
    Write-Host 'oldValue='$value
    Write-Host 'newvalue='$aValue
    
    pause
}

