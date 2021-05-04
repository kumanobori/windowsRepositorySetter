function exec ($aKey, $aName, $aKind, $aValue) {

	Write-Host 'aKey='$aKey', aName='$aName', aKind='$aKind', aValue='$aValue'.'
	
	# レジストリキーの存在確認
	If (!(Test-Path $aKey)) {
		Write-Host 'key not exixt.'
		exit(1)
	}
	
    # レジストリキーの取得	
    $key = Get-Item -Path $aKey
    
    # 値の取得とチェック
    $value = $key.getValue($aName, '')
    if ($value -eq '') {
        $alreadyExists = true
    } else {
        $alreadyExists = false
    }
    
    # 型の取得とチェック
    $kind = $key.getValueKind($aName)
    if ($alreadyExists -and $kind -ne $aKind) {
        Write-Host 'kind not match. expected='$aKind', actually='$kind'.'
        exit (1)
    }

    # 値の設定
    if ($alreadyExists) {
        Set-ItemProperty $aKey -name $aName -Value $aValue
    } else {
        New-ItemProperty -Path $aKey -Name $aName -Value $aValue
    }

	# 結果メッセージ
	Write-Host 'Target='$aKey
    Write-Host 'oldValue='$value
    Write-Host 'newvalue='$aValue
}

