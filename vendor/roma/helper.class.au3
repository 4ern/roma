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
		.AddMethod('ArrayInfo', '_Helper__arrayinfo')
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


Func _Helper__arrayinfo($oSelf, ByRef $aArray)
	If Not VarGetType($aArray) = 'Array' Then
		Return SetError(1,0)
	EndIf
	local $iArrayLength = UBound($aArray)
	
	local $sHeader = ""
	$sHeader &= "Array Info:" & @CRLF
	$sHeader &= "Length = " & $iArrayLength & @CRLF
	ConsoleWrite($sHeader)
	
	local $sBody = ""
	For $i = 0 To $iArrayLength-1
		local $sType = VarGetType($aArray[$i])
		
		If $sType = 'Array' Then
			$sBody &= StringFormat('| %d | [Array] |', $i) & @CRLF
			
		ElseIf $sType = 'Object' Then
			$sBody &= StringFormat('| %d | {Object} |', $i) & @CRLF
			
		Else
			$sBody &= StringFormat('| %d | %s |', String($aArray[$i])) & @CRLF
		EndIf
	Next
	ConsoleWrite($sBody)
	
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