#cs
|-----------------------------------------------------------------------------------------------
|  Mainloop
|  Hauptschleife
|-----------------------------------------------------------------------------------------------
|  Endless loop of the Application
|  Endlosschleife der Applikation
|
#ce

while sleep(5)

	;----------------------------------------------------------------------------------------------/
	; Führe Routes aus
	;----------------------------------------------------------------------------------------------/
	if _vendor_roma_core_http__request() then

		;----------------------------------------------------------------------------------------------/
		; Prüfe ob ein Route exsistiert und führe diese aus
		;----------------------------------------------------------------------------------------------/
		_roma_routes()

		;----------------------------------------------------------------------------------------------/
		; Prüfe ob der Request durchgeführt wurde. Also in einem Route behandelt wurde.
		;	-> Wenn nicht, dann schicke ein Response 403.
		;----------------------------------------------------------------------------------------------/
		if _vendor_roma_core_container__http('isREQUEST') then
			$LOG('ERROR','403' & $LANG('error.403'))
			$sFile     = $ROOT & '\views\errors\403.html'
			$MIME_TYPE = _vendor_roma_core_container__mimetype('html')

			if not FileExists($sFile) then
				$sFile =  '<!DOCTYPE html><html><head><title>roma - 403 bad request</title></head>'
				$sFile &= '<body><h1>'&$LANG('error.403')&'</h1></body></html>'
				$sFile = Binary($sFile)
			endif

			_vendor_roma_core_http_response_data($MIME_TYPE,$sFile, 403)
			_vendor_roma_core_container__http('reset')
		endif
	endif
wend