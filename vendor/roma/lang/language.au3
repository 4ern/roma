#cs
|-----------------------------------------------------------------------------------------------
|  Language management
|  Sprachenverwaltung
|-----------------------------------------------------------------------------------------------
|  Determines the selected language and use the respective string.
|  Ermittelt die eingestellte Sprache und übergibt den jeweiligen String.
|
#ce
func _vendor_roma__language($key = Default)

	Local $pfad, $i, $aSingle 
	Local Static $oLang
	
	;----------------------------------------------------------------------------------------------/
	; Check if a key was handed over
	; Prüfe ob ein Key übergeben wurde
	;----------------------------------------------------------------------------------------------/
	if $key = default then return SetError(1, 0, 0)

	;----------------------------------------------------------------------------------------------/
	; When the Language-object already exists, give back the key
	; Wenn das Sprachen-Objekt bereits existiert, gebe den Key zurück
	;----------------------------------------------------------------------------------------------/
	if IsObj($oLang) then return $oLang($key)

	;----------------------------------------------------------------------------------------------/
	; Read the Language file
	; Lese die Sprachdatei ein
	;----------------------------------------------------------------------------------------------/
	$pfad = $ROOT & '\views\lang\' & $APP('LANG') & '.ini'

	;----------------------------------------------------------------------------------------------/
	; Prüfen ob Sprach Datei vorhanden ist.
	; 	-> wenn nicht, dann nehme die Standart.
	;----------------------------------------------------------------------------------------------/
	$pfad = FileExists($pfad) ? $pfad : $ROOT & '\vendor\roma\lang\default.ini'

	$aIni = IniReadSection($pfad, $APP('LANG'))
	if @error then 
		$LOG('ERROR','Sprache Datei/Sektion nicht gefunden oder ist Leer / The language file may not exist or the section may not exist or is empty')
		return SetError(1, 0, 0)
	endif

	;----------------------------------------------------------------------------------------------/
	; Create an object with the keys
	; Erstellt Object mit Keys
	;----------------------------------------------------------------------------------------------/
	$oLang = ObjCreate('Scripting.Dictionary')
	for $i = 1 to Ubound($aIni) -1
		if $oLang.Exists(StringStripWS($aIni[$i][0], 3)) then ContinueLoop
		$oLang.add(StringStripWS($aIni[$i][0], 3), StringStripWS($aIni[$i][1], 3))
	next

	return $oLang($key)
endfunc
