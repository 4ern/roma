;helper.class.au3

#include-once

#pragma Class(Compile, false)
#pragma Class(Namespace, vendor_roma)


Global $roma_helper = _Helper__new()

Func _Helper__new()
	_AutoItObject_Startup()
	local $class = _AutoItObject_Class()
	With $class		
		.AddMethod('Array', '_Helper__array')
		.AddMethod('Dict',  '_Helper__dict')
		.AddMethod('TypeOf', '_Helper__typeof')
		
		.AddMethod('File', '_Helper_File__new')
	EndWith
	Return $class.Object
EndFunc


Func _Helper__array($oSelf)
	local $aArray[0]
	Return $aArray
EndFunc


Func _Helper__dict($oSelf, $iCompareMode = 1)
	local $oDict = ObjCreate('Scripting.Dictionary')
	$oDict.CompareMode = $iCompareMode
	Return $oDict
EndFunc


Func _Helper__typeof($oSelf, $vTest)
	Switch VarGetType($vTest)
		Case 'String'
			Return '<String Variant>'
		Case 'Object'
			Return StringFormat('<%s %s>', 'Object', (ObjName($vTest) = "") ? 'Custom' : ObjName($vTest))
		Case Else
			Return StringFormat('<%s>', VarGetType($vTest))
	EndSwitch
EndFunc


Func _Helper_File__new($oSelf, $sFilePath = Default)
	_AutoItObject_Startup()
	local $class = _AutoItObject_Class()
	With $class
		.AddProperty('name', $ELSCOPE_READONLY, ($sFilePath <> Default) ? $sFilePath : Null)
		.AddProperty('datetime', $ELSCOPE_READONLY, ($sFilePath <> Default) ? FileGetTime($sFilePath, 0, 1) : Null)
	EndWith
	Return $class.Object
EndFunc