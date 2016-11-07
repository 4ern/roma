#cs
|-----------------------------------------------------------------------------------------------
|  HTTP Controller
|-----------------------------------------------------------------------------------------------
|  Establish HTTP-Connection to receive or send data
|  
|  Aufbau der HTTP Verbindung, um Daten zu empfagen oder zu senden.
| 
#ce

;----------------------------------------------------------------------------------------------/
; Description:  = Start of the local web server
; @return:      = TCP Listening Socket
;
; Beschreibung: = Start des localen Webservers
; @return:      = TCP Listening Socket
;----------------------------------------------------------------------------------------------/
func _vendor_roma_core_http__getsocket()

	;----------------------------------------------------------------------------------------------/
	; Declaration of the Listening-Socket as Static variable
	; Deklaration des Listening-Socket als Statische Variable
	;----------------------------------------------------------------------------------------------/
	Local Static $ListeningSocket = 0

	;----------------------------------------------------------------------------------------------/
	; Submit this socket, if it exists
	; Übergebe diesen Socket, falls dieser existiert
	;----------------------------------------------------------------------------------------------/
	if ($ListeningSocket = 0) or ($ListeningSocket = -1) then
	
		;----------------------------------------------------------------------------------------------/
		; Start TCP
		; Starte TCP
		;----------------------------------------------------------------------------------------------/
		TCPStartup()

		;----------------------------------------------------------------------------------------------/
		; Create a Listening-Socket
		; Erstellt ein Listening Socket
		;----------------------------------------------------------------------------------------------/
		$ListeningSocket = TCPListen($APP('IP'), $APP('PORT'), 1)
		if @error then exit $LOG('ERROR', $LANG('error.MainSocket') & @lf & @error)

		;----------------------------------------------------------------------------------------------/
		; Gebe IP mit Port in der Console aus, wenn die App sich im Debug befindet.
		;----------------------------------------------------------------------------------------------/
		$LOG('APPLICATION STARTUP','on URL: http://' & $APP('IP') & ':' & $APP('PORT'))
		
		;----------------------------------------------------------------------------------------------/
		; Starte die GUI
		;----------------------------------------------------------------------------------------------/
		_vendor_roma_core_gui__initail()
	endif

	return $ListeningSocket
endfunc

;----------------------------------------------------------------------------------------------/
; Description: = Connection to the local Webserver
; Beschreibung: = Verbindung zum Lokalen Webservers
;
; Return        = (0)  	NULL Request
; 		        = (1)  	Browser File Request
; 		        = (2)  	User Request
; 		        = (-1) 	Error (see Doc TCPAccept)
; 		        = (-2) 	Error (see Doc TCPRecv)
;----------------------------------------------------------------------------------------------/
func _vendor_roma_core_http__request($action = NULL)

	Local Static $staticSocket = null

	;----------------------------------------------------------------------------------------------/
	; If action = get then return the socket
	; Wenn Aktion = get, übergebe den StaticSocket
	;----------------------------------------------------------------------------------------------/
	if $action = 'get' then 
		if $staticSocket = null then return SetError(1, 0, 'no Socket')
		return $staticSocket
	endif
	
	#cs
	|-----------------------------------------------------------------------------------------------
	|  Create Connection
	|  Erstelle Verbindung
	|-----------------------------------------------------------------------------------------------
	|  Establish TCP-Connection with the Client
	|  Stelle eine TCP-Verbindung zum Client her
	|
	#ce

	;----------------------------------------------------------------------------------------------/
	; Accept incoming Connection
	; Akzeptiere eingehende Verbindung
	;----------------------------------------------------------------------------------------------/
	Local $socket = TCPAccept(_vendor_roma_core_http__getsocket())
	if ($socket = -1) then
		TCPCloseSocket($socket)
		return SetError(@error, 0, -1)
	endif

	;----------------------------------------------------------------------------------------------/
	; Erstelle ein statischen Socket
	;----------------------------------------------------------------------------------------------/
	$staticSocket = $socket

	;----------------------------------------------------------------------------------------------/
	; Retrieves data from the TCP channel
	; Ermittelt die Daten aus dem TCP-Kanal
	;----------------------------------------------------------------------------------------------/
	$sData = TCPRecv($socket,2024)
	if (@error = -1) or (@error = -2) then 
		TCPCloseSocket($socket)
		return SetError(@error, 0, -2)
	endif


	#cs
	|-----------------------------------------------------------------------------------------------
	| Request
	|-----------------------------------------------------------------------------------------------
	|  process Request
	|  Verarbeite Anfrage
	|
	#ce

	;----------------------------------------------------------------------------------------------/
	; Determine request methode
	; Execute the necessary inquiries of operations/functions
	;
	; Ermittle Request Methode (GET, POST)
	; Führe die notwendigen Anfragen der Operationen/Funktion aus
	;----------------------------------------------------------------------------------------------/
	$aRequest = StringSplit(StringSplit($sData, @lf, 2)[0], ' ', 2)	
	if (StringLen($aRequest[0]) == 0) then 
		_vendor_roma_core_http_response_data('html', '' , 403)
		return SetError(0, 0, 0)
	endif

	;----------------------------------------------------------------------------------------------/
	; Resete die evtl. alte Request Variablen
	;----------------------------------------------------------------------------------------------/
	_vendor_roma_core_request__container('', 'reset')

	;----------------------------------------------------------------------------------------------/
	; Verarbeite GET Request
	;----------------------------------------------------------------------------------------------/
	if $aRequest[0] == 'GET' then 

		;----------------------------------------------------------------------------------------------/
		; Parse GET Request (GET Variablen)
		;----------------------------------------------------------------------------------------------/
		_vendor_roma_core_request__parse_get($aRequest[1])

		;----------------------------------------------------------------------------------------------/
		; Check whether it is a file or not.
		; If so send it directly to the server.
		;
		; Prüft, ob es sich um eine Datei handelt. 
		; Wenn ja schicke diese direkt an den Server.
		;----------------------------------------------------------------------------------------------/
		if StringInStr($aRequest[1], '.') then 
			_vendor_roma_core_http__prepare_file_request($aRequest[1])
			return true
		endif

		;----------------------------------------------------------------------------------------------/
		; Return and set request
		;----------------------------------------------------------------------------------------------/
		return _vendor_roma_core_container__http('setRequest', $aRequest[1], 'GET')
	endif

	;----------------------------------------------------------------------------------------------/
	; Verarbeite POST Request
	;----------------------------------------------------------------------------------------------/
	if $aRequest[0] == 'POST' then

		;----------------------------------------------------------------------------------------------/
		; Parse GET Request (GET Variablen)
		;----------------------------------------------------------------------------------------------/
		_vendor_roma_core_request__parse_post($sData)

		;----------------------------------------------------------------------------------------------/
		; Check whether it is a file or not.
		; If so send it directly to the server.
		;
		; Prüft, ob es sich um eine Datei handelt. 
		; Wenn ja schicke diese direkt an den Server.
		;----------------------------------------------------------------------------------------------/
		if StringInStr($aRequest[1], '.') then 
			_vendor_roma_core_http__prepare_file_request($aRequest[1])
			return false
		endif
		
		;----------------------------------------------------------------------------------------------/
		; Return and set request
		;----------------------------------------------------------------------------------------------/
		return _vendor_roma_core_container__http('setRequest', $aRequest[1], 'POST')
	endif

	return false
endfunc

;----------------------------------------------------------------------------------------------/
; Description:  = processing of GET requests
; @return:      = 1
; @error (1)    = file is missing
;
; Beschreibung: = Verarbeitung der GET Requestes
; @return:      = 1
;----------------------------------------------------------------------------------------------/
func _vendor_roma_core_http__prepare_file_request($request)
	
	;----------------------------------------------------------------------------------------------/
	; Convert HTTP-Path into a Windows-Path
	; Konventiere HTTP Pfad in ein Windows Pfad
	;----------------------------------------------------------------------------------------------/
	$request = StringReplace($request, '/', '\')

	;----------------------------------------------------------------------------------------------/
	; Create complete file path
	; Erstelle komplette Datei Pfad
	;----------------------------------------------------------------------------------------------/
	$sFile = $ROOT & '\views' & $request

	;----------------------------------------------------------------------------------------------/
	; Check if the requested file exists
	; Prüfe ob die angefordete Datei exsistiert
	;----------------------------------------------------------------------------------------------/
	If FileExists($sFile) = 0 Then 
		$LOG('ERROR', $LANG('error.404'))
		$sFile     = $ROOT & '\views\errors\404.html'
		$MIME_TYPE = _vendor_roma_core_container__mimetype('html')
		
		if not FileExists($sFile) then
			$sFile =  '<!DOCTYPE html><html><head><title>roma 404</title></head>'
			$sFile &= '<body><h1>'&$LANG('error.404')&'</h1></body></html>'
			return _vendor_roma_core_http_response_data($MIME_TYPE, Binary($sFILE), 404)
		endif
	endif

	;----------------------------------------------------------------------------------------------/
	; - Determine the requested file type
	; - Send the file to the browser
	;
	; - Ermittle den angeforderten Datei Typ
	; - Sende die Datei an den Browser
	;----------------------------------------------------------------------------------------------/
	$aFileTyp  = StringSplit($sFile, '.', 0)
	$MIME_TYPE = _vendor_roma_core_container__mimetype($aFileTyp[UBound($aFileTyp)-1])

	;----------------------------------------------------------------------------------------------/
	; Send the file to the browser
	; Sende die angefordete Datei an den Browser
	;----------------------------------------------------------------------------------------------/
	return _vendor_roma_core_http_response_data($MIME_TYPE, $sFile)
endfunc

;----------------------------------------------------------------------------------------------/
; Description:  = Send the file to the Browser
; Beschreibung: = Sendet die Daten an den Browser
;----------------------------------------------------------------------------------------------/
func _vendor_roma_core_http_response_data($MIME_TYPE, $data = False , $responseCode = 200)

	;----------------------------------------------------------------------------------------------/
	; Read the file into Binary Code
	; Lese die Datei Binär ein 
	;----------------------------------------------------------------------------------------------/
	if IsString($data) then
		$hFile = FileOpen($data, 16)
		$bFile = FileRead($hFile)
		FileClose($hFile)
	else
		$bFile = $data
	endif

	;----------------------------------------------------------------------------------------------/
	; Ermittle die Response Nachricht
	;----------------------------------------------------------------------------------------------/
	Local $responseMsg = _vendor_roma_core_container__response($responseCode)

	;----------------------------------------------------------------------------------------------/
	; Holle den Socket
	;----------------------------------------------------------------------------------------------/
	Local $socket = _vendor_roma_core_http__request('get')

	;----------------------------------------------------------------------------------------------/
	; Create package
	; Erstelle Paket
	;----------------------------------------------------------------------------------------------/
	$sName   = StringFormat('%s - VERSION:%s | (roma AutoIt Framework)', $APP('NAME'), $APP('VERSION'))
	$sPacket =  'HTTP/1.1' & $responseCode &' '& $responseMsg & @CRLF
	$sPacket &= 'Server: ' & $sName & @CRLF
	$sPacket &= 'Connection: keep-alive' & @CRLF
	$sPacket &= 'Accept-Ranges: bytes' & @CRLF
	$sPacket &= 'Content-Lenght: ' & BinaryLen($bFile) & @CRLF
	$sPacket &= 'Date:' & _WinHttpTimeFromSystemTime() & @CRLF
	$sPacket &= 'Keep-Alive: timeout=5, max=100'& @CRLF
	$sPacket &= 'Content-Type: ' & $MIME_TYPE & '; charset=UTF-8' & @CRLF & @CRLF
	$binaryPackt = Binary($sPacket)

	;----------------------------------------------------------------------------------------------/
	; Send the binary data in small pieces
	; Versand der Binärdaten in kleinen Stücken
	;----------------------------------------------------------------------------------------------/
    TCPSend($socket,$binaryPackt)
   
    While BinaryLen($bFile)
        $iBytes = TCPSend($socket, $bFile)
        $bFile  = BinaryMid($bFile, $iBytes+1, BinaryLen($bFile)-$iBytes)
    WEnd
   
    $sPacket = Binary(@CRLF & @CRLF)
    TCPSend($socket,$sPacket)
    TCPCloseSocket($socket)
endfunc

