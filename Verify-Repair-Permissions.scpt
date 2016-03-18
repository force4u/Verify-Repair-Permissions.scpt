(*
Verify-Repair-Permissions.scpt
アクセス権の検証・修正をコマンドラインで行ないます
10.11のディスクユーティリティ対応

20160319　初回作成



*)
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

---ターミナルでコマンドを開く
tell application "Terminal"
	launch
	activate
	do script theCmdText
end tell

