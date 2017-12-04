;----------------------------------------------------------------------------------------------/
; Set your global application settings
;----------------------------------------------------------------------------------------------/
func _config_app__app_settings()
    
    local $aReturn[][] = [ _ 
        ['NAME', 'roma() - AutoIt-Framework (by 4ern.de)' ], _
        ['VERSION', '1.0.0.1' ], _ 
        ['BETA', '1.0.0.1' ], _ 
        ['LANG', 'de_DE' ], _ 
        ['DEBUG', false ], _ 
        ['IP', '127.0.0.1' ], _ 
        ['PORT', 8080 ], _ 
        ['LOG', 'weekly' ] _ 
    ]

    return $aReturn
endfunc

;----------------------------------------------------------------------------------------------/
; Set your Opt-Settings
;----------------------------------------------------------------------------------------------/
func _config_app__autoit_options()

    local $aReturn[][] = [ _ 
        ['MustDeclareVars', 0 ], _
        ['TCPTimeout', 100 ], _ 
        ['TrayAutoPause', 0 ], _ 
        ['TrayIconDebug', 0 ], _ 
        ['TrayIconHide', 0 ] _ 
    ]

    return $aReturn
endfunc

;----------------------------------------------------------------------------------------------/
; Set Gui for your Application
;
; 'browser'     -> Application use your default browser
; 'ie_embedded'	-> Application use internet explorer
;		
;----------------------------------------------------------------------------------------------/
func _config_app__gui_type()

    local $aReturn[][] = [ _ 
        ['production', 'ie_embedded' ], _
        ['develop', 'browser' ] _ 
    ]

    return $aReturn
endfunc

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
