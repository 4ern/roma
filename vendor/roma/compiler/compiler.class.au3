;----------------------------------------------------------------------------------------------/
; includes
;----------------------------------------------------------------------------------------------/
#include-once
#include "../../Autoit/File.au3"

global $roma_compiler = obj_compiler()

#cs
|-----------------------------------------------------------------------------------------------/
| obj_compiler
|-----------------------------------------------------------------------------------------------/
|
| Author = 4ern
|
#ce
func obj_compiler()

    local $this = _AutoItObject_Class()

    ;----------------------------------------------------------------------------------------------/
    ; Properties & Methods
    ;----------------------------------------------------------------------------------------------/
	with $this

		.AddProperty('project_files', $ELSCOPE_PRIVATE)
		.AddProperty('sFile', $ELSCOPE_PRIVATE)
		
		.AddMethod('__default__', '__constructor')
		.AddMethod('get_namespace', '_meth_get_namespace')
		.AddMethod('copy_files', '_meth_copy_files' , true)
		
	endwith

    return $this.object
endfunc

func __constructor($this)

	;----------------------------------------------------------------------------------------------/
	; get all project files
	;----------------------------------------------------------------------------------------------/
	$this.project_files = _FileListToArrayRec('.', '*|[none]|.git', 1, 1)

	;----------------------------------------------------------------------------------------------/
	; copy files
	;----------------------------------------------------------------------------------------------/
	$this.copy_files()

endfunc


;----------------------------------------------------------------------------------------------/
; copy files
;----------------------------------------------------------------------------------------------/
func _meth_copy_files($this)
    for $i = 1 to  UBound($this.project_files) -1
		;~ ConsoleWrite($this.project_files[$i] & @CRLF)
		$ret = FileCopy($this.project_files[$i], 'dist\' & $this.project_files[$i], 8 + 1)
		if ($ret = 0) then
			ConsoleWrite('dist\' & $this.project_files[$i] & @CRLF)
		endif
	next
endfunc

;----------------------------------------------------------------------------------------------/
; get namespace of file
;----------------------------------------------------------------------------------------------/
func _meth_get_namespace($this)
    
endfunc