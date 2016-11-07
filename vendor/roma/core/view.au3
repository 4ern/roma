#cs
|-----------------------------------------------------------------------------------------------
| View Model
|-----------------------------------------------------------------------------------------------
|
| Hier wird die HTML Datei an die View übergeben.
| Handelt es sich um ein roma Template wird dieses geparst und anschließend übergeben.
|
#ce

;----------------------------------------------------------------------------------------------/
; Beschreibung: = Übergibt die View oder führt den view Constructor durch
;----------------------------------------------------------------------------------------------/
func _vendor_roma_core_view__create($file = NULL)

	;----------------------------------------------------------------------------------------------/
	; Prüfen ob Parameter übergeben wurde
	;----------------------------------------------------------------------------------------------/
	if $file = NULL then
		$LOG('ERROR', $LANG('error.ViewNoParam'))
		_vendor_roma__error('VIEW-Funktion: <strong>' & $LANG('error.ViewNoParam') & '</strong>.')
		return SetError(1, 0, 0) 
	endif

	;----------------------------------------------------------------------------------------------/
	; Konventiere & Vervollständige übergebenen Pfad
	;----------------------------------------------------------------------------------------------/
	$viewPath = $ROOT & '\views\' & $file

	;----------------------------------------------------------------------------------------------/
	; Prüfe ob eine .html Datei vorhanden ist
	; 	-> wenn ja, dann sende an den Client
	;----------------------------------------------------------------------------------------------/
	if FileExists($viewPath)then
		$MIME_TYPE = _vendor_roma_core_container__mimetype('html')
		return _vendor_roma_core_http_response_data($MIME_TYPE, $viewPath)
	elseif FileExists($viewPath & '.html')then
		$MIME_TYPE = _vendor_roma_core_container__mimetype('html')
		return _vendor_roma_core_http_response_data($MIME_TYPE, $viewPath & '.html')
	endif

	;----------------------------------------------------------------------------------------------/
	; Konventiere & Vervollständige übergebenen Pfad
	;----------------------------------------------------------------------------------------------/
	$viewPath = $ROOT & '\views\' & StringReplace(StringReplace($file, '/', '\'), '.', '\')

	;----------------------------------------------------------------------------------------------/
	; Prüfe ob eine roma.html Datei vorhanden ist
	;----------------------------------------------------------------------------------------------/
	if FileExists($viewPath & '.roma.html') = 1 then 
		
		;----------------------------------------------------------------------------------------------/
		; Lese das File ein und führ den Template Constructor aus
		;----------------------------------------------------------------------------------------------/
		$FILE = FileRead($viewPath & '.roma.html')
		return _vendor_roma_core_template___constructor($FILE)
	endif

	;----------------------------------------------------------------------------------------------/
	; Datei nicht vorhanden
	;----------------------------------------------------------------------------------------------/
	$LOG('ERROR', $LANG('error.ViewNoFile'))
	$LOG('ERROR', $LANG('error.ViewNoFile') & @CRLF & '* View-File: ' & $file)
	_vendor_roma__error('View-File: <strong>' & $file & '.html / '& $file &'.roma.html</strong> konnten nicht gefunden werden.')
	return SetError(2, 0, 0)
endfunc

