;----------------------------------------------------------------------------------------------/
; Funktionsvariablen für wichtige Scriptfunktionen
;----------------------------------------------------------------------------------------------/
GLOBAL CONST $route_GET  = _vendor_roma_core_route__constructor
GLOBAL CONST $route_POST = _vendor_roma_core_route__constructor
GLOBAL CONST $ROOT       = StringReplace(@scriptdir, 'vendor', '')
GLOBAL CONST $APP        = _vendor_roma_core_container__app
GLOBAL CONST $GUI        = _vendor_roma_core_container_gui
GLOBAL CONST $VIEW		 = _vendor_roma_core_view__create
GLOBAL CONST $toVIEW	 = _vendor_roma_core_container__view_vars
Global Const $input_all  = _vendor_roma_core_request__all
Global Const $input_has  = _vendor_roma_core_request__has
Global Const $input_get  = _vendor_roma_core_request__get
;----------------------------------------------------------------------------------------------/
; Übernhemen die INI Einstellungen
;----------------------------------------------------------------------------------------------/
func _vendor_roma_core_app__initial()
	
	;----------------------------------------------------------------------------------------------/
	; Übernehme APP Einstellungen
	;----------------------------------------------------------------------------------------------/
	$APP(_config_app__app_settings(), 'set')

	;----------------------------------------------------------------------------------------------/
	; Übernehme GUI Einstellungen
	;----------------------------------------------------------------------------------------------/
	$GUI(_config_app__autoit_options(), 'set')

	;----------------------------------------------------------------------------------------------/
	; Setze AutoIt Optionen
	;----------------------------------------------------------------------------------------------/
	Local $aAutoItOptions = IniReadSection($ROOT & '/config/app.ini', 'autoit-options')
	for $i = 0 to Ubound($aAutoItOptions) -1
		AutoItSetOption($aAutoItOptions[$i][0],$aAutoItOptions[$i][1])
	next
endfunc