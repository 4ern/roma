#cs
|-----------------------------------------------------------------------------------------------
|  Route Constructor
|-----------------------------------------------------------------------------------------------
|  Function called from the route.au3.
|  The request is compared with route and the associated function will be called.
|
|  Funktionen die aus der route.au3 aufgerufen werden.
|  Die Abfrage wird mit route verglichen und die zugehörige Funktion aufgerufen.
|
#ce

;----------------------------------------------------------------------------------------------/
; Beschreibung: = route::get
;----------------------------------------------------------------------------------------------/
func _vendor_roma_core_route__constructor($sUserRequest, $sUserController)

	;----------------------------------------------------------------------------------------------/
	; Determine the actual GET request
	; Ermittle den aktuellen GET Request
	;----------------------------------------------------------------------------------------------/
	Local $sHttpRequest    = _vendor_roma_core_container__http()
	if @extended <> 'GET' or $sHttpRequest = NULL then return

	;----------------------------------------------------------------------------------------------/
	; Speichere den Raw Request
	;----------------------------------------------------------------------------------------------/
	Local $sRawHttpRequest = $sHttpRequest

	#cs
	|-----------------------------------------------------------------------------------------------
	|  Simple Match
	|  Einfacher Vergleich
	|-----------------------------------------------------------------------------------------------
	|  Simple Match without function parameters and index detection.
	|
	|  Einfacher Abgleich ohne Funktionsparameter und index Erkennung.
	|
	#ce

		;----------------------------------------------------------------------------------------------/
		; Check if this is the index file, if so rename to file
		; Überprüfe ob es sich um die index Datei handelt, wenn ja benenne diese um
		;----------------------------------------------------------------------------------------------/
		if ($sHttpRequest == '/') or ($sHttpRequest == 'index') then $sHttpRequest = '/index'
		if ($sUserRequest == '/') or ($sHttpRequest == 'index') then $sUserRequest = 'index'

		;----------------------------------------------------------------------------------------------/
		; Check if the HTTP request matches the user query 
		; Prüfe ob die HTTP Abfrage mit der User Abfrage übereinstimmt
		;----------------------------------------------------------------------------------------------/
		if StringTrimLeft($sHttpRequest, 1) == $sUserRequest then

			;----------------------------------------------------------------------------------------------/
			; Call the User function
			; Rufe die User Funktion auf
			;----------------------------------------------------------------------------------------------/
			Call($sUserController)

			;----------------------------------------------------------------------------------------------/
			; Check if the Controller/function exists
			; Prüfe ob der Controller/Funktion existiert.
			;----------------------------------------------------------------------------------------------/
			if @error = 0xDEAD and @extended = 0xBEEF then
				$LOG('ERROR', $LANG('error.ControllerNotExsist') & @CRLF & '* Controller-Funktion: ' & $sUserController)
				_vendor_roma__error('Controller-Funktion: <strong>' & $sUserController & '</strong> ist unbekannt.')
				return SetError(1, 0, 0)
			endif

			;----------------------------------------------------------------------------------------------/
			; Reset the Container and return
			; Setze Container zurück und Return
			;----------------------------------------------------------------------------------------------/
			_vendor_roma_core_container__http('reset')
			return 1
		endif

	#cs
	|-----------------------------------------------------------------------------------------------
	|  Match the parameters
	|  Match mit Parametern
	|-----------------------------------------------------------------------------------------------
	|  Chech the Match with the all normal and optional parameters
	|
	|  Prüfe Match mit Parametern und optionalen Parametern.
	|
	#ce

		;----------------------------------------------------------------------------------------------/
		; Check the optional parameters
		; Ermittle Optionale Parameter
		;----------------------------------------------------------------------------------------------/
			Local $aOptParam = StringRegExp($sUserRequest, '/(?si){\?(.*?)}', 3)
			Local $iOptParam = UBound($aOptParam)

			;----------------------------------------------------------------------------------------------/
			; Remove optional parameters from $sUserRequest.
			; Entferne Optionale Parameter aus $sUserRequest.
			;----------------------------------------------------------------------------------------------/
			for $i = 0 to Ubound($aOptParam) -1
				$sUserRequest = StringReplace($sUserRequest, '/{?' & $aOptParam[$i] & '}', '')
			next

		;----------------------------------------------------------------------------------------------/
		; Determine Parameters
		; Ermittle Parameter
		;----------------------------------------------------------------------------------------------/
			Local $aParam = StringRegExp($sUserRequest, '/(?si){(.*?)}', 3)
			Local $iParam = UBound($aParam)

			;----------------------------------------------------------------------------------------------/
			; Remove Parameter from $sUserRequest.
			; Entferne Parameter aus $sUserRequest.
			;----------------------------------------------------------------------------------------------/
			for $i = 0 to Ubound($aParam) -1
				$sUserRequest = StringReplace($sUserRequest, '/{' & $aParam[$i] & '}', '')
			next

		;----------------------------------------------------------------------------------------------/
		; Check if the number of parameters are present in the HTTP-Request.
		; Prüfe ob in der HTTP Abfrage die Anzahl der Parameter vorhanden ist.
		;----------------------------------------------------------------------------------------------/
			$sHttpRequest       = StringTrimLeft($sHttpRequest, 1)
			Local $aHttpRequest = StringSplit($sHttpRequest, '/', 2)

			;----------------------------------------------------------------------------------------------/
			; If there are more parameters required as there are then Return
			; Wenn mehr Parameter verlangt werden als vorhanden sind Return
			;----------------------------------------------------------------------------------------------/
			if ubound($aHttpRequest) <= ($iParam) then return 0

		;----------------------------------------------------------------------------------------------/
		; If there is a match, then execute the Call.
		; Wenn eine Übereinstimmung vorliegt, dann führe den Call aus.
		;----------------------------------------------------------------------------------------------/
			if StringInStr($sHttpRequest, $sUserRequest) then

				;----------------------------------------------------------------------------------------------/
				; Create Call array
				; Erstelle Call Array
				;----------------------------------------------------------------------------------------------/
				$sHttpRequest = StringReplace($sHttpRequest, $sUserRequest, '')

				Local $aCall  = StringSplit(StringTrimLeft($sHttpRequest, 1), '/', 0)
				$aCall[0]     = 'CallArgArray'

				;----------------------------------------------------------------------------------------------/
				; Execute the Call
				; Führe den Call aus
				;----------------------------------------------------------------------------------------------/
				Call($sUserController, $aCall)
				if @error = 0xDEAD and @extended = 0xBEEF then
					$LOG('ERROR', $LANG('error.ControllerNotExsistWithParam') & @CRLF & '* Controller-Funktion: ' & $sUserController)
					_vendor_roma__error('Controller-Funktion: <strong>' & $sUserController & '</strong> ist unbekannt oder Fehlerhafte Parameter übergabe.')
					return SetError(1, 0, 0)
				endif

				;----------------------------------------------------------------------------------------------/
				; Delete the data in the Container and return
				; Setze den Container zurück und führe Return aus
				;----------------------------------------------------------------------------------------------/
				_vendor_roma_core_container__http('reset')
				return 1
			endif

		;----------------------------------------------------------------------------------------------/
		; return
		;----------------------------------------------------------------------------------------------/
		return 0
endfunc