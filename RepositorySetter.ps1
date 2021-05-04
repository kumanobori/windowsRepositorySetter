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
    if ($value -eq '') {
        $alreadyExists = true
    } else {
        $alreadyExists = false
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
}

