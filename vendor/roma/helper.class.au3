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
		.AddMethod('ClassObject', '_Helper_ClassObject__new')
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


Func _Helper_ClassObject__new($oSelf, $sFilePath)

	Local $sPragmaDirectives = 'compile|namespace'

	If not FileExists($sFilePath) Then
		Return SetError(1,0)
	EndIf

	Local $sFullPath = _PathFull($sFilePath)
	Local $sDrive, $sDir, $sFileName, $sExtension
	Local $aPathSplit = _PathSplit($sFullPath, $sDrive, $sDir, $sFileName, $sExtension)
	Local $sClassName = StringReplace($sFileName, '.class', '', 1)

	; loading file content
	local $hFile = FileOpen($sFilePath)
	local $sContent = FileRead($hFile)
	FileClose($hFile)

	; Parse content and find #pragma Class(Compile, True|False)
	Local $bCompile = False
	Local $sNamespace = ""
	Local $aCompileRegExp = StringRegExp($sContent,'(?mi)^(?:\#pragma.class\()(' & $sPragmaDirectives & ')\s?\,\s?(.*)\).*$', 3)
	If IsArray($aCompileRegExp) Then
		For $i = 0 To UBound($aCompileRegExp)-1 Step 2
			If StringLower($aCompileRegExp[$i]) = 'compile' Then
				$bCompile = (StringLower($aCompileRegExp[$i+1]) = 'true') ? True : False
			ElseIf StringLower($aCompileRegExp[$i]) = 'namespace' Then
				$sNamespace = $aCompileRegExp[$i+1]
			EndIf
		Next
	EndIf

	

	_AutoItObject_Startup()
	local $class = _AutoItObject_Class()
	With $class
		.AddProperty('ClassName', $ELSCOPE_READONLY, $sClassName)
		.AddProperty('Namespace', $ELSCOPE_READONLY, $sNamespace)
		.AddProperty('Compile', $ELSCOPE_READONLY, $bCompile)
		.AddProperty('ContentRaw', $ELSCOPE_READONLY, $sContent)
		.AddProperty('ContentParsed', $ELSCOPE_READONLY, null)
		.AddProperty('FileFullPath', $ELSCOPE_READONLY, $sFullPath)
		.AddProperty('FileName', $ELSCOPE_READONLY, $sFileName)
		.AddProperty('FileExtension', $ELSCOPE_READONLY, $sExtension)
		.AddProperty('FileFolderPath', $ELSCOPE_READONLY, $sDrive & $sDir)
		.AddMethod('Compile', '_Helper_ClassObject__compile')
	EndWith
	Return $class.Object
EndFunc

Func _Helper_ClassObject__compile($oSelf)
	If $oSelf.Compile Then
		; Do compile/translate stuff using $oSelf.ContentRaw

		Return True
	Else
		Return SetError(1,0)
	EndIf
EndFunc