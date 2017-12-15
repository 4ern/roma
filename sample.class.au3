; sample.class.au3
;use vendor_roma_core
#Pragma Class(Compile, True)
#Pragma Class(Namespace, roma_core)

Func new($sPath = Default, $sLogLevel = 'debug')
	_AutoItObject_StartUp()
	local $class = _AutoItObject_Class()
	With $class
		.AddProperty('logLevel', $ELSCOPE_READONLY, $sLogLevel)
		.AddProperty('filePath', $ELSCOPE_READONLY, ($sPath = Default) ? @ScriptDir & '\storage\logs' : $sPath)
		.AddMethod('trace', 'trace')
		.AddMethod('debug', 'debug')
		.AddMethod('warning', 'warning')
		.AddMethod('error', 'error')
		.AddMethod('log', 'log', True)
		.AddDestructor('Destructor')
	EndWith
	Return $class.Object
EndFunc

Func log($oSelf, $sMessage, $sLevel)
	local $filehandle = FileOpen(StringFormat('%s\logfile.log', $oSelf.filePath), 1)
	local $timestamp = StringFormat('%s.%s.%s - %s:%s:%s.%s', @MDAY, @MON, @YEAR, @HOUR, @MIN, @SEC, @MSEC)
	FileWriteLine($filehandle, StringFormat('[%s] :: %s :: %s', $timestamp, StringUpper($sLevel), $sMessage))
	FileClose($filehandle)
EndFunc

Func trace($oSelf, $sMessage)
	If $oSelf.logLevel = 'trace' Then $oSelf.log($sMessage, 'trace')
	Return $oSelf
EndFunc

Func debug($oSelf, $sMessage)
	If $oSelf.logLevel = 'debug' Then $oSelf.log($sMessage, 'debug')
	Return $oSelf
EndFunc

Func warning($oSelf, $sMessage)
	If $oSelf.logLevel = 'warning' Then $oSelf.log($sMessage, 'warning')
	Return $oSelf
EndFunc

Func error($oSelf, $sMessage)
	If $oSelf.logLevel = 'error' Then $oSelf.log($sMessage, 'error')
	Return $oSelf
EndFunc

Func Destructor($oSelf)
	$oSelf = 0
EndFunc