#cs
|-----------------------------------------------------------------------------------------------
|  Application-settings - Container
|  Container für Applikationseinstellungen
|-----------------------------------------------------------------------------------------------
|  This Scripting Dictionary works as Application-settings Container.
|  It can be accessed at any time.
|  
|  Scripting Dictionary Container für die Applikationseinstellungen.
|  Auf diesen Container kann jederzeit zugegriffen werden.
|
#ce
func _vendor_roma_core_container__app($key = default, $action = 'get')

	Local Static $oAPP = ObjCreate('Scripting.Dictionary')

	Switch $action
		Case 'get'
			;----------------------------------------------------------------------------------------------/
			; Check, if key was delivered
			; Prüfe ob ein Schlüssel mitgeliefert wurde
			;----------------------------------------------------------------------------------------------/
			if $key = default then return SetError(1, 0, 0)

			;----------------------------------------------------------------------------------------------/
			; Check, if key exists. If so, then hand over
			; Prüfe ob ein Key existiert. Wenn ja, dann übergebe diesen
			;----------------------------------------------------------------------------------------------/
			if $oAPP.exists($key) then return $oAPP($key)

			return SetError(2, 0, 0)		
		Case 'set'
			;----------------------------------------------------------------------------------------------/
			; Check, if key was delivered
			; Prüfe ob ein Schlüssel mitgeliefert wurde
			;----------------------------------------------------------------------------------------------/
			if IsArray($key) = 0 then SetError(1, 0, 0)

			;----------------------------------------------------------------------------------------------/
			; Check, if key allready exists
			;	- Yes: Change the Value
			;	- No: Create new key
			; Prüfe, ob der Key bereits existiert
			; 	- Ja: Ändere den Wert
			;	- Nein: Erstelle einen neuen Key
			;----------------------------------------------------------------------------------------------/
			for $i = 0 to Ubound($key) -1
				if $oAPP.Exists($key[$i][0]) then 
					$oAPP($key[$i][0]) = $key[$i][1]
					ContinueLoop
				endif
				$oAPP.add($key[$i][0], $key[$i][1])
			next
			return 1
	EndSwitch
endfunc

#cs
|-----------------------------------------------------------------------------------------------
|  GUI-Settings - Container
|  Container für GUI-Einstellungen
|-----------------------------------------------------------------------------------------------
|  This Scripting Dictionary works as GUI-settings Container.
|  It can be accessed at any time.  
|
|  Scripting Dictionary Container für die GUI-Einstellungen.
|  Auf diesen Container kann jederzeit zugegriffen werden.
|
#ce
func _vendor_roma_core_container_gui($key = default, $action = 'get')

	Local Static $oGUI = ObjCreate('Scripting.Dictionary')

	Switch $action
		Case 'get'
			;----------------------------------------------------------------------------------------------/
			; Check, if key was delivered
			; Prüfe ob ein Schlüssel mitgeliefert wurde
			;----------------------------------------------------------------------------------------------/
			if $key = default then return SetError(1, 0, 0)

			;----------------------------------------------------------------------------------------------/
			; Check, if key exists. If so, then hand over
			; Prüfe ob ein Key existiert. Wenn ja, dann übergebe diesen
			;----------------------------------------------------------------------------------------------/
			if $oGUI.exists($key) then return $oGUI($key)

			return SetError(2, 0, 0)		
		Case 'set'
			;----------------------------------------------------------------------------------------------/
			; Check, if key was delivered
			; Prüfe ob ein Schlüssel mitgeliefert wurde
			;----------------------------------------------------------------------------------------------/
			if IsArray($key) = 0 then SetError(1, 0, 0)

			;----------------------------------------------------------------------------------------------/
			; Check, if key allready exists
			;	- Yes: Change the Value
			;	- No: Create new key
			; Prüfe, ob der Key bereits existiert
			; 	- Ja: Ändere den Wert
			;	- Nein: Erstelle einen neuen Key
			;----------------------------------------------------------------------------------------------/
			for $i = 0 to Ubound($key) -1
				if $oGUI.Exists($key[$i][0]) then 
					$oGUI($key[$i][0]) = $key[$i][1]
					ContinueLoop
				endif
				$oGUI.add($key[$i][0], $key[$i][1])
			next
			return 1
	EndSwitch
endfunc

#cs
|-----------------------------------------------------------------------------------------------
|  MIME-Type Container for HTTP
|  MIME-Typ Container für HTTP
|-----------------------------------------------------------------------------------------------
|  This Scripting Dictionary works as MIME-Type-Container.
|  It can be accessed at any time.  
|
|  Scripting Dictionary Container für die notwendigen MIME-Typen.
|  Auf diesen Container kann jederzeit zugegriffen werden.
|
#ce
func _vendor_roma_core_container__mimetype($key = default, $action = 'get')

	Local Static $oMIME = ObjCreate('Scripting.Dictionary')

	Switch $action
		Case 'get'

			;----------------------------------------------------------------------------------------------/
			; Check, if key exists. If so, then hand over
			; Prüfe ob ein Key existiert. Wenn ja, dann übergebe diesen
			;----------------------------------------------------------------------------------------------/
			if $oMIME.exists($key) then return $oMIME($key)

			;----------------------------------------------------------------------------------------------/
			; If the MIME-type does not exist, then the file will be available for download
			; Wenn der MIME-Typ nicht existiert, dann wird die Datei zum Download angeboten 
			; und @error auf 1 gesetzt.
			;----------------------------------------------------------------------------------------------/
			return SetError(1, 0, 'application/octet-stream')	

		Case 'set'
			
			;----------------------------------------------------------------------------------------------/
			; Setting the MIME-types.
			; MIME-types are needed to communicate with the browser.

			; Setzen der MIME-Typen.
			; MIME-Typen sind für die Kommunikation mit dem Browser notwendig.
			;----------------------------------------------------------------------------------------------/
			$oMIME('htm')   = 'text/html'
			$oMIME('html')  = 'text/html'
			$oMIME('css')   = 'text/css'
			$oMIME('js')    = 'text/javascript'
			$oMIME('jpg')   = 'image/jpeg'
			$oMIME('jpeg')  = 'image/jpeg'
			$oMIME('png')   = 'image/png'
			$oMIME('gif')   = 'image/gif'
			$oMIME('svg')   = 'image/svg+xml'
			$oMIME('ico')   = 'image/x-icon'
			$oMIME('ttf')   = 'application/x-font-ttf'
			$oMIME('otf')   = 'application/x-font-opentype'
			$oMIME('woff')  = 'application/font-wof'
			$oMIME('woff2') = 'application/font-woff2'
			$oMIME('eot')   = 'application/vnd.ms-fontobject'
			$oMIME('json')   = 'application/json'
			return 1
	EndSwitch
endfunc

#cs
|-----------------------------------------------------------------------------------------------
|  HTTP Request Container
|-----------------------------------------------------------------------------------------------
| Container für den HTTP Request.
| Speichert den aktuellen Request, und gibt diesen wieder.
| Nach dem der Request abgearbeitet wurde, wird der Container geleert.
|
#ce
func _vendor_roma_core_container__http($action = 'getRequest', $request = DEFAULT, $typ = 'GET')
	
	Local Static $storedRequest = NULL, $storedType = NULL, $isREQUST = FALSE

	;----------------------------------------------------------------------------------------------/
	; Saving request
	; Speichere Anfrage
	;----------------------------------------------------------------------------------------------/
	Switch $action
		Case 'setRequest'
			$storedREQUEST = $request
			$storedType    = $typ
			$isREQUST      = True
			return true

		;----------------------------------------------------------------------------------------------/
		; Submit the request
		; Übergebe die Anfrage
		;----------------------------------------------------------------------------------------------/
		Case 'getRequest'
			return SetError(0, $storedType, $storedRequest)

		case 'isREQUEST'
			return $isREQUST

		;----------------------------------------------------------------------------------------------/
		; Reset
		; Zurücksetzen
		;----------------------------------------------------------------------------------------------/
		Case 'reset'
			$storedRequest = NULL
			$storedType    = NULL
			$isREQUST      = FALSE
	EndSwitch
endfunc

#cs
|-----------------------------------------------------------------------------------------------
|  Response Container
|-----------------------------------------------------------------------------------------------
|  Container für die Response Codes. 
|  Key enspricht dem Response Code.
|
#ce
func _vendor_roma_core_container__response($key = default, $action = 'get')

	Local Static $oResponse = ObjCreate('Scripting.Dictionary')

	Switch $action
		Case 'get'

			;----------------------------------------------------------------------------------------------/
			; Prüfe ob ein Key existiert. Wenn ja, dann übergebe diesen
			;----------------------------------------------------------------------------------------------/
			if $oResponse.exists($key) then return $oResponse($key)

			;----------------------------------------------------------------------------------------------/
			; Wenn Respones Code nicht vorhanden ist übergebe Code 500
			;----------------------------------------------------------------------------------------------/
			return '500 Internal Server Error'	

		Case 'set'
			
			;----------------------------------------------------------------------------------------------/
			; Response Codes.
			;----------------------------------------------------------------------------------------------/
			$oResponse(200) = 'OK'
			$oResponse(400) = 'Bad Request'
			$oResponse(404) = 'Not Found'
			return 1
	EndSwitch
endfunc

#cs
|-----------------------------------------------------------------------------------------------
|  VIEW Variable Container
|-----------------------------------------------------------------------------------------------
| Speicher die Variablen inkl dessen Inhalt in einem Dictionary.
| Diese Variablen, werden dan mit den Variablen Macros in der View geparast.
|
#ce
func _vendor_roma_core_container__view_vars($key = null, $value = null, $action = 'set')

	Local Static $oVars = ObjCreate('Scripting.Dictionary')

	Switch $action
		Case 'get'
			;----------------------------------------------------------------------------------------------/
			; Check, if key was delivered
			; Prüfe ob ein Schlüssel mitgeliefert wurde
			;----------------------------------------------------------------------------------------------/
			if $key = default then 
				$LOG('ERROR', $LANG('error.ViewVarKeyGET'))
				return SetError(1, 0, null)
			endif

			;----------------------------------------------------------------------------------------------/
			; Check, if key exists. If so, then hand over
			; Prüfe ob ein Key existiert. Wenn ja, dann übergebe diesen
			;----------------------------------------------------------------------------------------------/
			if $oVars.exists($key) then return $oVars($key)
			$LOG('ERROR', $LANG('error.ViewVarValGET') & @crlf & '* Key:'& $key)
			return SetError(2, 0, null)		
		Case 'set'
			
			;----------------------------------------------------------------------------------------------/
			; Check, if key was delivered
			; Prüfe ob ein Schlüssel mitgegben wurde
			;----------------------------------------------------------------------------------------------/
			if $key   = null then $LOG('ERROR', $LANG('error.ViewVarKeySet') & @crlf & '* Key:'& $key)
			if $value = null then $LOG('ERROR', $LANG('error.ViewVarValSet') & @crlf & '* Key:'& $key)

			;----------------------------------------------------------------------------------------------/
			; Schreibe den Wert ins Dictionary
			;----------------------------------------------------------------------------------------------/
			if IsArray($key) = 0 then
				if $oVars.Exists($key) then 
					$oVars($key) = $value
					return 1
				endif
				$oVars.add($key, $value)
				return 1
			endif

			;----------------------------------------------------------------------------------------------/
			; Check, if key allready exists
			;	- Yes: Change the Value
			;	- No: Create new key
			; Prüfe, ob der Key bereits existiert
			; 	- Ja: Ändere den Wert
			;	- Nein: Erstelle einen neuen Key
			;----------------------------------------------------------------------------------------------/
			for $i = 1 to Ubound($key) -1
				if $oVars.Exists($key[$i][0]) then 
					$oVars($key[$i][0]) = $key[$i][1]
					ContinueLoop
				endif
				$oVars.add($key[$i][0], $key[$i][1])
			next
			return 1
	EndSwitch
endfunc
