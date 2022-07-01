﻿#Persistent
#NoEnv
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
#SingleInstance force
#Include Lib\Gdip.ahk
#Include Lib\AHK-ViGEm-Bus.ahk
#Include Lib\__utility__.ahk
#Include Lib\__controller_functions__.ahk


hModule := DllCall("LoadLibrary", "Str", A_LineFile "\..\Lib\SuperSleep.dll", "Ptr")
SuperSleep := DllCall("GetProcAddress", "Ptr", DllCall("GetModuleHandle", "Str", A_LineFile "\..\Lib\SuperSleep.dll", "Ptr"), "AStr", "super_sleep", "Ptr")

ListLines Off
Process, Priority, , A
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SendMode Input

SetWorkingDir %A_ScriptDir%
DetectHiddenWindows, Off

Global controller := new ViGEmDS4()
Global script_start := A_TickCount
Global color_4star := 0xC7C7C7
Global color_menu := 0x6C5826
Global color_cursor := 0xB5B5B5
Global pos_4starX := 63
Global pos_4starY := 244
Global pos_menuX := 334
Global pos_menuY := 222
Global pos_cursor_cafeX := 644
Global pos_cursor_cafeY := 524
Global pos_cursor_garageX := 867
Global pos_cursor_garageY := 538

;- GUI 1 (MAIN) -------------------------------------------------------------------------------------------------
Icon = %A_ScriptDir%\Assets\GT7_Tokyo.ico
Menu, Tray, Icon, %Icon%
Gui, -Caption
Gui, Add, Picture, x0 y0, %A_ScriptDir%\Assets\LEA_gui.png
Gui, Add, Button, x278 y120 w80 h50 default gButtonTickets, Tickets
Gui, Add, Button, x278 y195 w80 h20 default gGUIReset, Reset
Gui, Add, Button, x531 y195 w101 h20 default gGUIClose, Exit
Gui, Show, x1274 y791 h225 w640, GT7 LEA // by problemz
Return

ButtonTickets:
gosub, GrabRemotePlay
Sleep(500)
loop {
Press_X()
CheckMenu(pos_menuX, pos_menuY)
Sleep(1000)
Press_Left()
Press_X()	
Press_Down()
Press_Right()
Press_X()
Press_Up()
Sleep(800)
Press_X()
Sleep(800)
Press_X()
Sleep(800)
Press_O()
Sleep(200)
Press_O()
Sleep(200)
Press_O()
Sleep(3000)
CheckMenu(pos_menuX, pos_menuY)
CheckCursor(pos_cursor_cafeX, pos_cursor_cafeY)
Press_Right()
Press_X()
CheckMenu(pos_menuX, pos_menuY)
Sleep(800)
Press_Right()
Sleep(50)
Press_Right()
Sleep(50)
Press_Right()
Press_X()
Sleep(50)
Press_X()
Sleep(50)
Press_X()
Check4Star(pos_4starX, pos_4starY)
Sleep(400)
Press_O()
Sleep(50)
Press_O()
Sleep(50)
Press_O()
CheckMenu(pos_menuX, pos_menuY)
CheckCursor(pos_cursor_garageX, pos_cursor_garageY)
Sleep(400)
Press_Left()
Sleep(50)
Press_X()
CheckMenu(pos_menuX, pos_menuY)
Sleep(1000)
Press_Left()
Press_X()	
Press_Down()
Press_Right()
Press_X()
Press_Up()
Sleep(800)
Press_Right()
Sleep(400)
Press_Right()
Sleep(400)
Press_X()
Sleep(800)
Press_X()
Sleep(800)
Press_O()
Sleep(200)
Press_O()
Sleep(200)
Press_O()
Sleep(3000)
CheckMenu(pos_menuX, pos_menuY)
CheckCursor(pos_cursor_cafeX, pos_cursor_cafeY)
Sleep(400)
Press_Right()
Press_X()
CheckMenu(pos_menuX, pos_menuY)
Sleep(800)
Press_Right()
Sleep(50)
Press_Right()
Sleep(50)
Press_Right()
Press_X()
Sleep(50)
Press_X()
Sleep(50)
Press_X()
Check4Star(pos_4starX, pos_4starY)
Sleep(400)
Press_O()
Sleep(50)
Press_O()
Sleep(50)
Press_O()
CheckMenu(pos_menuX, pos_menuY)
CheckCursor(pos_cursor_garageX, pos_cursor_garageY)
Sleep(400)
Press_Left()
Sleep(1000)
}
Return


Check4Star(x,y, b_size := 1)
{	
	Sleep(2500)
    4StarComplete := false
    loop 
	{
		tc := BitGrab(x, y, b_size)
		for 	i, c in tc
		{
			td := Distance(c, color_4star)
			if (td < 10 )
			{
				4StarComplete := true
				break
			}
		}
	Sleep(500)
	Press_X()
    } until 4StarComplete = true
    return
}

CheckMenu(x,y, b_size := 1)
{	
    Sleep(3000)
    MenuComplete := false
    loop 
	{
		tc := BitGrab(x, y, b_size)
		for 	i, c in tc
		{
			td := Distance(c, color_menu)
			if (td < 10 )
			{
				MenuComplete := true
				break
			}
		}
    } until MenuComplete = true
    return
}

CheckCursor(x,y, b_size := 1)
{	
    Sleep(500)
    CursorComplete := false
    loop 
	{
		tc := BitGrab(x, y, b_size)
		for 	i, c in tc
		{
			td := Distance(c, color_cursor)
			if (td < 10 )
			{
				CursorComplete := true
				break
			}
		}
    } until CursorComplete = true
	Sleep(500)
    return
}

GrabRemotePlay:
WinGet, remotePlay_id, List, ahk_exe RemotePlay.exe
if (remotePlay_id = 0)
{
	MsgBox, PS4 Remote Play not found
	return
}
Loop, %remotePlay_id%
{
	id := remotePlay_id%A_Index%
	WinGetTitle, title, % "ahk_id " id
	If InStr(title, "PS Remote Play")
	break
}
WinMove, ahk_id %id%,, 0, 0, 1280, 1024 
WinMove, GT7 LEA // by problemz,, 1274, 791 
ControlFocus,, ahk_class %remotePlay_class%
WinActivate, ahk_id %id%
return

PauseLoop:
controller.Buttons.Cross.SetState(false)
controller.Buttons.Square.SetState(false)
controller.Buttons.Triangle.SetState(false)
controller.Buttons.Circle.SetState(false)
controller.Buttons.L1.SetState(false)
controller.Buttons.L2.SetState(false)
controller.Axes.L2.SetState(0)
controller.Buttons.R1.SetState(false)
controller.Buttons.R2.SetState(false)
controller.Axes.R2.SetState(0)
controller.Buttons.RS.SetState(false)
controller.Axes.RX.SetState(50)
controller.Axes.RY.SetState(50)
controller.Buttons.LS.SetState(false)
controller.Axes.LX.SetState(50)
controller.Axes.LY.SetState(50)
controller.Dpad.SetState("None")
return

MouseHelp:
coord=relative
sleep, 1000
CoordMode, ToolTip, %coord%
CoordMode, Pixel, %coord%
CoordMode, Mouse, %coord%
CoordMode, Caret, %coord%
CoordMode, Menu, %coord%
return

Refresh:
MouseGetPos, x, y
PixelGetColor, cBGR, %x%, %y%,, Alt RGB
WinGetPos,,, w, h, A
ToolTip,Location: %x% x %y%`nRGB: %cBGR%`nWindow Size: %w% x %h%
return

MouseColor:
gosub, MouseHelp
SetTimer, Refresh, 75
return

GuiClose:
gosub, PauseLoop
ExitApp
^Esc::ExitApp

GUIReset:

Sleep(500)
gosub, PauseLoop
Reload
return