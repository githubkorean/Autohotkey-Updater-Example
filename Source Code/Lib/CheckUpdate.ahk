CheckUpdate(Url:="",Version:=0)
{
  Return:=[]
  VersionUrl:="https://github.com/"RegExReplace(Url "/tree/main","(.*)github.com/|/tree/main(.*)")"/raw/main/Version.txt"
  ComObjError(0)
  WinHttp:=ComObjCreate("WinHTTP.WinHTTPRequest.5.1")
  WinHttp.Open("GET",VersionUrl)
  WinHttp.Send()
  LastVersion:=Trim(WinHttp.ResponseText,"`n")
  if LastVersion is not number
  {
    MsgBox 4112,오류,버전이 잘못 되었거나`, 버전을 가져올 수 없음.,1
    ExitApp
  }
  Return.Push(Trim(WinHttp.ResponseText,"`n")>Version,"https://github.com/"RegExReplace(Url "/tree/main","(.*)github.com/|/tree/main(.*)")"/raw/main/Update/"LastVersion ".exe")
  Return Return
}