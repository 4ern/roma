;----------------------------------------------------------------------------------------------/
; Initialisiere die GUI
;----------------------------------------------------------------------------------------------/
func _vendor_roma_core_gui__initail()
	
	;----------------------------------------------------------------------------------------------/
	; Ermittle welche GUI genutzt werden soll
	;----------------------------------------------------------------------------------------------/
	$gui_typ = IniRead($ROOT & '\config\gui.ini', 'gui-typ', $APP('DEBUG') = 'true' ? 'develop' : 'production', 'browser')

	;----------------------------------------------------------------------------------------------/
	; execute gui function
	;----------------------------------------------------------------------------------------------/
	if $gui_typ = 'browser' then ShellExecute('http://' & $APP('IP') & ':' & $APP('PORT'))
	Call('_vendor_roma_core_gui__' & $gui_typ)
	
	;----------------------------------------------------------------------------------------------/
	; Prüfe ob der Controller/Funktion existiert.
	;----------------------------------------------------------------------------------------------/
	if @error = 0xDEAD and @extended = 0xBEEF then
		$LOG('ERROR', $LANG('error.GuiTypNotExists') & @CRLF & '* GUI Typ: ' & $gui_typ)
		exit
	endif
	
endfunc

#cs
|-----------------------------------------------------------------------------------------------/
| IE Sektion
|-----------------------------------------------------------------------------------------------/
|
| Erstellung einer AutoIt GUI mit IE Embedded
|
#ce
func _vendor_roma_core_gui__ie()
	
	;----------------------------------------------------------------------------------------------/
	; Setze GUIONEVENT
	;----------------------------------------------------------------------------------------------/
	Opt('GUIOnEventMode', 1)

	;----------------------------------------------------------------------------------------------/
	; Erstelle ie Embedded
	;----------------------------------------------------------------------------------------------/
	$oIE = ObjCreate("Shell.Explorer.2")

	;----------------------------------------------------------------------------------------------/
	; Holle die GUI Settings
	; Array Info
	;		Row | 	Col 0 	| 	Col 1
	;		[0] | 	7 
	;		[1] |	width 	|   Value
	;		[2] |	height 	|   Value
	;		[3] |	left 	|   Value
	;		[4] |	top 	|   Value
	;		[5] |	style 	|   Value
	;		[6] |	exstyle |   Value
	;----------------------------------------------------------------------------------------------/
	$aGuiSettings = IniReadSection($ROOT & '\config\gui.ini', 'ie')
	$style        = (StringLeft( $aGuiSettings[5][1], 1) = '$') ? eval(StringTrimLeft( $aGuiSettings[5][1], 1)) :  $aGuiSettings[5][1]
	$exStyle      = (StringLeft( $aGuiSettings[6][1], 1) = '$') ? eval(StringTrimLeft( $aGuiSettings[6][1], 1)) :  $aGuiSettings[6][1]

	;----------------------------------------------------------------------------------------------/
	; Erstellte die GUI
	;----------------------------------------------------------------------------------------------/
	$hGUI = GUICreate($APP('NAME'), $aGuiSettings[1][1], $aGuiSettings[2][1], $aGuiSettings[3][1], $aGuiSettings[4][1], $style, $exStyle)
	GUISetOnEvent($GUI_EVENT_CLOSE, '_vendor_roma_core_gui__exit', $hGUI)
	GUICtrlCreateObj($oIE, 0, 0, $aGuiSettings[1][1], $aGuiSettings[2][1])

	;----------------------------------------------------------------------------------------------/
	; Zeige die GUI an 
	;----------------------------------------------------------------------------------------------/
	GUISetState(@SW_SHOW)

	;----------------------------------------------------------------------------------------------/
	; Navigiere zur IP
	;----------------------------------------------------------------------------------------------/
	$url = 'http://' & $APP('IP') & ':' & $APP('PORT')
	$oIE.navigate($url)

endfunc

#cs
|-----------------------------------------------------------------------------------------------/
| Chrome APP Mode
|-----------------------------------------------------------------------------------------------/
|
| Öffnet ein Chrome Fenster im App Mode
|
#ce
Func _vendor_roma_core_gui__chrome()
	
	;----------------------------------------------------------------------------------------------/
	; Holle die GUI Settings
	; Array Info
	;		Row | 	Col 0 	| 	Col 1
	;		[0] | 	7 
	;		[1] |	width 	|   Value
	;		[2] |	height 	|   Value
	;		[3] |	left 	|   Value
	;		[4] |	top 	|   Value
	;----------------------------------------------------------------------------------------------/
	$aGuiSettings = IniReadSection($ROOT & '\config\gui.ini', 'chrome')

	;----------------------------------------------------------------------------------------------/
	; Erstellt eine unsichtbare chrome app 
	;----------------------------------------------------------------------------------------------/
	$pid = ShellExecute('Chrome.exe', '--app=http://' & $APP('IP') & ':' & $APP('PORT'))

	;----------------------------------------------------------------------------------------------/
	; warte bis das handle vorliegt
	;----------------------------------------------------------------------------------------------/
	$timer = TimerInit()

	While sleep(5)

		$hwnd = _vendor_roma_core_gui__WinGetHandle($pid)
		If (WinExists($APP('IP') & ':' & $APP('PORT'))) Then
			$hwnd = WinGetHandle($APP('IP') & ':' & $APP('PORT'))
			ExitLoop
		EndIf

		If (TimerDiff($timer) >= 60000) Then
			$LOG('ERROR', $LANG('error.GuiHwndNotExists'))
			exit
		EndIf
	WEnd

	ConsoleWrite($hwnd)
EndFunc

;----------------------------------------------------------------------------------------------/
; Beendet das Script wenn die GUI geschlossen wird.
;----------------------------------------------------------------------------------------------/
func _vendor_roma_core_gui__exit()
	exit
endfunc


;----------------------------------------------------------------------------------------------/
; Hilfsfunktion
; -> Ermittelt die hWnd anhand der PID
;----------------------------------------------------------------------------------------------/
Func _vendor_roma_core_gui__WinGetHandle($pid)

    Local $winList = WinList()

    For $i = 1 To $winList[0][0]
        If $pid = WinGetProcess($winList[$i][1]) Then
            Return $winList[$i][1]
        EndIf
    Next

    Return false

EndFunc
