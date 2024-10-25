IfEqual A_IsCompiled,,Run %A_ScriptDir%\Compiler\Ahk2Exe.exe /in "%A_ScriptFullPath%" /icon Compiler\ico.ico
IfEqual A_IsCompiled,,ExitApp
#NoTrayIcon
#SingleInstance Force
Loop % A_Args.MaxIndex()
Param.="|"A_Args[A_Index]
IfEqual Param,,MsgBox 4112,오류,업데이트 실패.
IfEqual Param,,ExitApp
Param:=Trim(Param,"|")
Path:=RegExReplace(Param,"(.*)Path: |\|(.*)")
Loop 1000000
{
  If(!FileExist(Path))
  Break
}
MsgBox 4160,알림,잠시 후`, 업데이트를 시작합니다.,1
DownloadUrl:=RegExReplace(Param,"(.*)DownloadUrl: |\|(.*)")
Download(DownloadUrl,Path,1)
Download(UrlToFile,_SaveFileAs,Overwrite:=False,UseProgressBar:=True)
{
;Check if the user wants a progressbar
If(UseProgressBar)
{
	;Make variables global that we need later when creating a timer
	SaveFileAs:=_SaveFileAs
	;Initialize the WinHttpRequest Object
	ComObjError(0)
	WebRequest:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	;Download the headers
	WebRequest.Open("HEAD",UrlToFile)
	WebRequest.Send()
	;Store the header which holds the file size in a variable:
	FinalSize:=WebRequest.GetResponseHeader("Content-Length")
	Progress,H80,,다운로드 시작,%UrlToFile% Download
	SetTimer,DownloadFileFunction_UpdateProgressBar,100
}
;Download the file
If(!InStr(_SaveFileAs,":"))
_SaveFileAs:=A_ScriptDir "/"_SaveFileAs
If(!Overwrite)&&(FileExist(_SaveFileAs))
Return
UrlDownloadToFile,%UrlToFile%,%_SaveFileAs%
;Remove the timer and the progressbar  because the download has finished
If(UseProgressBar)
{
	Progress,Off
	SetTimer,DownloadFileFunction_UpdateProgressBar,Off
}
Return

DownloadFileFunction_UpdateProgressBar:
	;Get the current filesize and tick
	CurrentSize:=FileOpen(_SaveFileAs,"r").Length ;FileGetSize wouldn't Return reliable results
	CurrentSizeTick:=A_TickCount
	;Calculate the downloadspeed
	Speed:=Round((CurrentSize/1024-LastSize/1024)/((CurrentSizeTick-LastSizeTick)/1000)) . " Kb/s"
	;Save the current filesize and tick for the next time
	LastSizeTick:=CurrentSizeTick
	LastSize:=FileOpen(_SaveFileAs,"r").Length
	;Calculate percent done
	PercentDone:=Round(CurrentSize/FinalSize*100)
	;Update the ProgressBar
	Progress,%PercentDone%,다운로드중...,% "[속도 : "Speed "] [경과 : "PercentDone "%]",다운로더
	Return
}