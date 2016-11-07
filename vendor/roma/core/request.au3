#cs
|-----------------------------------------------------------------------------------------------/
| roma HTTP Request
|-----------------------------------------------------------------------------------------------/
|
| Mit diesem Request Modul ist es sehr einfache Request Variablen zu verwalte.
| In den meisten Sprachen sind die Request Variablen auch unter GET & POST Variablen bekannt.
| ICh habe mich hier wieder mal von Laraval insperien lassen :P
|
#ce

;----------------------------------------------------------------------------------------------/
; Parse Request
; Ermittle ob (Get) Variablen vorhanden sind, 
; wenn ja befülle den Request Container
;----------------------------------------------------------------------------------------------/
func _vendor_roma_core_request__parse_get($sHttpRequest)
	
	Local $regEx_GET = '(?si)\?(.*)'

	$aGET = StringRegExp($sHttpRequest, $regEx_GET, 3)
	if IsArray($aGET) then

		;----------------------------------------------------------------------------------------------/
		; Entferne die Variablen aus dem Request
		;----------------------------------------------------------------------------------------------/
		$sHttpRequest = StringReplace($sHttpRequest, $aGET, '')

		;----------------------------------------------------------------------------------------------/
		; Ermittle variablen Paare und erstelle ein neues Array
		; Name & Inhalt
		;----------------------------------------------------------------------------------------------/
		$aGET = StringSplit($aGET[0], '&', 2)
		Local $a2dGet[UBound($aGET)][2]
		for $i = 0 to ubound($aGET) -1
			$aRet          = StringSplit($aGET[$i], '=', 2)
			$a2dGet[$i][0] = $aRet[0]
			$a2dGet[$i][1] = $aRet[1]
		next

		;----------------------------------------------------------------------------------------------/
		; Befülle den GET Container
		;----------------------------------------------------------------------------------------------/
		return _vendor_roma_core_request__container($a2dGet, 'set')
	endif

	return False
endfunc

;----------------------------------------------------------------------------------------------/
; Parse Request
; Ermittle (POST) Inupt Variablen
; wenn ja befülle den Request Container
;----------------------------------------------------------------------------------------------/
func _vendor_roma_core_request__parse_post($sHttpRequest)
	
	;----------------------------------------------------------------------------------------------/
	; Ermittlung der Post Variablen
	;----------------------------------------------------------------------------------------------/
	$aPost = StringSplit($sHttpRequest, @lf & @lf, 2)
	$sPost = $aPost[UBound($aPost)-1]

	;----------------------------------------------------------------------------------------------/
	; Ermittle variablen Paare und erstelle ein neues Array
	; Name & Inhalt
	;----------------------------------------------------------------------------------------------/
	$aPost = StringSplit($sPost, '&', 2)
	Local $a2dGet[UBound($aPost)][2]
	for $i = 0 to ubound($aPost) -1
		$aRet          = StringSplit($aPost[$i], '=', 2)
		$a2dGet[$i][0] = $aRet[0]
		$a2dGet[$i][1] = $aRet[1]
	next

	;----------------------------------------------------------------------------------------------/
	; Befülle den GET Container
	;----------------------------------------------------------------------------------------------/
	return _vendor_roma_core_request__container($a2dGet, 'set')
endfunc

;----------------------------------------------------------------------------------------------/
; Speicher Request in ein Dictionary
;----------------------------------------------------------------------------------------------/
func _vendor_roma_core_request__container($key = default, $action = 'get')

	Local Static $oRequest = ObjCreate('Scripting.Dictionary')

	Switch $action
		Case 'get'
			return $oRequest
			;----------------------------------------------------------------------------------------------/
			; Check, if key was delivered
			; Prüfe ob ein Schlüssel mitgeliefert wurde
			;----------------------------------------------------------------------------------------------/
			if $key = default then return SetError(1, 0, 0)

			;----------------------------------------------------------------------------------------------/
			; Check, if key exists. If so, then hand over
			; Prüfe ob ein Key existiert. Wenn ja, dann übergebe diesen
			;----------------------------------------------------------------------------------------------/
			if $oRequest.exists($key) then return $oRequest($key)

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
				if $oRequest.Exists($key[$i][0]) then 
					$oRequest($key[$i][0]) = $key[$i][1]
					ContinueLoop
				endif
				$oRequest.add($key[$i][0], $key[$i][1])
			next
			return true
		case 'reset'
			return $oRequest.RemoveAll
	EndSwitch
endfunc

;----------------------------------------------------------------------------------------------/
; Hilfsfunktion
; 	-> Übergibt ein Array mit dem gesamten Inhalt
;----------------------------------------------------------------------------------------------/
func _vendor_roma_core_request__all()
	
	;----------------------------------------------------------------------------------------------/
	; Holle das Dictionary
	;----------------------------------------------------------------------------------------------/
	$oRequest = _vendor_roma_core_request__container(null, 'get')

	;----------------------------------------------------------------------------------------------/
	; Prüfen ob die Dictianary Inhalt hat.
	; 	-> wenn keine Inhalte vorhanden, dann return null
	;----------------------------------------------------------------------------------------------/
	if $oRequest.count = 0 then return null

	;----------------------------------------------------------------------------------------------/
	; Erstelle ein 2d Array mit den Key und Values
	;----------------------------------------------------------------------------------------------/
	Local $aRequest[($oRequest.count)][2], $i = 0

	for $key in $oRequest.keys
		$aRequest[$i][0] = $key
		$aRequest[$i][1] = $oRequest($key)
		$i += 1
	next
	return $aRequest
endfunc

;----------------------------------------------------------------------------------------------/
; Hilfsfunktion
; 	-> Prüft ob der Key exsistiert
;	-> return True or False
;----------------------------------------------------------------------------------------------/
func _vendor_roma_core_request__has($key)

	;----------------------------------------------------------------------------------------------/
	; Prüfe ob Key Exsistiert
	;----------------------------------------------------------------------------------------------/
	return (_vendor_roma_core_request__container(null, 'get')).Exists($key)
endfunc

;----------------------------------------------------------------------------------------------/
; Hilfsfunktion
; 	-> Prüft ob der Key exsistiert
;	-> return Key Value, Defualt Value or error NUll
;----------------------------------------------------------------------------------------------/
func _vendor_roma_core_request__get($key, $default = default)

	;----------------------------------------------------------------------------------------------/
	; Ermittle Request Dictionary
	;----------------------------------------------------------------------------------------------/
	$oRequest = _vendor_roma_core_request__container(null, 'get')

	;----------------------------------------------------------------------------------------------/
	; Prüfe ob der geforderte Key exsistiert.
	;----------------------------------------------------------------------------------------------/
	if $oRequest.Exists($key) then return $oRequest.item($key)

	;----------------------------------------------------------------------------------------------/
	; Prüfe ob ein default Key angegeben wurde
	; 	-> wenn nicht, dann return @error 1
	;----------------------------------------------------------------------------------------------/
	return ($default = default) ? SetError(1, 0, null) : $default
endfunc