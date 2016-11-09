![roma() AutoIt Framework](http://4ern.de/4ern/wp-content/uploads/2016/11/roma_logo.png)
**[by 4ern.de](http://www.4ern.de)**

---

#Ziel des Frameworks
- Hauptziel dieses Frameworks ist es GUI's mit HTML, CSS & Javascript erstellen zu können und am besten diese auch Live zu gestalten. Das ganze funktioniert mit 2 Schichten.
	-- Fontend = HTML,CSS & Javascript
	-- Backend = AutoIt
- MVC Entwicklung mit AutoIt
- Bessere und modernere UDF Verwaltung
- CGI unterstützung
- ect.

_Bei diesem Framework habe ich mich stark von [**Laravel _PHP_ Framework** ](https://laravel.com/) insperieren lassen, daher wird jedem wer mit Laravel gearbeitet hat sehr viele Ähnlichkeiten auffallen._

#Wie funktioniert das Framework
In der route Funktion(application.au3) werden die uris(links) deffiniert und die jeweiligen Controller angesteuert.
Die Contoller verarbeiten die Daten aus dem Model und übergeben diese wiederum an View(GUI).

#Baumstruktur
###config
hier befinden sich (wie der Name schon sagt) die Anwendungs konfigurationen Dateien.

- aliases.au3 	// Hier werden (z.B wichtige) Funktionen in Funktionsvariablen deklariert.
- app.ini 		// Allgemeine Applikations Einstellungen und Opt-Settings
- gui.ini 		// GUI Einstellungen
- onStart.au3	// Funktionen, die vor dem eigentlichen Anwendungsstart ausgeführt werden sollen.
- packages.au3 	// Include der Packages die sich im Vendore Ordner befinden

###controller
hier befinden sich die User Controller. __Es können auch Sub-Ordner erstellt werden.__
**Achtung** noch müssen die Controller Dateien in *roma\vendore\roma\mvc_inc.au3* includiert werden.

###model
hier befinden sich die User Models. __Es können auch Sub-Ordner erstellt werden.__
**Achtung** noch müssen die Models Dateien in *roma\vendore\roma\mvc_inc.au3* includiert werden.

###storage
Im Uhrzustand des Frameworks, werden hier die Applikation Logs abgelegt.
Dient auch zur Ablage von SQLite, JSON, XML Dateien etc. 

###vendore
In diesem Ordner befindet sich die gesamte Framework Logik und die Packages(udf).
**In diesem Order musst du nichts machen, es sei denn du möchtest das Framework modifizieren.

###views
Hier befindet sich deine komplette View(GUI) (html, css, js usw.).

###application.au3
Das Navigationssystem eurer Applikation und zugleich das Kernstück der gesamten Applikation.
Hier kannst du die Wrapper Direktiven festlegen und die Root Logik anlegen.

**Alle Dateien sind so gut wie möglich Dokumentiert, sodass ich mir sicher bin das du dich gut zurechtfindest.**

#Routing
### **$root_get(string 'uri', string 'controller function')**
**GET Request**
uri = url die über ein Link aufgerufen wurde.
controller Funktion = Funktion die aufgerufen werden soll.
> **Beispiel:** 
	> URL: `http://localhost:8080/tabelle`
	> `$root_get('tabelle', 'controller_tabelle')`

### **$root_post(string 'uri', string 'controller function')**
**POST Request**
uri = url die über ein Formular aufgerufen wurde.
controller Funktion = Funktion die aufgerufen werden soll.
> **Beispiel:** 
	> URL: `http://localhost:8080/eintrag`
	> `$root_get('eintrag', 'controller_eintrag')`
	
---
_roma() befindet sich noch in Entwicklung, Dokumentation oder Anwendungsbeispiele werden schon bald Zurverfügung stehen._
_Ich bin über jede Unterstützung sehr Dankbar._

###Lizenz:
Das Framework steht unter der open-sourced Lizenz.
MIT-Lizenz.

###Ersteller:
Eduard Tschernjaew
from Germany
