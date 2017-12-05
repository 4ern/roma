;----------------------------------------------------------------------------------------------/
; Set your global application settings
;----------------------------------------------------------------------------------------------/

$roma_app.NAME    = 'roma() - AutoIt-Framework (by 4ern.de)'
$roma_app.VERSION = '1.0.0.1'
$roma_app.BETA    = '1.0.0.1'
$roma_app.LANG    = 'de_DE'
$roma_app.DEBUG   = false
$roma_app.IP      = '127.0.0.1'
$roma_app.PORT    = 8080
$roma_app.LOG     = 'weekly'

;----------------------------------------------------------------------------------------------/
; Set your Opt-Settings
;----------------------------------------------------------------------------------------------/

$roma.addOpt('MustDeclareVars', 0)
$roma.addOpt('TCPTimeout', 100)
$roma.addOpt('TrayAutoPause', 0)
$roma.addOpt('TrayIconDebug', 0)
$roma.addOpt('TrayIconHide', 0)

;----------------------------------------------------------------------------------------------/
; Set Gui for your Application
;
; 'browser'     -> Application use your default browser
; 'ie_embedded'	-> Application use internet explorer
;		
;----------------------------------------------------------------------------------------------/

$roma_app.gui_production = 'ie_embedded'
$roma_app.gui_develop    = 'browser'

;----------------------------------------------------------------------------------------------/
; AutoIt GUI Settings
;----------------------------------------------------------------------------------------------/
func _config_app__gui_settings()

    local $aReturn[][] = [ _ 
        ['width', 800 ], _
        ['height', 500 ], _
        ['left', -1 ], _
        ['top', -1 ], _
        ['style', -1 ], _
        ['exstyle', -1 ] _ 
    ]

    return $aReturn
endfunc
