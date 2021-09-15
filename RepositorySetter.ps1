# カレントディレクトリをスクリプトのあるディレクトリに変更する
# （スクリプトがそれを前提としていないなら不要）
Set-Location -Path $PSScriptRoot

# 管理者権限でない場合、現在のスクリプトを管理者権限で実行して自分は終了
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    $commandPath = $PSCommandPath
    
    # 引数を、管理者権限実行用に作り直す
    # 引数が、クォートされた空白を含む文字列である場合を想定。
    # そこまで考えないでいいなら、Start-Process の $argsToAdminProcess の代わりに$Argsを入れても問題ない。
    $argsToAdminProcess = ""
    $Args.ForEach{
        $argsToAdminProcess += " `"$PSItem`""
    }

    # 実行
    Start-Process powershell.exe "-File `"$commandPath`" $argsToAdminProcess"  -Verb RunAs
    exit
}




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
    if ($value -ne '') {
        $alreadyExists = $TRUE
        Write-Host '$alreadyExists = true'
    } else {
        $alreadyExists = $FALSE
        Write-Host '$alreadyExists = false'
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
    
    pause
}

