#cs
|-----------------------------------------------------------------------------------------------/
| WICHTIG!!!
|-----------------------------------------------------------------------------------------------/
|
| BITTE DIESE DATEI NICHT LÖSCHEN ODER VERSCHIEBEN. 
| Hier werden direkt zum Start alle notwendigen Applikations-Funktionen angesteuert.
|
| PS: 
|  Möchtest du ein Package implementieren, dann bitte nicht hier sondern in config\packages.au3
|  Wenn du eine Funktion direkt beim Start ausführen möchtest, dann nutze bitte die Datei "config\onStart.au3".
|
#ce
#include-once
#include '..\config\packages.au3'
#include '..\config\aliases.au3'
#include '..\config\onStart.au3'
#include 'roma\core\http.au3'
#include 'roma\core\request.au3'
#include 'roma\core\route.au3'
#include 'roma\core\view.au3'
#include 'roma\core\template.au3'
#include 'roma\core\app.au3'
#include 'roma\core\gui.au3'
#include 'roma\core\container.au3'
#include 'roma\error.au3'
#include 'roma\mvc_inc.au3'

_vendor_roma_core_app__initial()
_vendor_roma_core_container__mimetype(default, 'set')
_vendor_roma_core_container__response(default, 'set')
_roma_config_onStart()

;----------------------------------------------------------------------------------------------/
; Start MainLoop
;----------------------------------------------------------------------------------------------/
#include 'roma\core\loop.au3'
