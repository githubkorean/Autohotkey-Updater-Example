IfEqual A_IsCompiled,,Run %A_ScriptDir%\Compiler\Ahk2Exe.exe /in "%A_ScriptFullPath%" /icon Compiler\ico.ico
IfEqual A_IsCompiled,,ExitApp
#NoTrayIcon
#SingleInstance Force
#Include Lib\CheckUpdate.ahk
Version:=0.1
CheckUpdate:=CheckUpdate("https://github.com/githubkorean/Autohotkey-Updater-Example/tree/main",Version)
If(CheckUpdate[1])
{
  FileInstall Updater.exe,% A_Temp "\"A_Now ".exe",1
  Run % A_Temp "\"A_Now ".exe ""Path: "A_ScriptFullPath """ ""DownloadUrl: "CheckUpdate[2] ""
  Run % "cmd /c ping localhost -n 2 > nul && del """ A_ScriptFullPath """", , Hide|UseErrorLevel
  ExitApp
}
MsgBox 4160,Version,최신 버전입니다.