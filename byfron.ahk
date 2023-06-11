; Tower Defense macro by Escuminac#1856
; byfron v1.01

#SingleInstance Force
#MaxThreads 7
#Requires AutoHotkey >=1.1.36.01 <=1.2 
#NoEnv
#KeyHistory 0
#Include %A_ScriptDir%\sub\Gdip_all.ahk

SetBatchLines, -1
SetDefaultMouseSpeed, 3
CoordMode, Pixel, Client
CoordMode, Mouse, Client

; zez 32 bit run
RunWith(32)

; global defaults
global webhookLink := "DiscordWebhook:"
global privateServerLink := "RobloxPrivateServer:"
global chosenWave := 29
global alwaysOnTop := 1
global webhooksEnabled := 1
global webhooksScreenshots := 1
global robloxPremium := 0
global robloxCrackersGamepass := 0
global runTime := 0
global startTime := A_NowUTC
global saveX := 548
global saveY := 544
global openCrates := 0
global GuiTheme := "MacLion3"
global carbonX := 548
global carbonY := 544

; configuration 

; creates default config.ini file
if !FileExist(A_ScriptDir "\settings\config.ini") {
	FileAppend, 
(
[Links]
settings_webhookLink=DiscordWebhook:
settings_privateServerLink=RobloxPrivateServer:

[Preferences]
settings_chosenWave=29
settings_alwaysOnTop=1
settings_webhooksEnabled=1
settings_webhooksScreenshot=1
settings_openCrates=0
settings_GuiTheme=MacLion3

[Stats]
settings_robloxPremium=0
settings_robloxCrackersGamepass=0
settings_runTime=0
settings_saveX=548
settings_saveY=544
settings_carbonX=548
settings_carbonY=544
), %A_ScriptDir%\settings\config.ini
}



; updates globals based on provided values in config.ini
byf_updateGlobals() {
	IniRead, webhookLink, %A_ScriptDir%\settings\config.ini, Links, settings_webhookLink
	IniRead, privateServerLink, %A_ScriptDir%\settings\config.ini, Links, settings_privateServerLink
	IniRead, chosenWave, %A_ScriptDir%\settings\config.ini, Preferences, settings_chosenWave
	IniRead, alwaysOnTop, %A_ScriptDir%\settings\config.ini, Preferences, settings_alwaysOnTop
	IniRead, webhooksEnabled, %A_ScriptDir%\settings\config.ini, Preferences, settings_webhooksEnabled
	IniRead, webhooksScreenshots, %A_ScriptDir%\settings\config.ini, Preferences, settings_webhooksScreenshots
	IniRead, openCrates, %A_ScriptDir%\settings\config.ini, Preferences, settings_openCrates
	IniRead, GuiTheme, %A_ScriptDir%\settings\config.ini, Preferences, settings_GuiTheme
	IniRead, robloxPremium, %A_ScriptDir%\settings\config.ini, Stats, settings_robloxPremium
	IniRead, robloxCrackersGamepass, %A_ScriptDir%\settings\config.ini, Stats, settings_robloxCrackersGamepass
	IniRead, runTime, %A_ScriptDir%\settings\config.ini, Stats, settings_runTime
	IniRead, saveX, %A_ScriptDir%\settings\config.ini, Stats, settings_saveX
	IniRead, saveY, %A_ScriptDir%\settings\config.ini, Stats, settings_saveY
	IniRead, carbonX, %A_ScriptDir%\settings\config.ini, Stats, settings_carbonX
	IniRead, carbonY, %A_ScriptDir%\settings\config.ini, Stats, settings_carbonY
	
}

; saves globals persistently to config.ini
byf_updateConfig() {
	Gui Submit, NoHide
	IniWrite, %webhookLink%, %A_ScriptDir%\settings\config.ini, Links, settings_webhookLink
	IniWrite, %privateServerLink%, %A_ScriptDir%\settings\config.ini, Links, settings_privateServerLink
	IniWrite, %chosenWave%, %A_ScriptDir%\settings\config.ini, Preferences, settings_chosenWave
	IniWrite, %alwaysOnTop%, %A_ScriptDir%\settings\config.ini, Preferences, settings_alwaysOnTop
	IniWrite, %openCrates%, %A_ScriptDir%\settings\config.ini, Preferences, settings_openCrates
	IniWrite, %GuiTheme%, %A_ScriptDir%\settings\config.ini, Preferences, settings_GuiTheme
	IniWrite, %robloxPremium%, %A_ScriptDir%\settings\config.ini, Stats, settings_robloxPremium
	IniWrite, %robloxCrackersGamepass%, %A_ScriptDir%\settings\config.ini, Stats, settings_robloxCrackersGamepass
	IniWrite, %runTime%, %A_ScriptDir%\settings\config.ini, Stats, settings_runTime
	IniWrite, %saveX%, %A_ScriptDir%\settings\config.ini, Stats, settings_saveX
	IniWrite, %saveY%, %A_ScriptDir%\settings\config.ini, Stats, settings_saveY
	IniWrite, %carbonX%, %A_ScriptDir%\settings\config.ini, Stats, settings_carbonX
	IniWrite, %carbonY%, %A_ScriptDir%\settings\config.ini, Stats, settings_carbonY
}

; tray settings
byf_traySettings() {
	Menu, Tray, NoStandard
	Menu, Tray, Add, Start Macro, Start
	Menu, Tray, Add, Pause Macro, Stop
	Menu, Tray, Add, End Macro, End
	Menu, Tray, Add
	Menu, Tray, Add, Suspend Hotkeys, byf_noHotkeys
	Menu, Tray, Add
	Menu, Tray, Add, Open Logs, byf_openLogs

}

; disables all Hotkeys
byf_noHotkeys() {
	Menu, Tray, ToggleCheck, Suspend Hotkeys
	Suspend
}

; opens logs
byf_openLogs() {
	ListLines
}

; Gui
Menu, Tray, Icon, %A_ScriptDir%\settings\images\buo.ico
Menu, Tray, Tip, byfron
byf_updateGlobals()
OnExit("byf_exit")
SkinForm("Apply", A_ScriptDir . "\settings\styles\USkin.dll", A_ScriptDir . "\settings\styles\" . GuiTheme . ".msstyles")

Gui +Border +OwnDialogs
If (AlwaysOnTop) {
	Gui +AlwaysOnTop
}
Gui Font, s7 cDefault Norm, Tahoma
Gui Font, w700
Gui Add, Statusbar, x15 y75 w10 h60 BackgroundTrans,Status: Idle
Gui Add, Tab3, x0 y0 w255 h150 -Wrap, Status||Settings|Misc|Configuration
Gui Tab, 1
Gui Add, Button, gEnd x180 y96 w60 h21, End (F3)
Gui Add, Button, gStop x100 y96 w60 h21, Pause (F2)
Gui Add, Button, gStart x20 y96 w60 h21, Start (F1)
Gui Add, Text, x21 y65 w39 h14 , Wave:
Gui Add, Text, x201 y25 w39 h14 , v1.01
Gui Add, Text, x21 y29 w99 h14 , Escuminac#1856
Gui Add, Edit, vchosenWave x62 y65 w69 h14 +0x2000, %chosenWave%
Gui Add, UpDown, Range20-30 Wrap 0x100, %chosenWave%
Gui Tab, 2
Gui Add, Edit, vprivateServerLink x25 y25 w200 h14, %privateServerLink%
If (AlwaysOnTop) {
	Gui Add, CheckBox, valwaysOnTop -Wrap y110 x23 Checked, Always on top
} else {
	Gui Add, CheckBox, valwaysOnTop -Wrap y110 x23, Always on top
}
If (webhooksEnabled) {
	Gui Add, Edit, vwebhookLink x25 y45 w200 h14, %webhookLink%
	Gui Add, CheckBox, vwebhooksEnabled -Wrap y90 x23 Checked, Webhook Enabled
} else {
	Gui Add, CheckBox, vwebhooksEnabled -Wrap y90 x23, Webhook Enabled
}
If (webhooksScreenshots) {
	Gui Add, CheckBox, vwebhooksScreenshots -Wrap y70 x23 Checked, Webhook Screenshots
} else {
	Gui Add, CheckBox, vwebhooksScreenshots -Wrap y70 x23, Webhook Screenshots
}
Gui Add, Button, gOpenCrateMenu x150 y96 w90 h21, Open Crates
Gui Tab, 3
Gui Add, Text, x20 y30 w150 h31, Hourly stats: (F4)
Gui Add, Text, x20 y43 w150 h31, End macro: (F3)
Gui Add, Text, x20 y56 w150 h31, Pause macro: (F2)
Gui Add, Text, x20 y69 w150 h31, Start: (F1)
Gui Add, Button, gChangeLog x160 y30 w60 h21, Read me
Gui Add, Button, gReadMe x160 y60 w60 h21, Change log
Gui Add, Button, gResetConfiguration x20 y96 w110 h21, Reset all settings?
Gui Tab, 4
Gui Add, Text, x21 y30 w150 h31
If (robloxPremium) {
	Gui Add, CheckBox, gPayToWin vrobloxPremium -Wrap y54 x20 Checked, Roblox Premium
} else {
	Gui Add, CheckBox, gPayToWin vrobloxPremium -Wrap y54 x20, Roblox Premium
}
If (robloxCrackersGamepass) {
	Gui Add, CheckBox, gPayToWin vrobloxCrackersGamepass -Wrap y74 x20 Checked, Crackers Gamepass
} else {
	Gui Add, CheckBox, gPayToWin vrobloxCrackersGamepass -Wrap y74 x20, Crackers Gamepass
}
Gui, Add, DropDownList, x150 y56 w90 h100 vGuiTheme gGuiSelect, %GuiTheme%||Ayofe|BluePaper|Concaved|Core|Cosmo|Fanta|GrayGray|Hana|Invoice|Lakrits|Luminous|MacLion3|Minimal|Museo|Panther|PaperAGV|Relapse|SNAS|Stomp|Woodwork
; imagine not using MacLion3 :skull:
Gui Add, Button, gFirstTime x20 y96 w130 h21, First Time Using?

byf_updateRunTime()
byf_traySettings()
Gui Show, w250 h150 x1100 y60, byfron
SkinForm(0)
Return

; disables and activates parts of gui during playback
byf_activeGui() {
	Control, TabLeft , 1, SysTabControl321,
	GuiControl, Disable, Edit1
	GuiControl, Disable, Edit2
	GuiControl, Disable, Edit3
	GuiControl, Disable, msctls_dropdown321
	GuiControl, Disable, Button4
	GuiControl, Disable, Button5
	GuiControl, Disable, Button6
	GuiControl, Disable, Button7
	GuiControl, Disable, Button8
	GuiControl, Disable, Button9
	GuiControl, Disable, Button10
	GuiControl, Disable, ComboBox1
}

; checks if user has changed any settings, reloading if true
byf_reloadGui() {
	Gui Submit, NoHide
	; checks if any global variable is different from the one in "config.ini", reloading the script if true
	globalVarsToCheck := ["webhooksScreenshots", "GuiTheme", "webhooksEnabled", "alwaysOnTop", "chosenWave"]
	For each, globalName in globalVarsToCheck {
		keyToCheck := "settings_" globalName
		globalValue := %globalName%
		IniRead, valueToCompare, %A_ScriptDir%\settings\config.ini, Preferences, %keyToCheck%
		If (valueToCompare != globalValue)  {
			MsgBox, 0, byfron, Restarting macro to use new setting "%globalValue%" for  "%globalName%"
			byf_updateConfig()
			Reload
		} 
		
	}
	byf_activeGui()
}

; functions

byf_restComputer() {
	byf_statusLog("Resting Computer - 10 minutes")
	PostMessage, 0x0112, 0xF060,,, ahk_exe RobloxPlayerBeta.exe
	Sleep, 690000
	byf_statusLog("Resting period complete")
	byf_reconnect()
}

; Reconnects when disconnected to your private server, or a public server after 5 attempts
byf_reconnect() {
	byf_activeGui()
	byf_screenAndSend()
	byf_statusLog("Disconnected")
	Loop, 30 {
		If WinExist("ahk_exe RobloxPlayerBeta.exe") {
			PostMessage, 0x0112, 0xF060,,, ahk_exe RobloxPlayerBeta.exe
		}
		Loop, 5 {
			If WinExist("ahk_exe Brave.exe") {
				WinKill, ahk_exe Brave.exe
				Sleep, 100
			}
		}
		Sleep, 1690
		Switch A_Index {
		Case 1,2,3,4,5,6,7,8,9,10:
			Run, %privateServerLink%

		Case 11,12,13:
			Run, https://www.roblox.com/games/5607971791?privateServerLinkCode=54397873328437975393589031030159
		Case 14,15,16:
			Run, https://www.roblox.com/games/5607971791?privateServerLinkCode=36698095266676358438022701075605
		Default:		
			Run, https://www.roblox.com/games/5607971791?privateServerLinkCode=86576672776104755661966528358833 
		}
		Sleep, 1420
		WinActivate, ahk_exe Brave.exe
		Loop, 400 {
			byf_clickError()
			Sleep, 500
			If WinExist("ahk_exe RobloxPlayerBeta.exe") {
				WinActivate, ahk_exe RobloxPlayerBeta.exe
				If (byf_CheckConnection(false)) {
					byf_screenAndSend()
					byf_statusLog("Reconnection Confirmed" %A_Index%)
					Sleep, 45000
					WinActivate, ahk_exe RobloxPlayerBeta.exe
					Send v
					Sleep, 2500
					ImageSearch, redX, redY, 0, 0, A_ScreenWidth, A_ScreenHeight, *90 %A_ScriptDir%\settings\images\redteam.png
					If (ErrorLevel == 0) {
						MouseMove, redX, redY, 8
						Click, Left
						Sleep, 2000
					} else {
						Return byf_reconnect()
					}
					ImageSearch, joinTeamX, joinTeamY, 0, 0, A_ScreenWidth, A_ScreenHeight, *90 %A_ScriptDir%\settings\images\jointeam.png
					If (ErrorLevel == 0) {
						MouseMove, joinTeamX, joinTeamY, 8
						Click, Left
						Sleep, 2000
					} 
					byf_closeMenus()
					Sleep, 2500
					Send c
					Sleep, 2500
					MouseMove, saveX, saveY, 8
					Click, Left
					Sleep, 2000
					ImageSearch, loadsavesX, loadsavesY, 0, 0, A_ScreenWidth, A_ScreenHeight, *90 %A_ScriptDir%\settings\images\loadsave.png
					If (ErrorLevel == 0) {
						MouseMove, loadsavesX, loadsavesY, 8
						Click, Left
						Sleep, 2000
					} else {
						Return byf_reconnect()
					}
					byf_closeMenus()
					byf_statusLog("Reconnection finished")
					byf_screenAndSend()
					MouseMove, 1000, 300, 8
					Send {Text} /:weary: byfron pro [%A_Hour%:%A_Min%] `n
					Return 	
				} 
			}
		}
	}	
}

;clicks error buttons
byf_clickError() {
	ImageSearch, erroryesX, erroryesY, 0, 0, A_ScreenWidth, A_ScreenHeight, *78 settings\images\erroryes.png
	If (ErrorLevel == 0) {
		MouseMove, erroryesX, erroryesY
		Click, Left
	}
}


; checks if you're connected to tower defense 
byf_checkConnection(reconnectTrue := True) {
	If !WinExist("ahk_exe RobloxPlayerBeta.exe") {
		Return byf_reconnect()
	} else {
		WinActivate, ahk_exe RobloxPlayerBeta.exe
		Sleep, 10
	}
	ImageSearch,,, 0, 0, A_ScreenWidth//2, A_ScreenHeight, *82 %A_ScriptDir%\settings\images\savesMenuButton.png
	If (ErrorLevel == 0) {
		Return True
	} 
	ImageSearch,,, 0, 0, A_ScreenWidth, A_ScreenHeight, *60 %A_ScriptDir%\settings\images\discon.png
	If (ErrorLevel == 0) {
		If (reconnectTrue) {
			Return byf_reconnect()
		} else {
			Return False
		}
	} 
	ImageSearch,,, 0, 0, A_ScreenWidth//2, A_ScreenHeight, *82 %A_ScriptDir%\settings\images\connected.png
	If (ErrorLevel == 0) {
		Return True
	} else {
		If (reconnectTrue) {
			Return byf_reconnect()
		} else {
			Return False
		}
	}
}

; opens a lunchbox
byf_openCrateCF() {
	If !(openCrates) {
		Return
	}
	Send z
	Sleep, 2000
	MouseMove, saveX, saveY
	Click, Left
	Sleep, 500
	SendInput {WheelUp 1}
	Sleep, 1600
	SendInput {WheelDown 1}
	Sleep, 1600
	MouseMove, carbonX, carbonY, 8
	Click, Left
	Sleep, 1690
	ImageSearch, openX, openY, 0, 0, A_ScreenWidth, A_ScreenHeight, *90 %A_ScriptDir%\settings\images\open.png
	If (ErrorLevel == 0) {
		MouseMove, openX, openY, 8
		Click, Left
	} 
	Loop, 28 {
		Click, Left
		Sleep, 144
	}
	byf_screenAndSend()
	byf_statusLog("Lunchbox opened")
	byf_closeMenus()

}

; logs the status to your webhook and updates the Gui statusbar
byf_statusLog(status) {
	If !(webhooksEnabled) {
		Return False
	}
	SB_SetText("Status: " status)
	postdata=
(
{
  "embeds": [
    {
      "description": "%status% [%A_Hour%:%A_Min%:%A_Sec%]",
      "color": 8280002
      
     
        
      
    }
  ]
}
) 
	Try {
		WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		WebRequest.Open("POST", webhookLink, false)
		WebRequest.SetRequestHeader("Content-Type", "application/json")
		WebRequest.Send(postdata)
	}
}

; sends a screenshot of your screen to the webhook
byf_screenAndSend() {
	If !(webhooksScreenshots) or !(webhooksEnabled) {
		Return
	}
	Try {
		Screen()
		ImageSend()
		FileDelete, %A_ScriptDir%\screen.png
	}
}

; primary function for farming waves
byf_farmWaves() {
	byf_activeGui()
	byf_releaseAll()
	byf_statusLog("Farming Started")
	byf_screenAndSend()
	Loop, 210 {
		byf_checkConnection()
		byf_startWave()
	}
	byf_statusLog("Farming Ended")
}

; starts the chosen wave
byf_startWave() {
	MouseMove, 1000, 300, 3
	Send, b
	Sleep, 300
	Loop, 5 {
		ImageSearch, waveX, waveY, 0, 0, A_ScreenWidth, A_ScreenHeight//2, *82 %A_ScriptDir%\settings\images\wave%chosenWave%.png
		If (ErrorLevel == 0) {
			MouseMove, waveX, waveY, 3
			Sleep, 120
			Click, Left
			Sleep, 150
			Click, Left
		}
		ImageSearch, waveX, waveY, 0, 0, A_ScreenWidth, A_ScreenHeight//2, *82 %A_ScriptDir%\settings\images\wave%chosenWave%.png
		If (ErrorLevel == 0) {
			MouseMove, waveX, waveY, 3
			Sleep, 120
			Click, Left
			Sleep, 150
			Click, Left
		}
		Sleep, 69
	}
}

; closes menu if open
byf_closeMenus() {
	Sleep, 500
	Send b 
	Sleep, 500
	Send b
}

; calculates hourly crackers, based on time spent on a specific wave
byf_hourlyStats() {
	WinActivate, Roblox ahk_exe RobloxPlayerBeta.exe
	Loop, 10 {
		Send, b
		Sleep, 690
		ImageSearch, waveX, waveY, 0, 0, A_ScreenWidth, A_ScreenHeight//2, *82 %A_ScriptDir%\settings\images\wave%chosenWave%.png
		If (ErrorLevel == 0) {
			MouseMove, waveX, waveY
			Click, Left
			hourlyStart := A_NowUTC
			byf_statusLog("Wave " chosenWave " started")
			Sleep, 3600
			Break
		}
	}
	Loop, 6969 {
		ImageSearch,,, 0, 0, A_ScreenWidth, A_ScreenHeight, *90 %A_ScriptDir%\settings\images\waveend.png
		If (ErrorLevel != 0) {
			hourlyEnd := A_NowUTC
			byf_statusLog("Wave finished, calculating hourly")
			Break
		}
	} 
	EnvSub, hourlyEnd, hourlyStart, Seconds
	hourlyEnd -= 0.2
	wavesHour := Round(3600 / hourlyEnd)
	modifiersCrackers := 1
	if (robloxPremium) {
		modifiersCrackers *= 1.15
	}
	if (robloxCrackersGamepass) {
		modifiersCrackers *= 1.5
	}
	crackersPerWave := {20: 0.73, 21: 0.8, 22: 0.88, 23: 0.97, 24: 1.07, 25:1.18, 26: 1.3, 27: 1.43, 28: 1.57, 29: 1.73, 30: 1.9}
	wavesCracker := crackersPerWave[chosenWave]
	crackersHour := ((wavesHour * wavesCracker) * modifiersCrackers)
	byf_statusLog("**Hourly Crackers**\nTotal Hourly: " crackersHour "\nWave " chosenWave " in " hourlyEnd " seconds")
	SB_SetText("Status: Hourly stats finished")
	MsgBox Hourly Crackers: %crackersHour% `nTime: %hourlyEnd%
}

; releases all held keys / mouse
byf_releaseAll() {
	For k, keyName in ["w","a","s","d","/","b"] {
		Send, {%keyName% up}
	}
	Click, Up
}

; calculates total runtime of byfron, and updates the global runTime
byf_updateRunTime() {
	CurTime := A_NowUTC
	EnvSub, CurTime, startTime, Minutes
	startTime := A_NowUTC
	runTime := (runTime + CurTime)
	byf_updateConfig()
	GuiControl, text, Static8, Total run time: %runTime% minutes
}

; exit function
byf_exit() {
	byf_releaseAll()
	byf_updateRunTime()
	Gui Destroy 
}

; other functions (not by me)

; by zez i think
runWith(version){	
	if (A_PtrSize=(version=32?4:8))
		Return
	SplitPath,A_AhkPath,,ahkDir
	if (!FileExist(correct := ahkDir "\AutoHotkeyU" version ".exe")){
		MsgBox,0x10,"Error",% "Couldn't find the " version " bit Unicode version of Autohotkey in:`n" correct
		ExitApp
	}
	Run,"%correct%" "%A_ScriptName%",%A_ScriptDir%
	ExitApp
}

;https://www.autohotkey.com/boards/viewtopic.php?f=6&t=5841&hilit=gui+skin
SkinForm(Param1 := "Apply", DLL := "", SkinName := ""){
	if(Param1 = 0) {
		DllCall(DLL . "\USkinExit")
	}
	else {
		DllCall("LoadLibrary", str, DLL)
		DllCall(DLL . "\USkinInit", Int,0, Int,0, AStr, SkinName)
	}
}

;ninju screenshotter functions
Screenshot(outfile) {
	Try {
    pToken := Gdip_Startup()

    screen=0|0|%A_ScreenWidth%|%A_ScreenHeight%
    pBitmap := Gdip_BitmapFromScreen(screen)

    Gdip_SaveBitmapToFile(pBitmap, outfile, 100)
    Gdip_DisposeImage(pBitmap)
    Gdip_Shutdown(pToken)
	}
}

Screen() {
	file := A_ScriptDir . "\screen.png"
	Screenshot(file)
}

; sends image to webhook (by the people below)
ImageSend() {
	objParam := {file: [A_ScriptDir "\screen.png"], content: ""}
	CreateFormData(PostData, hdr_ContentType, objParam)
	HTTP := ComObjCreate("WinHTTP.WinHTTPRequest.5.1")
	Try {
		HTTP.Open("POST", webhookLink, true) ;*[imagesender]
		HTTP.SetRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko")
		HTTP.SetRequestHeader("Content-Type", hdr_ContentType)
		HTTP.SetRequestHeader("Pragma", "no-cache")
		HTTP.SetRequestHeader("Cache-Control", "no-cache, no-store")
		HTTP.SetRequestHeader("If-Modified-Since", "Sat, 1 Jan 2000 00:00:00 GMT")
		HTTP.Send(PostData)
		HTTP.WaitForResponse()
	}
}

; CreateFormData() by tmplinshi, AHK Topic: https://autohotkey.com/boards/viewtopic.php?t=7647
; Thanks to Coco: https://autohotkey.com/boards/viewtopic.php?p=41731#p41731
; Modified version by SKAN, 09/May/2016

CreateFormData(ByRef retData, ByRef retHeader, objParam) {
	New CreateFormData(retData, retHeader, objParam)
}

Class CreateFormData {

	__New(ByRef retData, ByRef retHeader, objParam) {

		Local CRLF := "`r`n", i, k, v, str, pvData
		; Create a random Boundary
		Local Boundary := this.RandomBoundary()
		Local BoundaryLine := "------------------------------" . Boundary

    this.Len := 0 ; GMEM_ZEROINIT|GMEM_FIXED = 0x40
    this.Ptr := DllCall( "GlobalAlloc", "UInt",0x40, "UInt",1, "Ptr"  )          ; allocate global memory

		; Loop input paramters
		For k, v in objParam
		{
			If IsObject(v) {
				For i, FileName in v
				{
					str := BoundaryLine . CRLF
					     . "Content-Disposition: form-data; name=""" . k . """; filename=""" . FileName . """" . CRLF
					     . "Content-Type: " . this.MimeType(FileName) . CRLF . CRLF
          this.StrPutUTF8( str )
          this.LoadFromFile( Filename )
          this.StrPutUTF8( CRLF )
				}
			} Else {
				str := BoundaryLine . CRLF
				     . "Content-Disposition: form-data; name=""" . k """" . CRLF . CRLF
				     . v . CRLF
        this.StrPutUTF8( str )
			}
		}

		this.StrPutUTF8( BoundaryLine . "--" . CRLF )

    ; Create a bytearray and copy data in to it.
    retData := ComObjArray( 0x11, this.Len ) ; Create SAFEARRAY = VT_ARRAY|VT_UI1
    pvData  := NumGet( ComObjValue( retData ) + 8 + A_PtrSize )
    DllCall( "RtlMoveMemory", "Ptr",pvData, "Ptr",this.Ptr, "Ptr",this.Len )

    this.Ptr := DllCall( "GlobalFree", "Ptr",this.Ptr, "Ptr" )                   ; free global memory

    retHeader := "multipart/form-data; boundary=----------------------------" . Boundary
	}

  StrPutUTF8( str ) {
    Local ReqSz := StrPut( str, "utf-8" ) - 1
    this.Len += ReqSz                                  ; GMEM_ZEROINIT|GMEM_MOVEABLE = 0x42
    this.Ptr := DllCall( "GlobalReAlloc", "Ptr",this.Ptr, "UInt",this.len + 1, "UInt", 0x42 )
    StrPut( str, this.Ptr + this.len - ReqSz, ReqSz, "utf-8" )
  }

  LoadFromFile( Filename ) {
    Local objFile := FileOpen( FileName, "r" )
    this.Len += objFile.Length                     ; GMEM_ZEROINIT|GMEM_MOVEABLE = 0x42
    this.Ptr := DllCall( "GlobalReAlloc", "Ptr",this.Ptr, "UInt",this.len, "UInt", 0x42 )
    objFile.RawRead( this.Ptr + this.Len - objFile.length, objFile.length )
    objFile.Close()
  }

	RandomBoundary() {
		str := "0|1|2|3|4|5|6|7|8|9|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z"
		Sort, str, D| Random
		str := StrReplace(str, "|")
		Return SubStr(str, 1, 12)
	}

	MimeType(FileName) {
		n := FileOpen(FileName, "r").ReadUInt()
		Return (n        = 0x474E5089) ? "image/png"
		     : (n        = 0x38464947) ? "image/gif"
		     : (n&0xFFFF = 0x4D42    ) ? "image/bmp"
		     : (n&0xFFFF = 0xD8FF    ) ? "image/jpeg"
		     : (n&0xFFFF = 0x4949    ) ? "image/tiff"
		     : (n&0xFFFF = 0x4D4D    ) ? "image/tiff"
		     : "application/octet-stream"
	}

}

; hotkeys

; start, main loop
$F1::
{
	Start:
	Critical, Off
	WinSet, Transparent, 100, byfron
	byf_checkConnection()
	MouseMove, 1000, 300, 8
	byf_reloadGui()
	byf_statusLog("byfron macro started")
	byf_checkConnection()
	byf_releaseAll()
	Loop, {
		Loop, 80 {
			Loop, 3 {
				byf_farmWaves()
			}
			byf_openCrateCF()
		}
		byf_restComputer()
	}
}


; pause
$F2:: 
{
	Stop:
	WinSet, Transparent, 255, byfron
	byf_releaseAll()
	byf_updateRunTime()
	If (A_IsPaused) {
		WinActivate, Roblox ahk_exe RobloxPlayerBeta.exe
		SB_SetText("Status: Unpaused")
		WinSet, Transparent, 100, byfron
		MouseMove, 1000, 300, 8
	} else {
		SB_SetText("Status: Paused, F2 to continue")
	}
	Pause, Toggle, 1
	byf_checkConnection()
	Return
}

; end/restart macro
$F3:: 
{
	End:
	byf_releaseAll()
	byf_updateRunTime()
	Reload
	Return
}

; hourly stats
$F4::
{
	byf_hourlyStats()
	Return
}

;g-labels

;gui close
GuiClose:
GuiEscape:
MsgBox, 0, byfron, Macro sucessfully closed, 2
ExitApp

;gets the mouse coordinates of some stuff
FirstTime:
MsgBox, 0, byfron, Please position your mouse on the specified menu buttons:, 12
MsgBox, 0, byfron, Position your mouse on your preferred save to load in 10 seconds:, 2
Sleep, 7000
Click, Left
MouseGetPos, saveX, saveY
MsgBox, 0, byfron, Position your mouse on your preferred lunchbox to open in 10 seconds:, 2
Sleep, 7000
Click, Left
MouseGetPos, carbonX, carbonY
byf_updateConfig()
MsgBox, 0, byfron, Complete!
Reload

;enableds/disables opening crates, and displays info
OpenCrateMenu:
If !(openCrates) {
	MsgBox, 4, byfron, Description: `nOpens your chosen lunchbox ~ every 12 minutes if possible`n`nEnable?
	IfMsgBox Yes 
		openCrates := 1
		byf_updateConfig()
} else {
	MsgBox, 4, byfron, Description: `nOpens your chosen lunchbox ~ every 12 minutes if possible`n`nDisable?
	IfMsgBox Yes 
		openCrates := 0
		byf_updateConfig()
}
Return

;reloads gui for new GuiTheme
GuiSelect:
byf_reloadGui()
Return

;opens README.md
ReadMe:
MsgBox, 4, byfron, Open README.md?
IfMsgBox Yes 
	Run, % "explorer.exe /e`, /n`, /select` /open` ," A_ScriptDir "\README.md"
Return

;opens changes.md
ChangeLog:
MsgBox, 4, byfron, Open changes.md?
IfMsgBox Yes 
	Run, % "explorer.exe /e`, /n`, /select` /open` ," A_ScriptDir "\changes.md"
Return

;deletes config.ini and makes a new one
ResetConfiguration:
MsgBox, 4, byfron, Reset all settings?
IfMsgBox No
	Return 
Else {
	FileDelete, %A_ScriptDir%\settings\config.ini
	webhookLink := "DiscordWebhook:"
	privateServerLink := "RobloxPrivateServer:"
	chosenWave := 29
	alwaysOnTop := 1
	webhooksEnabled := 1
	webhooksScreenshots := 1
	robloxPremium := 0
	robloxCrackersGamepass := 0
	runTime := 0
	startTime := A_NowUTC
	saveX := 548
	saveY := 544
	carbonX := 548
	carbonY := 544
	openCrates := 0
	GuiTheme := "MacLion3"
	Gui Destroy
	Reload
	Return
}

;funis
PayToWin:
Run, % "explorer.exe /e`, /n`, /select` /open` ," A_ScriptDir "\sub\my_honest_reaction.mp4"
Return
