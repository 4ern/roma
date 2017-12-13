;helper_functions.au3


Func __Array($iLength = 0)
	local $aArray[0]
	Return $aArray
EndFunc


Func __Dict($iCompareMode = 1)
	local $oDict = ObjCreate('Scripting.Dictionary')
	$oDict.CompareMode = $iCompareMode
	Return $oDict
EndFunc


Func _VarTypeOf($vVariable)
	Switch VarGetType($vVariable)
		Case 'String'
			Return '<String Variant>'
		Case 'Object'
			Return StringFormat('<%s %s>', 'Object', (ObjName($vVariable) = "") ? 'Custom' : ObjName($vVariable))
		Case Else
			Return StringFormat('<%s>', VarGetType($vVariable))
	EndSwitch
EndFunc

Func _oFile($sFilePath)
	_AutoItObject_Startup()
	local $class = _AutoItObject_Class()
	With $class
		.AddProperty('name', $ELSCOPE_READONLY, $sFilePath)
		.AddProperty('datetime', $ELSCOPE_READONLY, FileGetTime($sFilePath, 0, 1))
	EndWith
	Return $class.Object
EndFunc