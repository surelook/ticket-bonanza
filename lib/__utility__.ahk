/**********************************************
* Only place functions here, no sub routines  *
***********************************************/


; Grabs the colors of the pixels (x-b, y-b) to (x+b, y+b)
; returns the array of colors
*/

BitGrab(x, y, b)
{
    HWND := WinExist("PS Remote Play")
    pToken := Gdip_Startup()
    pBitmap := Gdip_BitmapFromHWND2(hwnd)

    pixs := []
    for i in range(-1*b, b+1){
        for j in range(-1*b, b+1){
            pixel := Gdip_GetPixel(pBitmap,x+i,y+j)
            rgb := ConvertARGB( pixel )
            pixs.Push(rgb)
        }
    }

    Gdip_DisposeImage(pBitmap)
    Gdip_Shutdown(pToken)
    return pixs
}

Gdip_BitmapFromHWND2(hwnd)
{
    WinGetPos,,, Width, Height, ahk_id %hwnd%
    hbm := CreateDIBSection(Width, Height), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
    RegExMatch(A_OsVersion, "\d+", Version)
    PrintWindow(hwnd, hdc, Version >= 8 ? 2 : 0)
    pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
    SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
    return pBitmap
}

range(start, stop:="", step:=1) {
	static range := { _NewEnum: Func("_RangeNewEnum") }
	if !step
		throw "range(): Parameter 'step' must not be 0 or blank"
	if (stop == "")
		stop := start, start := 0
	; Formula: r[i] := start + step*i ; r = range object, i = 0-based index
	; For a postive 'step', the constraints are i >= 0 and r[i] < stop
	; For a negative 'step', the constraints are i >= 0 and r[i] > stop
	; No result is returned if r[0] does not meet the value constraint
	if (step > 0 ? start < stop : start > stop) ;// start == start + step*0
		return { base: range, start: start, stop: stop, step: step }
}

_RangeNewEnum(r) {
	static enum := { "Next": Func("_RangeEnumNext") }
	return { base: enum, r: r, i: 0 }
}

_RangeEnumNext(enum, ByRef k, ByRef v:="") {
	stop := enum.r.stop, step := enum.r.step
	, k := enum.r.start + step*enum.i
	if (ret := step > 0 ? k < stop : k > stop)
		enum.i += 1
	return ret
}


Sleep(ms=1)
{
		global timeBeginPeriodHasAlreadyBeenCalled
		if (timeBeginPeriodHasAlreadyBeenCalled != 1)
		{
			DllCall("Winmm.dll\timeBeginPeriod", UInt, 1)
			timeBeginPeriodHasAlreadyBeenCalled := 1
		}

	DllCall("Sleep", UInt, ms)
}



PixelColorSimple(pc_x, pc_y)
{
    WinGet, remotePlay_id, List, ahk_exe RemotePlay.exe
    if (remotePlay_id = 0)
    {
        MsgBox, PS4 Remote Play not found
        return
    }
    if remotePlay_id
    {
        pc_wID := remotePlay_id[0]
        pc_hDC := DllCall("GetDC", "UInt", pc_wID)
        pc_fmtI := A_FormatInteger
        SetFormat, IntegerFast, Hex
        pc_c := DllCall("GetPixel", "UInt", pc_hDC, "Int", pc_x, "Int", pc_y, "UInt")
        pc_c := pc_c >> 16 & 0xff | pc_c & 0xff00 | (pc_c & 0xff) << 16
        pc_c .= ""
        SetFormat, IntegerFast, %pc_fmtI%
        DllCall("ReleaseDC", "UInt", pc_wID, "UInt", pc_hDC)
        return pc_c

    }
}

GetClientSize(hWnd, ByRef w := "", ByRef h := "")
{
    VarSetCapacity(rect, 16)
    DllCall("GetClientRect", "ptr", hWnd, "ptr", &rect)
    w := NumGet(rect, 8, "int")
    h := NumGet(rect, 12, "int")
}

Distance(c1, c2)
{ ; function by [VxE], return value range = [0, 441.67295593006372]
return Sqrt((((c1>>16)-(c2>>16))**2)+(((c1>>8&255)-(c2>>8&255))**2)+(((c1&255)-(c1&255))**2))
}

ConvertARGB(ARGB, Convert := 0)
{
    SetFormat, IntegerFast, Hex
    RGB += ARGB
    RGB := RGB & 0x00FFFFFF
    if (Convert)
        RGB := (RGB & 0xFF000000) | ((RGB & 0xFF0000) >> 16) | (RGB & 0x00FF00) | ((RGB & 0x0000FF) << 16)

    return RGB
}

ToolTipper(msg, x := 100, y := 100)
{
  if (debug_mode = 1)
    ToolTip, %msg%, x, y, Screen
  return
}
