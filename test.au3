#include 'vendor\roma\compiler\compiler.class.au3'
#include 'vendor\roma\helper.class.au3'

;~ $roma_compiler()
;~ $roma_compiler.get_project_files()
;~ $roma_compiler.copy_files()
;~ $roma_compiler.set_namespace()
;~ $roma_helper.ArrayInfo( ($roma_compiler.a_project_files) )

;~ $roma_compiler.get_project_files()
;~ ConsoleWrite('Typeof $roma_compiler.a_project_files: ' & $roma_helper.TypeOf($roma_compiler.a_project_files) & @CRLF)


;~ $aTest = $roma_helper.Array()
;~ ConsoleWrite('Type of $aTest: ' & VarGetType($aTest) & @CRLF)
;~ ConsoleWrite('UBound() of $aTest: ' & UBound($aTest) & @CRLF)


;~ $dTest = $roma_helper.Dict()
;~ ConsoleWrite('Type of $dTest: ' & VarGetType($dTest) & @CRLF)


;~ $fTest = $roma_helper.File(@ScriptDir & '\sample.class.au3')
;~ ConsoleWrite('Type of $fTest: ' & VarGetType($fTest) & @CRLF)
;~ ConsoleWrite('Filename: ' & $fTest.name & @CRLF)
;~ ConsoleWrite('Datetime: ' & $fTest.datetime & @CRLF)



$TestClass = $roma_helper.ClassObject('.\sample.class.au3')
$sPrint = ''
$sPrint &= 'Found ClassObject at ' & $TestClass.FileFullPath & @CRLF
$sPrint &= '  Containing class ' & $TestClass.ClassName & @CRLF
$sPrint &= '  With Namespace of "' & $TestClass.Namespace & '"' & @CRLF
$sPrint &= '  Should it compiled? ' & String($TestClass.Compile) & @CRLF
$sPrint &= "  Content Length is " & StringLen($TestClass.ContentRaw) & @CRLF
ConsoleWrite($sPrint)

;~ _ArrayDisplay( ($TestClass.Pragma) )
;~ ConsoleWrite("Pragmas found: " & UBound($TestClass.Pragma) & @CRLF)
;~ For $i = 0 to ($TestClass.Pragma)
;~     _ArrayDisplay( ($TestClass.Pragma)[$i] )
;~ Next

;~ _ArrayDisplay( ($TestClass.ClassName) )
;~ _ArrayDisplay( ($TestClass.ClassName)[0] )
;~ _ArrayDisplay( ($TestClass.ClassName)[1] )