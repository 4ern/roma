#cs
|-----------------------------------------------------------------------------------------------
| UDF Aliases
|----------------------------------------------------------------------------------------------
| Function variables.
| With this aliases the UDF functions can be distinguished easily form your own functions.
|
| Funktionsvariablen. 
| Mit Aliasen lassen sich die Package (UDF) Funktionensnamen auf eigenen Wunsch anpassen,
| ohne die Funktionsnamen im gesamten Script zu ändern.
|
#ce

;----------------------------------------------------------------------------------------------/
; 4ERN LOG PACKAGE ALIASES
; 	-> DIESES PACKAGE WIRD IM GESAMTEN FRAMEWORK VERVENDEN.
; 	   Du kannst es hier ersetzen, achte jedoch, auf die parameter!
;----------------------------------------------------------------------------------------------/
Global Const $LOG    = _vendor_roma__log

;----------------------------------------------------------------------------------------------/
; 4ERN LANGUAGE PACKAGE ALIASES
; 	-> DIESES PACKAGE WIRD IM GESAMTEN FRAMEWORK VERVENDEN.
; 	   Du kannst es hier ersetzen, achte jedoch, auf die parameter!
;----------------------------------------------------------------------------------------------/
Global Const $LANG   = _vendor_roma__language

;----------------------------------------------------------------------------------------------/
; Ward JSON Package
;----------------------------------------------------------------------------------------------/
Global CONST $toJson      = _vendor_ward_JsonEncode
Global CONST $json_encode = _vendor_ward_JsonEncode
Global CONST $json_decode = _vendor_ward_JsonDecode