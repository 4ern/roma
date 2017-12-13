#include-once
#include "..\..\Autoit\File.au3"
#include "..\..\Autoit\Array.au3"
#include "..\..\AspirinJunkie\JSON.au3"
#include '..\..\AutoItObject\AutoItObject.au3'

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

		.AddProperty('a_project_files', $ELSCOPE_PRIVATE)
		.AddProperty('s_compiler_path', $ELSCOPE_PRIVATE, @ScriptDir & '\dist\')
		.AddProperty('s_exclude_files', $ELSCOPE_PRIVATE, 'README.md;README_EN.MD;LICENSE;.gitignore;test.au3;.DS_Store;compiler.json;compiler.class.au3')
		.AddProperty('s_exclude_folder', $ELSCOPE_PRIVATE, '.git;storage;dist')
		
		; methods before run script
		; ───────────────────────────────────────────────────────────────────────────────────────────────
		.AddMethod('__default__', '__constructor')
		.AddMethod('get_project_files', '_meth_get_project_files', true)
		.AddMethod('copy_files', '_meth_copy_files', true)
		.AddMethod('set_namespace', '_meth_set_namespace', true)

	endwith

    return $this.object
endfunc

#cs :: constructor
 Method:       PUBLIC
 @return:      void
#ce ──────────────────────────────────────────────────────────────────────────────────────────────
func __constructor($this)

	;~ $this.get_project_files
	;~ $this.copy_files
	$this.set_namespace

endfunc

#cs :: get project files
 Method: 		Private
 @return: 		void
#ce ──────────────────────────────────────────────────────────────────────────────────────────────
func _meth_get_project_files($this)

	local $aFileList = _FileListToArrayRec('.', '*|' & $this.s_exclude_files &'|' & $this.s_exclude_folder, 1, 1)
	local $project_files[UBound($aFileList)][3]

	; create array with path and modified date
	; ───────────────────────────────────────────────────────────────────────────────────────────────
	for $i = 1 to UBound($aFileList) -1
		$project_files[$i][0] = $aFileList[$i]
		$project_files[$i][1] = FileGetTime($aFileList[$i], 0, 1)
	next

	$this.a_project_files = $project_files
endfunc

#cs :: copy files to dist
 Method:       PRIVATE
 @return:      void
#ce ──────────────────────────────────────────────────────────────────────────────────────────────
func _meth_copy_files($this)
	
	; copy files if modified
	; ───────────────────────────────────────────────────────────────────────────────────────────────
	for $i = 0 to  UBound($this.a_project_files) -1
		if $this.a_project_files[$i][2] <> 0 then
			FileCopy($this.a_project_files[$i][0], $this.s_compiler_path & $this.a_project_files[$i][0], 8 + 1)
		endif
	next

	; check if storage dir exists
	; if not exists = create dir
	; ───────────────────────────────────────────────────────────────────────────────────────────────
	if (FileExists($this.s_compiler_path & 'storage') = 0 ) then DirCreate($this.s_compiler_path & 'storage')
	
endfunc

#cs :: get all *.class.au3 files
 Method:       PRIVATE
 @return:      void
#ce ──────────────────────────────────────────────────────────────────────────────────────────────
func _meth_set_namespace($this)

	local $aFileList = _FileListToArrayRec('./dist',  '*.class.au3', 1, 1)
	
    for $i = 1 to UBound($aFileList) -1

		$fOpen = FileOpen('dist\' & $aFileList[$i], 2)
		$sFile = FileRead($fOpen)
		
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

		ConsoleWrite($sFile)

		; set namespcae
		; ───────────────────────────────────────────────────────────────────────────────────────────────
		local $pattern = '(?i)(\.addmethod\(.\w*.{3})(\w*)(?:.\))|(?:_AutoItObject_AddMethod\(\$\w*.{2}\w*.{3})(\w*)(?:.\))'
		local $a_methods = StringRegExp( StringStripWS($sFile, 8), $pattern, 4)

		For $i = 0 to UBound($a_methods) -1
			$a_method = $a_methods[$i]
			$s_method = StringReplace($a_method[0], $a_method[2], $namespace & '__' & $a_method[2])
			$sFile = StringReplace($sFile, $a_method[0], $s_method)
		Next

		FileWrite($fOpen, $sFile)
	next

endfunc