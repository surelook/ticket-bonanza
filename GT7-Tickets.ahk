#Persistent
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

Global color_4star := 0xC8C8C8
Global color_cursor := 0xB4B4B4
Global pos_4starX := 62
Global pos_4starY := 78
Global pos_cursor_cafeX := 645
Global pos_cursor_cafeY := 383
Global pos_cursor_garageX := 864
Global pos_cursor_garageY := 404
Global pos_cursor_trophiesX := 866
Global pos_cursor_trophiesY := 640
Global pos_cursor_change_carX := 342
Global pos_cursor_change_carY := 668

; Menu
Menu, tray, Tip, Ticket Bonanza

; GUI
Gui, New, -MaximizeBox -Resize, Ticket Bonanza
Gui, Margin, 10, 10
Gui, Font, S10 c000000
; GUI: Credits
Gui, Add, Link, x5 y5 w300, <a href="https://discord.gg/CfppVp7VXV">Join our Discord server</a>
; GUI: Buttons
Gui, Add, Button, x12 w150 h40 Default gButtonTickets, Start
Gui, Add, Button, w150 h40 x+10 gGUIReset, Reset
Gui, Add, Button, w150 h40 x+10 gGUIClose, Exit
Gui, Show
Return

ButtonTickets:
gosub, GrabRemotePlay
Sleep(500)
loop {
	CheckCursor(pos_cursor_cafeX, pos_cursor_cafeY)
	Press_X()
	Sleep(3000)
	CheckCursor(pos_cursor_trophiesX, pos_cursor_trophiesY)
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
	CheckCursor(pos_cursor_cafeX, pos_cursor_cafeY)
	Press_Right()
	Press_X()
	Sleep(3000)
	CheckCursor(pos_cursor_change_carX, pos_cursor_change_carY)
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
	Sleep(3000)
	CheckCursor(pos_cursor_garageX, pos_cursor_garageY)
	Press_Left()
	Sleep(50)
	Press_X()
	Sleep(3000)
	CheckCursor(pos_cursor_trophiesX, pos_cursor_trophiesY)
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
	CheckCursor(pos_cursor_cafeX, pos_cursor_cafeY)
	Press_Right()
	Press_X()
	Sleep(3000)
	CheckCursor(pos_cursor_change_carX, pos_cursor_change_carY)
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
	Sleep(3000)
	CheckCursor(pos_cursor_garageX, pos_cursor_garageY)
	Press_Left()
}
Return


Check4Star(x,y, b_size := 1)
{	
	Sleep(13500)
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

CheckCursor(x,y, b_size := 1)
{	
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
WinMove, ahk_id %id%,,,, 1280, 750
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