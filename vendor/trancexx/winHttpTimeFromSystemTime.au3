; #FUNCTION# ;===============================================================================
;
; Name...........: __WinHttpTimeFromSystemTime
; Description ...: Formats a system date and time according to the HTTP version 1.0 specification.
; Syntax.........: __WinHttpTimeFromSystemTime()
; Parameters ....: None.
; Return values .: Success - Returns 1.
;                         - Sets @error to 0
;                 Failure - Returns 0 and sets @error:
;                 |1 - Initial DllCall failed.
;                 |2 - Main DllCall failed.
; Author ........: trancexx
; Modified.......: jchd (changed GetSystemTime to GetLocalTime) TODO change output from "GMT" to correct time adjustment
; Remarks .......:
; Related .......:
; Link ..........; http://msdn.microsoft.com/en-us/library/aa384117(VS.85).aspx
; Example .......; Yes
;
;==========================================================================================
Func _WinHttpTimeFromSystemTime()

	Local $SYSTEMTIME = DllStructCreate("ushort Year;" & _
			"ushort Month;" & _
			"ushort DayOfWeek;" & _
			"ushort Day;" & _
			"ushort Hour;" & _
			"ushort Minute;" & _
			"ushort Second;" & _
			"ushort Milliseconds")

	DllCall("kernel32.dll", "none", "GetLocalTime", "ptr", DllStructGetPtr($SYSTEMTIME))

	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	Local $sTime = DllStructCreate("wchar[62]")

	Local $a_iCall = DllCall("winhttp.dll", "int", "WinHttpTimeFromSystemTime", _
			"ptr", DllStructGetPtr($SYSTEMTIME), _
			"ptr", DllStructGetPtr($sTime))

	If @error Or Not $a_iCall[0] Then
		Return SetError(2, 0, 0)
	EndIf

	Return SetError(0, 0, DllStructGetData($sTime, 1))
EndFunc   ;==>_WinHttpTimeFromSystemTime