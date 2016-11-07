#include-once

; #FUNCTION# ===================================================================
; Name ..........: $LOG
; Description ...: Simple Log Funktion. Es wird eine Log Datei in Storage Logs erstellt.
;				   Zudem wird ein Consolewrite Befehl ausgeführt.
; Parameters ....: $type
; .....optional..: $message
; Requirement ...: #include <Date.au3>
; Return values .: 
; Author ........: 4ern.de
; ==============================================================================
func _vendor_roma__log($type = 'ERROR', $message = '')
	
	Local $filePath, $logName, $hLog, $timestamp, $str

	;----------------------------------------------------------------------------------------------/
	; Logname
	;----------------------------------------------------------------------------------------------/
 	$logName = stringformat('%s.%s.%s', @MDAY, @MON, @YEAR)
	if $APP('LOG') == 'weekly' then $logName = stringformat('KW-%s', _WeekNumberISO(@YEAR, @MON,@MDAY), @YEAR)
	if $APP('LOG') == 'monthly' then $logName = stringformat('%s.%s', @MON, @YEAR)

	;----------------------------------------------------------------------------------------------/
	; Timestamp
	;----------------------------------------------------------------------------------------------/
	$timestamp = StringFormat('%s.%s.%s - %s:%s:%s.%s', @MDAY, @MON, @YEAR, @HOUR, @MIN, @SEC, @MSEC)

	;----------------------------------------------------------------------------------------------/
	; Generiere Dateiname + Pfad
	;----------------------------------------------------------------------------------------------/
	$filePath = @scriptdir & '\storage\logs\' & $logName & '.log'

	;----------------------------------------------------------------------------------------------/
	; Erstelle den Log String
	;----------------------------------------------------------------------------------------------/
	$str  = @CRLF & '**************************************************************************************************' & @crlf
	$str &= '* ' & $type & ' -- '& $timestamp & @crlf
	$str &= '* ' & $message & @crlf

	;----------------------------------------------------------------------------------------------/
	; Führe Consolewrite Befehl aus
	;----------------------------------------------------------------------------------------------/
	ConsoleWrite($str)

	;----------------------------------------------------------------------------------------------/
	; Prüfe ob bereits ein Log mit diesem Datum exsitiert
	;----------------------------------------------------------------------------------------------/
	$hLog = FileOpen($filePath,1)
	FileWrite($hLog, $str) 
	FileClose($hLog)
endfunc
