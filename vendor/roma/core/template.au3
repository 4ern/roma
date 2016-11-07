#cs
|-----------------------------------------------------------------------------------------------/
| roma Template
|-----------------------------------------------------------------------------------------------/
|
| Mit dem Template System ist es möglich Variablen auszugben und einfache if Expressions 
| auszuführen. Ich habe mich hier von Laravel Blade insperieren lassen, jedoch nicht ganz so 
| unfangreich. Was aber noch nicht ist, kann noch werden :)
|
#ce

;----------------------------------------------------------------------------------------------/
; Template Constructor, führt alle Template Funktionen zusammen.
;----------------------------------------------------------------------------------------------/
func _vendor_roma_core_template___constructor($FILE)

	;----------------------------------------------------------------------------------------------/
	; Schleife bis alle Template Macros durchgeführt wurden
	;----------------------------------------------------------------------------------------------/
	do 
		_vendor_roma_core_template__includes($FILE)
		_vendor_roma_core_template__sections($FILE)
		_vendor_roma_core_template__parse_comments($FILE)
		_vendor_roma_core_template__parse_vars($FILE)
		$FILE = _vendor_roma_core_template__parse_if_expr($FILE, 'if')
		$FILE = _vendor_roma_core_template__parse_if_expr($FILE, 'unless')
	until (StringInStr($FILE, '@section') = 0) and (StringInStr($FILE, '@include') = 0)
	
	;----------------------------------------------------------------------------------------------/
	; Sende Datei an den Client
	;----------------------------------------------------------------------------------------------/
	$MIME_TYPE = _vendor_roma_core_container__mimetype('html')
	return _vendor_roma_core_http_response_data($MIME_TYPE, Binary($FILE))
endfunc

;----------------------------------------------------------------------------------------------/
; Befüllt @yields mit den Sektionen
;----------------------------------------------------------------------------------------------/
func _vendor_roma_core_template__sections(byref $FILE)

	#cs
	|-----------------------------------------------------------------------------------------------/
	| Extends
	|-----------------------------------------------------------------------------------------------/
	|
	| Ermittlund der Eltern(Master/Layout) Datei
	|
	#ce
		;----------------------------------------------------------------------------------------------/
		; Return, wenn der Befehl nicht vorhanden.
		;----------------------------------------------------------------------------------------------/
		if StringInStr($FILE, '@extends(') = 0 then return

		;----------------------------------------------------------------------------------------------/
		; Ermittlung des Pfads
		;----------------------------------------------------------------------------------------------/
		$pExtend  = (StringRegExp(StringReplace(StringReplace($FILE, '"', '´'), "'", '´'), '(@extends\(´)(\w*)(´\))',2))[2]
		$pfile    = $ROOT & '\views\' & StringReplace(StringReplace($pExtend, '/', '\'), '.', '\') & '.roma.html'
		$sExtends = Fileread($pfile)

	#cs
	|-----------------------------------------------------------------------------------------------/
	| Sections
	|-----------------------------------------------------------------------------------------------/
	|
	| Ermittlung der Sektionen in $FILE und schreibe dise in die 
	| @yield in $sExtends
	|
	#ce
		;----------------------------------------------------------------------------------------------/
		; schleife bis alle @yields abgearbeitet sind
		;----------------------------------------------------------------------------------------------/
		while StringInStr($sExtends, '@yield')

			;----------------------------------------------------------------------------------------------/
			; Ermittlung der yield sections
			;----------------------------------------------------------------------------------------------/
			$aYield       = StringRegExp($sExtends, '(?si)\@yield\((.*?)\)', 2)
			$sSectionName = StringReplace(StringReplace($aYield[1], '"', ''), "'", "")

			;----------------------------------------------------------------------------------------------/
			; Suche die section in $FILE
			;----------------------------------------------------------------------------------------------/
			$regEx    = StringFormat('(?si)\@section\((%s|%s)\)(.*?)\@stop','"'&$sSectionName&'"', "'"&$sSectionName&"'")
			$aContent = StringRegExp($FILE, $regEx, 3)
			if IsArray($aContent) = 0 then 
				$sExtends = StringReplace($sExtends, $aYield[0], '')
				continueloop
			endif

			;----------------------------------------------------------------------------------------------/
			; Ersetze Yield mit dem Section Content.
			;----------------------------------------------------------------------------------------------/
			$sExtends = StringReplace($sExtends, $aYield[0], $aContent[1])
		wend

		;----------------------------------------------------------------------------------------------/
		; Übergabe
		;----------------------------------------------------------------------------------------------/
		$FILE = $sExtends
endfunc

;----------------------------------------------------------------------------------------------/
; Ermittelt die Includes und setzt diese ein
;----------------------------------------------------------------------------------------------/
func _vendor_roma_core_template__includes(byref $FILE)
	
	;----------------------------------------------------------------------------------------------/
	; schleife bis alle @includes Macros abgearbeitet sind
	;----------------------------------------------------------------------------------------------/
	while StringInStr($FILE, '@include')

		;----------------------------------------------------------------------------------------------/
		; Ermittlung der yield sections
		;----------------------------------------------------------------------------------------------/
		$aInclude = StringRegExp($FILE, '(?si)\@include\((.*?)\)', 2)

		;----------------------------------------------------------------------------------------------/
		; Prüfe ob ein gültiges MIMEType vorhanden ist
		;----------------------------------------------------------------------------------------------/
		$aPATH = StringSplit($aInclude[1], '.', 0)
		if IsArray($aPATH) then	
			$fileType  = StringReplace(StringReplace($aPATH[ubound($aPATH)-1], '"', ''), "'", '')
			$MIME_TYPE = _vendor_roma_core_container__mimetype($fileType)

			;----------------------------------------------------------------------------------------------/
			; Wenn ein gültiges MIMEType vorhanden ist, 
			; dann handelt es sich nicht um ein roma Template
			;----------------------------------------------------------------------------------------------/
			if not @error then
				$sIncFile = StringReplace(StringReplace(StringReplace($aInclude[1], '.', '\'), '"', ''), "'", "")
				$sIncFile = StringReplace($sIncFile, '\' & $fileType, '.' & $fileType)

				;----------------------------------------------------------------------------------------------/
				; Prüfen ob die gefordete Datei exsistiert, wenn ja lese diese ein.
				;----------------------------------------------------------------------------------------------/
				if FileExists($ROOT & '\views\' & $sIncFile) then
					$sIncText = FileRead($ROOT & '\views\' & $sIncFile)
				else
					$sIncText = ''
					$LOG('ERROR', $LANG('error.ViewNoInclude') & @CRLF & '* Include Datei: ' & $sIncFile)
				endif

			;----------------------------------------------------------------------------------------------/
			; Es handel sich im ein roma Template
			; Lese das Include ein
			;----------------------------------------------------------------------------------------------/
			else
				$sIncFile = StringReplace(StringReplace(StringReplace($aInclude[1], '.', '\'), '"', ''), "'", "")
				if FileExists($ROOT & '\views\' & $sIncFile & '.roma.html') then
					$sIncText = FileRead($ROOT & '\views\' & $sIncFile & '.roma.html')
				else
					$sIncText = ''
					$LOG('ERROR', $LANG('error.ViewNoInclude') & @CRLF & '* Include Datei: ' & $sIncFile & '.roma.html')
				endif
			endif
		endif

		;----------------------------------------------------------------------------------------------/
		; Ersetze das @include Macro durch den include Text
		;----------------------------------------------------------------------------------------------/
		$FILE = StringReplace($FILE, $aInclude[0], $sIncText)
	wend
endfunc

;----------------------------------------------------------------------------------------------/
; Führt die If Expressions aus.
;----------------------------------------------------------------------------------------------/
func _vendor_roma_core_template__parse_if_expr($FILE, $condition = 'if')

	;----------------------------------------------------------------------------------------------/
	; Prüfe ob ein If oder If not ausgeführt werden soll.
	;----------------------------------------------------------------------------------------------/
	if $condition = 'unless' then
		$if    = '@unless'
		$endif = '@endunless'
	else
		$if    = '@if'
		$endif = '@endif'
	endif
	
	;----------------------------------------------------------------------------------------------/
	; If RegEx
	;----------------------------------------------------------------------------------------------/
	$regEx     = '(?si)\'&$if&'\((.*?)\)(.*?)' & $endif
	$regExFunc = '([a-zA-Z-\$_][a-zA-Z0-9_]*)(.*?)\('
	
	;----------------------------------------------------------------------------------------------/
	; Führe Schleife aus, bis kein if Statement vorhanden ist.
	;----------------------------------------------------------------------------------------------/
	while StringInStr($FILE, $if)

		;----------------------------------------------------------------------------------------------/
		; Ermittle ob ein If Statement vorhanden ist.
		;----------------------------------------------------------------------------------------------/
		$aIf = StringRegExp($FILE, $regEx, 2)
		if IsArray($aIf) = 0 then return $FILE

		;----------------------------------------------------------------------------------------------/
		; Prüfen, ob im Absatz ein weiteres Statement vorhanden ist.
		; 	-> Führe die Funktion im nächsten level aus.
		;----------------------------------------------------------------------------------------------/
		if StringInStr($aIf[2], $if) then 
			$sPara = _vendor_roma_core_template__parse_if_expr($aIf[2] & $endif, $condition)
			$FILE  = StringReplace($FILE, $aIf[2] & $endif, $sPara)
			$aIf   = StringRegExp($FILE, $regEx, 2)
		endif
		
		;----------------------------------------------------------------------------------------------/
		; Splitte die Expression
		;----------------------------------------------------------------------------------------------/
		$aExp = StringSplit($aIf[1], ' ')

		;----------------------------------------------------------------------------------------------/
		; Befülle expression mit echten Variablen
		;----------------------------------------------------------------------------------------------/
		$operator = $aExp[2]

		;----------------------------------------------------------------------------------------------/
		; Exp1
		;----------------------------------------------------------------------------------------------/
		;----------------------------------------------------------------------------------------------/
		; Check ob key ein Array anspricht.
		; 	-> wenn nicht, dann weiter mit simpler Variable weitermachen
		;----------------------------------------------------------------------------------------------/
		$aKey = StringSplit($aExp[1], '[', 0)
		if $aKey[0] > 1 then 

			;----------------------------------------------------------------------------------------------/
			; Ermittle das Array 
			;----------------------------------------------------------------------------------------------/
			$rVar = _vendor_roma_core_container__view_vars(StringReplace($aKey[1], '$', ''), null, 'get')
			if @error then $rVar = null

			;----------------------------------------------------------------------------------------------/
			; Setze Array Inhalt ins File
			;----------------------------------------------------------------------------------------------/
			$exp1 = Execute('$rVar['&$aKey[2])
		else
			$exp1 = _vendor_roma_core_container__view_vars(StringReplace($aExp[1], '$', ''), null, 'get')
		endif

		;----------------------------------------------------------------------------------------------/
		; Exp2
		;----------------------------------------------------------------------------------------------/
		;----------------------------------------------------------------------------------------------/
		; Check ob key ein Array anspricht.
		; 	-> wenn nicht, dann weiter mit simpler Variable weitermachen
		;----------------------------------------------------------------------------------------------/
		$aKey = StringSplit($aExp[3], '[', 0)
		if $aKey[0] > 1 then 

			;----------------------------------------------------------------------------------------------/
			; Ermittle das Array 
			;----------------------------------------------------------------------------------------------/
			$rVar = _vendor_roma_core_container__view_vars(StringReplace($aKey[1], '$', ''), null, 'get')
			if @error then $rVar = null

			;----------------------------------------------------------------------------------------------/
			; Setze Array Inhalt ins File
			;----------------------------------------------------------------------------------------------/
			$exp2 = Execute('$rVar['&$aKey[2])
		else
			$exp2 = _vendor_roma_core_container__view_vars(StringReplace($aExp[3], '$', ''), null, 'get')
		endif
		
		;----------------------------------------------------------------------------------------------/
		; Führe Tinary Operation aus anhand des Operators
		;----------------------------------------------------------------------------------------------/
		if $condition = 'if' then
			switch $operator
				case '='
					$bResult = ($exp1 = $exp2) ? True : False
				case '=='
					$bResult = ($exp1 == $exp2) ? True : False
				case '<>'
					$bResult = ($exp1 <> $exp2) ? True : False
				case '>'
					$bResult = ($exp1 > $exp2) ? True : False
				case '>='
					$bResult = ($exp1 >= $exp2) ? True : False
				case '<'
					$bResult = ($exp1 < $exp2) ? True : False
				case '<='
					$bResult = ($exp1 <= $exp2) ? True : False
			endswitch
		else
			switch $operator
				case '='
					$bResult = not ($exp1 = $exp2) ? True : False
				case '=='
					$bResult = not ($exp1 == $exp2) ? True : False
				case '<>'
					$bResult = not ($exp1 <> $exp2) ? True : False
				case '>'
					$bResult = not ($exp1 > $exp2) ? True : False
				case '>='
					$bResult = not ($exp1 >= $exp2) ? True : False
				case '<'
					$bResult = not ($exp1 < $exp2) ? True : False
				case '<='
					$bResult = not ($exp1 <= $exp2) ? True : False
			endswitch
		endif

		;----------------------------------------------------------------------------------------------/
		; Prüfe ob ein @else Macro vorhanden ist
		;	-> wenn ja, dann befülle $file mit dem else Part
		;	-> nein, dann lasse alles leer
		;----------------------------------------------------------------------------------------------/
		if StringInStr($aIf[0], '@else') <> 0 then
			$sElse = StringReplace((StringSplit($aIf[0], '@else', 1))[2], $endif, '')
			$sIf   = StringReplace(StringReplace($aIf[0], '@else', ''), $sElse, '')
			$FILE  = ($bResult) ? StringReplace($FILE, $aIf[0], $sIf) : StringReplace($FILE, $aIf[0], $sElse)
		else
			$FILE = ($bResult) ? StringReplace($FILE, $aIf[0], $aIf[2]) : StringReplace($FILE, $aIf[0], '')
		endif

		;----------------------------------------------------------------------------------------------/
		; Ersetze je nach Expression
		;----------------------------------------------------------------------------------------------/
		return $FILE
	wend

	;----------------------------------------------------------------------------------------------/
	; Return File 
	;----------------------------------------------------------------------------------------------/
	return $FILE
endfunc

;----------------------------------------------------------------------------------------------/
; Parse Variables
;----------------------------------------------------------------------------------------------/
func _vendor_roma_core_template__parse_vars(byref $FILE)
	
	local static $regEx = '\s*\{\{.*\$[a-zA-Z0-9_]+.*\}\}'

	;----------------------------------------------------------------------------------------------/
	; Prüfe ob Variablen ignoriert werden soll.
	; -> alle gefunden ignore Vars kennzeichnen
	;----------------------------------------------------------------------------------------------/
	$FILE = StringReplace($FILE, '@{{', '@%%!')

	;----------------------------------------------------------------------------------------------/
	; Ermittle alle Variablen
	;----------------------------------------------------------------------------------------------/
	$aVars = StringRegExp($FILE, $regEx, 3)
	if IsArray($aVars) then

		;----------------------------------------------------------------------------------------------/
		; Führe Schleife aus und ersetze die Macros(key) durch die Values
		;----------------------------------------------------------------------------------------------/
		for $var in $aVars

			;----------------------------------------------------------------------------------------------/
			; Reset Default Key
			;----------------------------------------------------------------------------------------------/
			$default_key = null

			;----------------------------------------------------------------------------------------------/
			; Prüfen ob eine or Option vorhanden ist
			;----------------------------------------------------------------------------------------------/
			$aVar = StringSplit($var, ' or ', 1)
			if $aVar[0] > 1 then 
				$key         = StringReplace(StringStripWS($aVar[1], 8), '{{$', '')
				$default_key = StringReplace(StringReplace(StringStripWS($aVar[2], 8), "'", ''), '}}', '')
			else
				;----------------------------------------------------------------------------------------------/
				; Ersetze '$' und entferne Leerzeichen
				;----------------------------------------------------------------------------------------------/
				$key = StringReplace(StringReplace(StringStripWS($var, 8), '{{$', ''), '}}', '')
			endif

			;----------------------------------------------------------------------------------------------/
			; Check ob key ein Array anspricht.
			; 	-> wenn nicht, dann weiter mit simpler Variable weitermachen
			;----------------------------------------------------------------------------------------------/
			$aKey = StringSplit($key, '[', 0)
			if $aKey[0] > 1 then 

				;----------------------------------------------------------------------------------------------/
				; Ermittle das Array 
				;----------------------------------------------------------------------------------------------/
				$rVar  = _vendor_roma_core_container__view_vars($aKey[1], null, 'get')
				$key   = StringFormat('$rVar[%s]', StringStripWS(StringReplace($aKey[2], ']', ''), 8))
				$value = Execute($key)

				;----------------------------------------------------------------------------------------------/
				; Setze Array Inhalt ins File
				;----------------------------------------------------------------------------------------------/
				if (StringLen($value) = 0) and ($default_key <> null) then
					$FILE = StringReplace($FILE, $var, $default_key)
				elseif (StringLen($value) = 0) then
					$FILE = StringReplace($FILE, $var, '')
				else
					$FILE = StringReplace($FILE, $var, Execute($key))
				endif
				
				continueloop
			endif

			;----------------------------------------------------------------------------------------------/
			; Ermittle das Value 
			;----------------------------------------------------------------------------------------------/
			$rVar = _vendor_roma_core_container__view_vars($key, null, 'get')
			if @error then $rVar = null

			;----------------------------------------------------------------------------------------------/
			; Setze Variablen Inhalt ins File
			;----------------------------------------------------------------------------------------------/
			if ($rVar = null) and ($default_key <> null) then
				$FILE = StringReplace($FILE, $var, $default_key)
			else
				$FILE = StringReplace($FILE, $var, $rVar)
			endif
		next
		
	endif

	;----------------------------------------------------------------------------------------------/
	; -> alle gefunden ignore Vars. Kennzeichnung wieder aufheben.
	;----------------------------------------------------------------------------------------------/
	$FILE = StringReplace($FILE, '@%%!', '@{{')
	return 1
endfunc

;----------------------------------------------------------------------------------------------/
; Parse Comments
;----------------------------------------------------------------------------------------------/
func _vendor_roma_core_template__parse_comments(byref $FILE)
	
	$regEx = '(?si)\{\{--(.*?)--\}\}(.*?)'
	$FILE = StringRegExpReplace($FILE, $regEx, '')

	return 1
endfunc