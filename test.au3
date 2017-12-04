#include 'vendor\autoit\array.au3'

Func _config_app__app_settings()

    local $aReturn[][] = [ _ 
        ['production', 'ie' ], _
        ['develop', 'browser' ] _ 
    ]

    return $aReturn
EndFunc


_ArrayDisplay(_config_app__app_settings())