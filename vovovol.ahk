
#NoEnv
SetBatchLines, -1

#Include VA.ahk


Gui, Add, Progress, w100 h20 x0 y0 Range0-100 vVolSlider, 0
Gui, Add, Text, w100 h20 x0 y0 vVolText BackgroundTrans Center +0x200, 0
Gui, +AlwaysOnTop -Caption +ToolWindow +HwndGuiHwnd
Gui, Show, Hide w100 h20 x0 y0, Volume
return


*Volume_Up::
*Volume_Down::
if GetKeyState("Ctrl", "P")
	Amount = 100
else if GetKeyState("Alt", "P")
	Amount = 10
else
	Amount = 2
if (A_ThisHotkey == "*Volume_Down")
	Amount *= -1
if GetKeyState("LWin", "P")
{
	WinGet, PID, PID, A
	VA_SetAppVolume(PID, VA_GetAppVolume(PID) + Amount)
	SetTimer, ShowActiveTip, -0
}
else
{
	VA_SetMasterVolume(VA_GetMasterVolume() + Amount)
	SetTimer, ShowTip, -0
}
return

Volume_Mute::
VA_SetMasterMute(!VA_GetMasterMute())
SetTimer, ShowTip, -0
return

#Volume_Mute::
WinGet, PID, PID, A
VA_SetAppMute(PID, !VA_GetAppMute(PID))
SetTimer, ShowActiveTip, -0
return

ShowTip:
Volume := VA_GetMasterVolume()
GuiControl,, VolSlider, % Round(Volume)
GuiControl,, VolText, % Round(Volume) . (VA_GetMasterMute() ? " X" : "")
Gui, Show, NA x0 y0
SetTimer, ClearTip, -2000
return

ShowActiveTip:
WinGet, PID, PID, A
WinGetPos, X, Y, W, H, A
Volume := VA_GetAppVolume(PID)
GuiControl,, VolSlider, % Round(Volume)
GuiControl,, VolText, % Round(Volume) . (VA_GetAppMute(PID) ? " X" : "")
X := X+W-100
Gui, Show, % "NA x" X "y" Y
SetTimer, ClearTip, -2000
return

ClearTip:
Gui, Show, Hide
return


VA_GetISimpleAudioVolume(Param)
{
	static IID_IASM2 := "{77AA99A0-1BD6-484F-8BC7-2C654C9A9B6F}"
	, IID_IASC2 := "{bfb7ff88-7239-4fc9-8fa2-07c950be9c6d}"
	, IID_ISAV := "{87CE5498-68D6-44E5-9215-6DA47EF883D8}"
	
	; Turn empty into integer
	if !Param
		Param := 0
	
	; Get PID from process name
	if Param is not Integer
	{
		Process, Exist, %Param%
		Param := ErrorLevel
	}
	
	; GetDefaultAudioEndpoint
	DAE := VA_GetDevice()
	
	; activate the session manager
	VA_IMMDevice_Activate(DAE, IID_IASM2, 0, 0, IASM2)
	
	; enumerate sessions for on this device
	VA_IAudioSessionManager2_GetSessionEnumerator(IASM2, IASE)
	VA_IAudioSessionEnumerator_GetCount(IASE, Count)
	
	; search for an audio session with the required name
	Loop, % Count
	{
		; Get the IAudioSessionControl object
		VA_IAudioSessionEnumerator_GetSession(IASE, A_Index-1, IASC)
		
		; Query the IAudioSessionControl for an IAudioSessionControl2 object
		IASC2 := ComObjQuery(IASC, IID_IASC2)
		ObjRelease(IASC)
		
		; Get the session's process ID
		VA_IAudioSessionControl2_GetProcessID(IASC2, SPID)
		
		; If the process name is the one we are looking for
		if (SPID == Param)
		{
			; Query for the ISimpleAudioVolume
			ISAV := ComObjQuery(IASC2, IID_ISAV)
			
			ObjRelease(IASC2)
			break
		}
		ObjRelease(IASC2)
	}
	ObjRelease(IASE)
	ObjRelease(IASM2)
	ObjRelease(DAE)
	return ISAV
}

;
; ISimpleAudioVolume : {87CE5498-68D6-44E5-9215-6DA47EF883D8}
;
VA_ISimpleAudioVolume_GetMasterVolume(this, ByRef fLevel) {
	return DllCall(NumGet(NumGet(this+0)+4*A_PtrSize), "ptr", this, "float*", fLevel)
}
VA_ISimpleAudioVolume_SetMasterVolume(this, ByRef fLevel, GuidEventContext="") {
	return DllCall(NumGet(NumGet(this+0)+3*A_PtrSize), "ptr", this, "float", fLevel, "ptr", VA_GUID(GuidEventContext))
}
VA_ISimpleAudioVolume_GetMute(this, ByRef Muted) {
	return DllCall(NumGet(NumGet(this+0)+6*A_PtrSize), "ptr", this, "int*", Muted)
}
VA_ISimpleAudioVolume_SetMute(this, ByRef Muted, GuidEventContext="") {
	return DllCall(NumGet(NumGet(this+0)+5*A_PtrSize), "ptr", this, "int", Muted, "ptr", VA_GUID(GuidEventContext))
}


VA_GetAppVolume(App)
{
	ISAV := VA_GetISimpleAudioVolume(App)
	VA_ISimpleAudioVolume_GetMasterVolume(ISAV, fLevel)
	ObjRelease(ISAV)
	return fLevel * 100
}

VA_SetAppVolume(App, fLevel)
{
	ISAV := VA_GetISimpleAudioVolume(App)
	fLevel := ((fLevel>100)?100:((fLevel < 0)?0:fLevel))/100
	VA_ISimpleAudioVolume_SetMasterVolume(ISAV, fLevel)
	ObjRelease(ISAV)
}

VA_GetAppMute(App)
{
	ISAV := VA_GetISimpleAudioVolume(App)
	VA_ISimpleAudioVolume_GetMute(ISAV, Muted)
	ObjRelease(ISAV)
	return Muted
}

VA_SetAppMute(App, Muted)
{
	ISAV := VA_GetISimpleAudioVolume(App)
	VA_ISimpleAudioVolume_SetMute(ISAV, Muted)
	ObjRelease(ISAV)
}