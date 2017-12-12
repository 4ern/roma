#include-once
#include "../../Autoit/File.au3"
#include "../../Autoit/Array.au3"
#include "../../AspirinJunkie/JSON.au3"

global $roma_compiler = obj_compiler()

#cs ───────────────────────────────────────────────────────────────────────────────────────────────
 obj_compiler
 ──────────────────────────────────────────────────────────────────────────────────────────────────
 Description: 

 Author: 		4ern
 Created:		2017-12-12
 ───────────────────────────────────────────────────────────────────────────────────────────────#ce
func obj_compiler()

    local $this = _AutoItObject_Class()

	; declare propertys & methods
	; ───────────────────────────────────────────────────────────────────────────────────────────────
	with $this

		.AddProperty('a_project_files', $ELSCOPE_PRIVATE)
		.AddProperty('a_compiler_json', $ELSCOPE_PRIVATE)
		.AddProperty('s_compiler_path', $ELSCOPE_PRIVATE, @ScriptDir & '\dist\')
		.AddProperty('s_exclude_files', $ELSCOPE_PRIVATE, 'README.md;README_EN.MD;LICENSE;.gitignore;test.au3')
		.AddProperty('s_exclude_folder', $ELSCOPE_PRIVATE, '.git;storage')
		
		; methods before run script
		; ───────────────────────────────────────────────────────────────────────────────────────────────
		.AddMethod('__default__', '__constructor', true)
		.AddMethod('get_project_files', '_meth_get_project_files', true)
		.AddMethod('get_compiler_json', '_meth_get_compiler_json', true)
		.AddMethod('compare_file_timestamps', '_meth_compare_file_timestamps', true)
		.AddMethod('copy_files', '_meth_copy_files', true)

		; methods after run script
		; ───────────────────────────────────────────────────────────────────────────────────────────────
		.AddMethod('create_compiler_json', '_meth_create_compiler_json', true)

	endwith

    return $this.object
endfunc

#cs :: constructor
 Method:       PUBLIC
 @return:      void
────────────────────────────────────────────────────────────────────────────────────────────── #ce
func __constructor($this)

	$this.get_project_files
	$this.get_compiler_json
	$this.compare_file_timestamps
	$this.copy_files

endfunc

#cs :: get project files
 Method: 		Private
 @return: 		void
────────────────────────────────────────────────────────────────────────────────────────────── #ce
func _meth_get_project_files($this)
	
	local aFileList = _FileListToArrayRec('.', '*|' & $this.s_exclude_files &' |' & $this.s_exclude_folder, 1, 1)
	local $project_files[UBound($this.a_project_files)][3]

	; create array with path and modified date
	; ───────────────────────────────────────────────────────────────────────────────────────────────
	for $i = 1 to UBound($this.a_project_files) -1
		$project_files[$i][0] = $this.a_project_files[$i]
		$project_files[$i][1] = FileGetTime($this.a_project_files[$i], 0, 1)
	next

	$this.a_project_files = $project_files
endfunc

#cs :: create json with file path & timestamp
 Method:       PRIVATE
 @return:      void
────────────────────────────────────────────────────────────────────────────────────────────── #ce
func _meth_create_compiler_json($this)

   ; create json string from array
   ; ───────────────────────────────────────────────────────────────────────────────────────────────
   _ArrayColDelete($this.a_project_files, 2)
   $json_string = _JSON_Generate($this.a_project_files)

   ; create json file
   ; ───────────────────────────────────────────────────────────────────────────────────────────────
	local $fopen = FileOpen($this.compiler_path & 'compiler.json', 2 + 8)
	FileWrite($fopen, $json_string)
	FileClose($fopen)

endfunc

#cs :: get compiler json
 Method:       PRIVATE
 @return:      return value
────────────────────────────────────────────────────────────────────────────────────────────── #ce
func _meth_get_compiler_json($this)

	; read json file
	; ───────────────────────────────────────────────────────────────────────────────────────────────
	local $fOpen = FileOpen($this.compiler_path & 'compiler.json')

	; if compiler json not exsists return
	; ───────────────────────────────────────────────────────────────────────────────────────────────
	if $fOPen = -1 then return

	; create array from json string
	; ───────────────────────────────────────────────────────────────────────────────────────────────
	local $sJson = FileRead($fOpen)
	$this.a_compiler_json = __ArrayAinATo2d(_JSON_Parse($sJson))
	
endfunc

#cs :: compare timestamps & delete 
 Method:       PRIVATE
 @return:      void
────────────────────────────────────────────────────────────────────────────────────────────── #ce
func _meth_compare_file_timestamps($this)

	; check if compiler json exist
	; ───────────────────────────────────────────────────────────────────────────────────────────────
	if IsArray($this.a_compiler_json) = 0 then return

	; compare timestamps - set null if equal
	; ───────────────────────────────────────────────────────────────────────────────────────────────
   for $i = 0 to UBound($this.a_project_files) -1
		if ( int($this.a_project_files[$i][1]) == int($this.a_compiler_json[$i][1]) ) then
			this.a_project_files[$i][2] = false
		endif
   next

endfunc

#cs :: copy files to dist
 Method:       PRIVATE
 @return:      void
────────────────────────────────────────────────────────────────────────────────────────────── #ce
func _meth_copy_files($this)
	
	; copy files if modified
	; ───────────────────────────────────────────────────────────────────────────────────────────────
	for $i = 0 to  UBound($this.a_project_files) -1
		if $this.a_project_files[$i][1] <> false then
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
────────────────────────────────────────────────────────────────────────────────────────────── #ce
func _meth_set_namespace($this)

   local aFileList = _FileListToArrayRec('.',  '*.class.au3', 1, 1)

endfunc