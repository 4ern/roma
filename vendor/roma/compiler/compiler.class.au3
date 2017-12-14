#include-once
#include "..\..\Autoit\File.au3"
#include "..\..\Autoit\Array.au3"
#include "..\..\AspirinJunkie\JSON.au3"
#include '..\..\AutoItObject\AutoItObject.au3'
#include '..\helper.class.au3'

global $roma_compiler = obj_compiler()

#cs ───────────────────────────────────────────────────────────────────────────────────────────────
 obj_compiler
 ──────────────────────────────────────────────────────────────────────────────────────────────────
 Description: 

 Author: 		4ern
 Created:		2017-12-12
#ce ───────────────────────────────────────────────────────────────────────────────────────────────
func obj_compiler()

	_AutoItObject_StartUp()
    local $this = _AutoItObject_Class()

	; declare propertys & methods
	; ───────────────────────────────────────────────────────────────────────────────────────────────
	with $this

		.AddProperty('a_project_files', $ELSCOPE_READONLY, $roma_helper.Array())
		.AddProperty('s_compiler_path', $ELSCOPE_READONLY, @ScriptDir & '\dist\')
		.AddProperty('s_exclude_files', $ELSCOPE_READONLY, 'README.md;README_EN.MD;LICENSE;.gitignore;test.au3;.DS_Store;compiler.json;compiler.class.au3;*.isn')
		.AddProperty('s_exclude_folder', $ELSCOPE_READONLY, '.git;storage;dist')
		
		; methods before run script
		; ───────────────────────────────────────────────────────────────────────────────────────────────
		.AddMethod('__default__', '__constructor')
		.AddMethod('get_project_files', '_meth_get_project_files')
		.AddMethod('copy_files', '_meth_copy_files')
		.AddMethod('set_namespace', '_meth_set_namespace')

	endwith

    return $this.object
endfunc

#cs :: constructor
 Method:       PUBLIC
 @return:      void
#ce ──────────────────────────────────────────────────────────────────────────────────────────────
func __constructor($this)

	$this.get_project_files()
	$this.copy_files()
;~ 	$this.set_namespace()

endfunc

#cs :: get project files
 Method: 		Private
 @return: 		void
#ce ──────────────────────────────────────────────────────────────────────────────────────────────
Func _meth_get_project_files($this)
	
	local $aFileList = _FileListToArrayRec('.', '*|' & $this.s_exclude_files &'|' & $this.s_exclude_folder, 1, 1)

	local $aProjectFiles = $roma_helper.Array()
	For $i = 1 To $aFileList[0]
		_ArrayAdd($aProjectFiles, $roma_helper.File($aFileList[$i]))
	Next

	$this.a_project_files = $aProjectFiles
	
	Return $this
	
endfunc

#cs :: copy files to dist
 Method:       PRIVATE
 @return:      void
#ce ──────────────────────────────────────────────────────────────────────────────────────────────
func _meth_copy_files($this)
	
	local $aOldFiles = $roma_helper.Array()
	If FileExists('.\dist') Then
		$aOldFiles = _FileListToArrayRec('.\dist', '*', 1, 1)
	EndIf
	
	For $item in $this.a_project_files
		ConsoleWrite('Copying file "' & $item.name & '".' & @CRLF)
		FileCopy($item.name, $this.s_compiler_path & $item.name, 8 + 1)
		local $iIndex = _ArraySearch($aOldFiles, $item.name)
		If $iIndex <> -1 Then
			$aOldFiles[$iIndex] = Null
		EndIf
	Next
	
	For $i = 1 To UBound($aOldFiles)-1
		If $aOldFiles[$i] <> Null Then
			ConsoleWrite('Deleting old file ".\dist\' & $aOldFiles[$i] & '".' & @CRLF)
			FileDelete('.\dist\' & $aOldFiles[$i])
		EndIf
	Next
	
	If Not FileExists($this.s_compiler_path & 'storage') then
		DirCreate($this.s_compiler_path & 'storage')
	EndIf
		
	Return $this
	
endfunc

#cs :: get all *.class.au3 files
 Method:       PRIVATE
 @return:      void
#ce ──────────────────────────────────────────────────────────────────────────────────────────────
func _meth_set_namespace($this)
	For $file in $this.a_project_files
		If Not StringRegExp($file.name, '(?i)\.class\.au3$') Then ContinueLoop
		
		local $hFile = FileOpen('dist\' & $file.name)
		local $sFile = FileRead($hFile)
		If @error Then
			ConsoleWrite(StringFormat('Error reading file "%s": @error = %d, @extended = %d', $file.name, @error, @extended) & @CRLF)
			ContinueLoop
		EndIf

		
		; get namespace
		; ───────────────────────────────────────────────────────────────────────────────────────────────
		local $aNamespace = StringRegExp($sFile,'(;use.)(.*)',2)
		if IsArray($aNamespace) = 0 then ContinueLoop
		local $sNamespace = $aNamespace[2]

		

		; Bringe alle addmethod in eine einheitliche form
		; ───────────────────────────────────────────────────────────────────────────────────────────────
		local $pattern  = '(?i)(.addmethod\()(.*)'
		local $a_methods = StringRegExp($sFile, $pattern, 4)

		for $i = 0 to UBound($a_methods) -1
			$a_method = $a_methods[$i]
			$sFile = StringReplace($sFile, $a_method[0], StringStripWs($a_method[0], 8))
		next

		; set namespcae
		; ───────────────────────────────────────────────────────────────────────────────────────────────
		local $pattern = '(?i)(\.addmethod\(.\w*.{3})(\w*)(?:.\))|(?:_AutoItObject_AddMethod\(\$\w*.{2}\w*.{3})(\w*)(?:.\))'
		local $a_methods = StringRegExp( StringStripWS($sFile, 8), $pattern, 4)

		For $i = 0 to UBound($a_methods) -1
			$a_method = $a_methods[$i]
			$s_method = StringReplace($a_method[0], $a_method[2], '_' & $sNamespace & '__' & $a_method[2])
			$sFile = StringReplace($sFile, $a_method[0], $s_method)
		Next


		Local $hFile = FileOpen('dist\' & $file.name, 2)
		FileWrite($hFile, $sFile)
		FileClose($hFile)

	Next
	
	Return $this


endfunc