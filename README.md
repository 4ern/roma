![roma() AutoIt Framework](http://4ern.de/4ern/wp-content/uploads/2016/11/roma_logo.png)

**[by 4ern.de](http://www.4ern.de)**

---

#Ziel des Frameworks

AutoIt Anwendungen erstellen, die über eine GUI verfügen, die mit Hilfe von HTML, CSS & Javascript gebaut und in Real-Time bearbeitet werden können. 

Dabei wird das AutoIt-Script in zwei Ebenen aufgeteilt, so dass eine MVC-Struktur möglich ist und die GUI von der Logik trennt.

> **Fontend:**  HTML,CSS & Javascript
>**Backend:** AutoIt

- MVC Entwicklung mit AutoIt
- Bessere und modernere UDF Verwaltung
- CLI-Unterstützung
- etc.

>_Bei diesem Framework habe ich mich stark von [**Laravel _PHP_ Framework** ](https://laravel.com/) inspirieren lassen, daher werden Laravel-Kenner viele Ähnlichkeiten bemerken._

#Wie funktioniert das Framework
In der Route-Funktion(application.au3) werden die URI(Links) definiert und die jeweiligen Controller(Steuerung) angesteuert. Diese verarbeiten die Daten aus dem Model(Daten) und übergeben diese wiederum an die View(Präsentation).


----------


#Baumstruktur

> **config**
Hier befinden sich (wie der Name schon sagt) die Dateien zur Anwendungs- konfiguration.

>> **aliases.au3** 
>Hier werden (z.B wichtige) Funktionen in Funktionsvariablen deklariert.
**app.ini** 
Allgemeine Applikationseinstellungen und Opt-Settings
**gui.ini** 
GUI-Einstellungen
**onStart.au3**
Funktionen, die vor dem eigentlichen Anwendungsstart ausgeführt werden sollen
**packages.au3**
Include der Packages, die sich im Vendore-Ordner befinden

>**controller**
Hier befinden sich die User-Controller. __Es können auch Sub-Ordner erstellt werden.__
**Achtung** Noch müssen die Controller Dateien in *roma\vendore\roma\mvc_inc.au3* inkludiert werden.

>**model**
Hier befinden sich die User Models. __Es können auch Sub-Ordner erstellt werden.__
**Achtung** Noch müssen die Models-Dateien in *roma\vendore\roma\mvc_inc.au3* inkludiert werden.

>**storage**
Im Urzustand des Frameworks, werden hier die Applikation-Logs abgelegt.
Dient auch zur Ablage von SQLite, JSON, XML Dateien etc. 

>**vendore**
In diesem Ordner befindet sich die gesamte Framework Logik und die Packages(udf).
*In diesem Order musst du nichts machen, es sei denn du möchtest das Framework modifizieren.*

>**views**
Hier befindet sich deine komplette View(Präsentation) (html, css, js usw.).

>application.au3
Das Navigationssystem und zugleich das Kernstück der gesamten Applikation.
Hier kannst du die Wrapper Direktiven festlegen und die Root Logik anlegen.

>**Alle Dateien sind so gut wie möglich dokumentiert, so dass ich mir sicher bin, das du dich gut zurecht findest.**


----------


#Routing

####**GET Request**
```autoit
$root_get('uri', 'function')
```

- **uri** *string* -  Url die über ein Link aufgerufen wurde.
- **function** *string* - Funktion die aufgerufen werden soll.

**Beispiel:** 

 >**URL:** `http://localhost:8080/tabelle`
>```autoit
>$root_get('tabelle', 'controller_tabelle')
>```

####**POST Request**
```autoit
$root_post('uri', 'function')
```
- **uri** *string* -  Url die über ein Formular aufgerufen wurde.
- **function** *string* - Funktion die aufgerufen werden soll.

**Beispiel:** 

> **HTML Form**
> ```html
><form action="welcome" method="post">
>```
> **autoIt roma**
> ```autoit
$root_post('welcome', 'welcome_controller')
```

---
_roma() befindet sich noch in Entwicklung, weitere Dokumentationen oder Anwendungsbeispiele werden schon bald zur Verfügung stehen._

_Ich freue mich über jede Unterstützung._


----------


###Lizenz:
Das Framework steht unter der Open-Source Lizenz.
MIT-Lizenz.

###Packages(UDF) von:
- (*__WinHttpTimeFromSystemTime*) von trancexx
-  (*Parser UDF*) von zserge


###Ersteller:
Eduard Tschernjaew

