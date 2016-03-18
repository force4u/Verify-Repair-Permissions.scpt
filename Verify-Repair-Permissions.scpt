(*
Verify-Repair-Permissions.scpt
アクセス権の検証・修正をコマンドラインで行ないます
10.11のディスクユーティリティ対応

20160319　初回作成
20160319　設定項目を追加
*)

---設定項目
#１の場合はアップルスクリプト内で処理
#２の場合はターミナルを呼び出しての処理
#ターミナル処理の場合のキャンセル時に応答が無くなる場合があるため
#１を推奨
set numApplication to 1 as number
#


tell application "Finder"
	activate
	----選択用のリストを定義
	set listLngList to {"【検証】diskutil Verify(-10.10)", "【修復】diskutil Repair(-10.10)", "-------", "【検証】libexec Verify(10.11)", "【修復】libexec Repair(10.11)"} as list
	----リスト表示のダイアログを出します
	set thePermissionsAns to (choose from list listLngList with title "処理方法を選択" with prompt "アクセス権の検証・修復方法を選んでください" default items "【検証】libexec Verify(10.11)" without multiple selections allowed and empty selection allowed) as text
	----エラーよけ
	if thePermissionsAns is "-------" then
		return
	else if thePermissionsAns is "false" then
		return
	end if
end tell

---ダイアログの戻り値のリストをテキストに変換
set thePermissionsAns to thePermissionsAns as text
---処理の分岐
if thePermissionsAns is "【検証】diskutil Verify(-10.10)" then
	set theCmdText to "sudo diskutil verifyPermissions /" as text
else if thePermissionsAns is "【修復】diskutil Repair(-10.10)" then
	set theCmdText to "sudo diskutil repairPermissions /" as text
else if thePermissionsAns is "【検証】libexec Verify(10.11)" then
	set theCmdText to "sudo /usr/libexec/repair_packages --verify --standard-pkgs --volume /" as text
else if thePermissionsAns is "【修復】libexec Repair(10.11)" then
	set theCmdText to "sudo /usr/libexec/repair_packages --repair --standard-pkgs --volume /" as text
else
	return
end if


if numApplication is 1 then
	log "処理を開始します。処理が終わるまでしばらくお待ち下さい"
	do shell script theCmdText with administrator privileges
	log "処理が終了しました"
else if numApplication is 2 then
	
	---ターミナルでコマンドを開く
	tell application "Terminal" to launch
	
	tell application "Terminal"
		activate
		do script theCmdText
	end tell
else
	return
end if
