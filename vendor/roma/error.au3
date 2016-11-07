#cs
|-----------------------------------------------------------------------------------------------
|  Error to HTML
|-----------------------------------------------------------------------------------------------
|  Create a internal roma HTML-page with the error and sends it to the browser.
|  Erstellt eine interne roma HTML-Seite mit dem Fehler und sendet diese an den Browser.
|
#ce
func _vendor_roma__error($err)

	;----------------------------------------------------------------------------------------------/
	; String
	;----------------------------------------------------------------------------------------------/
	if $APP('DEBUG') = 'False' then 
		$err = "<pre><h1>"&$LANG('title.error.page')&"</h1></pre>"
	else
		$err = '<pre><h1>roma-error</h1><code>'&$err&'</code></pre>'
	endif



	$strg = '<!DOCTYPE html>'
	$strg &= '<html lang="en">'
	$strg &= '<head>'
	$strg &= '<roma charset="utf-8">'
	$strg &= '<title>roma - error</title>'
	$strg &= '<roma name="author" content="Eduard Tschernjaew">'
	$strg &= '<roma name="viewport" content="width=device-width, initial-scale=1">'
	$strg &= '<link rel="stylesheet" href="css/skeleton.css">'
	$strg &= '<link rel="icon" type="image/png" href="images/favicon.png">'
	$strg &= '<style>'
	$strg &= 'html {font-size: 62.5%; }'
	$strg &= 'body {font-size: 1.5em;line-height: 1.6;font-weight: 400;font-family: "HelveticaNeue", "Helvetica Neue", Helvetica, Arial, sans-serif;color: #222; }'
	$strg &= 'h1 {margin-top: 0;margin-bottom: 2rem;font-weight: 300; }'
	$strg &= 'h1 { font-size: 3.0rem; line-height: 1.3;  letter-spacing: -.1rem; }'
	$strg &= '#wrp { margin: 0 10% 0 10%;}'
	$strg &= 'code {padding: .2rem .5rem;margin: 0 .2rem;font-size: 90%;white-space: nowrap;background: #F1F1F1;border: 1px solid #E1E1E1;border-radius: 4px; }'
	$strg &= 'pre > code {display: block;padding: 1rem 1.5rem;white-space: pre;}'
	$strg &= '</style>'
	$strg &= '</head>'
	$strg &= '<body>'
	$strg &= '<div id="wrp">'
	$strg &= $err
	$strg &= '</body></div>'
	$strg &= '</html>'

	;----------------------------------------------------------------------------------------------/	
	; - Determine Socket
	; - Convert text as binary
	; - Send result to browsers
	;
	; - Ermittle Socket
	; - Konvertiere Text als binary
	; - Sende Ergebnis an Browser
	;----------------------------------------------------------------------------------------------/
	$socket = _vendor_roma_core_http__request('get')
	_vendor_roma_core_http_response_data('text/html', Binary($strg))
endfunc
