#[-> Goto english redme](https://github.com/4ern/roma/blob/master/README_EN.md)

![roma() AutoIt Framework](http://4ern.de/4ern/wp-content/uploads/2016/11/roma_logo.png)

**[by 4ern.de](http://www.4ern.de)**


#Index

- [Vorwort](#vorwort)
    - [Ziel des Frameworks](#ziel-des-frameworks)
    - [Unterstützung](#unterstützung)
    - [Was das Framework aktuell beherrscht](#inhalt-des-frameworks)
- [Funktionsweise](#funktionsweise)
- [Baumstruktur](#baumstruktur)
- [Rooting](#routing)
    - [GET ROUTE](#get-route)
    - [POST ROUTE](#post-route)
    - [ROUTE with Parameter](#route-with-parameter)
- [ToDo](#todo)
- [Lizenz](#lizenz)
- [Packages](#packages)
- [Übersetzung](#%C3%BCbersetzung)
- [Ersteller](#ersteller)

---

#Vorwort
Ich nutze AutoIt schon lange nicht mehr zum purem Automatisieren von Anwendungen, sodern um komplexe eigenständige Anwendungen zu entwickeln.  Besonders stört mich dabei, dass die Logik in AutoIt sehr schwer von der Präsentation zu trennen ist und die Standard GUI-Elememte sehr unflexibel sind. Will man etwas Anspruchvolleres erstellen, muss man sich mit GDI rumschlagen und zig Zeilen Code für simple Effekte oder Animationen schreiben.

Mit diesen Gedanken im Kopf habe ich mich nach Alternativen umgeschaut und leider nichts gefunden, was mich meinen Vorstellungen entsprach. Deshalb habe ich mir eine eigene Lösung überlegt, um die Logik von der Präsentation zu trennen und zudem HTML & CSS in meiner GUI in vollem Umfang nutzen zu können. Daraus entstand die Idee zu diesem Framework.

###Ziel des Frameworks

- MVC Entwicklung mit AutoIt
- HTML & CSS GUI in AutoIt
- Besseres und moderneres Packagesystem(UDF) like [npm](https://www.npmjs.com/)
- CLI-Unterstützung like [Laravel Artisan](https://laravel.com/docs/5.0/artisan)
- schnellere und struktuiertere Entwicklung von Anwendungen

###Unterstützung
Ich habe leider nicht mehr viel Zeit für das Projekt, da ich zum zweiten Mal Nachwuchs bekommen habe und nun ein Job Wechsel bevorsteht, bei dem ich mich intensiv mit AngularJs auseinander setzen muss. 
Daher dachte ich mir, bevor das Projekt verstaubt und irgendwo in meinem Computer untergeht, teile ich es und bitte euch um Unterstützung, dieses Projekt weiterzuentwickeln.

> Das Framework dient in erster Linie zur Entwicklung von eigenständigen Applikationen.

###Inhalt des Frameworks

- Alle notwendigen Settings sind vorkonfiguriert, man kann sofort mit der Logik oder der View beginnen.
- Alle Settings sind an einem Ort.
- Die Logik(Controller) und die Presentation(View) sind klar voneinander getrennt.
- Entwicklung mit MVC-Struktur
- Man kann die GUI in realTimer entwickeln, ohne AutoIt ständig neu zu starten.
- GUI können in HTML & CSS entwickelt werden.
- Jede mögliche Grafik & Video Einbindung ist möglich (.png, .gif usw.). Alles, was in HTML5 & CSS3 möglich ist.
- JavaScript & Frameworks werden unterstützt.
- Debug Logs werden erstellt inklusive Konsolen Ausgabe.
- Das Framework ist Multinational. (Die Anwendung kann in mehreren Sprachen ausgegeben werden)
- Alle UDFs sind im Framework enthalten, Nachladen ist nicht nötig. 
- Auch die AutoIt UDFs sind im Framework enthalten. Somit wird sicher gestellt, dass bei verschiedenen AutoIt Versionen das Framework korrekt funktioniert.
- Das Framework bietet auch Funktionen, die für die Kommunikation zwischen AutoIt und HTML notwendig sind. Z. B. Auswertung von Formulardaten (GET & POST)(Dokumentation hierfür und Beispiele folgen noch.)
- Ich habe zudem eine Template Engine entwickelt. (Ähnlich wie Laravel Blade)
- Die Template Engine unterstützt If-Statements (Hätte gerne Hilfe, um auch Schleifen zu ermöglichen). Eine komplette Dokumentation der Template Engine und Beispiele werde ich noch veröffentlichen.
- Fast fertig ist ein Datenbank Package. Damit wird die Kommunikation mit Datenbanken ein absolutes Kinderspiel.

> *Bei diesem Framework habe ich mich stark von [**Laravel _PHP_ Framework** ](https://laravel.com/) inspirieren lassen, daher werden Laravel-Kenner viele Ähnlichkeiten bemerken.*

#Funktionsweise

![enter image description here](http://4ern.de/4ern/wp-content/uploads/2016/11/Zeichnung1.jpg)


#Baumstruktur

```html
├── config
    ├── aliases.au3
    ├── app.ini
    ├── gui.ini
    ├── onStart.au3
    ├── packages.au3
├── controller
├── model
├── storage
    ├── logs
├── vendore
    ├── AutoIt
        ├── Array.au3
        ├── Date.au3
        ├── GUIConstantsEx.au3
        ├── IE.au3
        ├── WindowsConstants.au3
    ├── roma
        ├── core
            ├── app.au3
            ├── container.au3
            ├── gui.au3
            ├── http.au3
            ├── loop.au3
            ├── request.au3
            ├── route.au3
            ├── template.au3
            ├── view.au3
                ├── errors
                    ├── 404.html
                ├── lang
                    ├── de_DE.ini
        ├── lang
            ├── default.ini
            ├── language.au3
        ├── error.au3
        ├── log.au3
        ├── mvc_inc.au3
    ├── trancexx
        ├── winHttpTimeFromSystemTime.au3
    ├── Ward
        ├── BinaryCall.au3
        ├── Json.au3
    ├── initial.au3
├── view
├── application.au3
├── LICENSE.md
├── README.md
```

 **config**
Hier befinden sich (wie der Name schon sagt) die Dateien zur Anwendungs- konfiguration.

> **aliases.au3** 
Hier werden (z.B wichtige) Funktionen in Funktionsvariablen deklariert.
**app.ini** 
Allgemeine Applikationseinstellungen und Opt-Settings
**gui.ini** 
GUI-Einstellungen
**onStart.au3**
Funktionen, die vor dem eigentlichen Anwendungsstart ausgeführt werden sollen
**packages.au3**
Include der Packages, die sich im Vendore-Ordner befinden

**controller**
Hier befinden sich die User-Controller. *__Es können auch Sub-Ordner erstellt werden.__*
**Achtung** Noch müssen die Controller Dateien in (*roma\vendore\roma\mvc_inc.au3*) inkludiert werden.

**model**
Hier befinden sich die User Models. *__Es können auch Sub-Ordner erstellt werden.__*
**Achtung** Noch müssen die Models-Dateien in (*\vendore\roma\mvc_inc.au3*) inkludiert werden.

**storage**
Im Urzustand des Frameworks, werden hier die Applikation-Logs abgelegt.
Dient auch zur Ablage von SQLite, JSON, XML Dateien etc. 

**vendore**
In diesem Ordner befindet sich die gesamte Framework Logik und die Packages(udf).
*In diesem Order musst du nichts machen, es sei denn du möchtest das Framework modifizieren.*

**views**
Hier befindet sich deine komplette View(Präsentation) (html, css, js usw.).

**application.au3**
Das Navigationssystem und zugleich das Kernstück der gesamten Applikation.
Hier kannst du die Wrapper Direktiven festlegen und die Root Logik anlegen.

>**Alle Dateien sind so gut wie möglich dokumentiert, so dass ich mir sicher bin, das du dich gut zurecht findest.**


----------


#Routing
Das Roouting ist eine Art Navigationssystem deiner Applikation und befindet sich in der application.au3.  
Es ist ganz simpel. Weise einer URI einen Controller zu, damit alles sein Lauf nimmt.

###GET ROUTE
```autoit
$root_get('uri', 'function')
```

- **uri** *string* -  Url die über ein Link aufgerufen wurde.
- **function** *string* - Funktion die aufgerufen werden soll.

**Beispiel:** 

**URL:** `http://localhost:8080/tabelle`
```autoit
$root_get('tabelle', 'controller_tabelle')
```

###POST ROUTE
```autoit
$root_post('uri', 'function')
```
- **uri** *string* -  Url die über ein Formular aufgerufen wurde.
- **function** *string* - Funktion die aufgerufen werden soll.

**Beispiel:** 

 **HTML Form**
```html
<form action="welcome" method="post">
```

 **AutoIt roma**
```autoit
$root_post('welcome', 'welcome_controller')
```

###ROUTE with Parameter

```autoit
$root_get('uri{param}', 'function')
```
**Beispiel:** 

**URL:** `http://localhost:8080/page/5`

Basic Parameter
```autoit
$root_get('page{id}', 'controller_page')

func controller_page($id)
    ConsoleWrite('var: $id --> ' & $id)
endfunc
```

Optional Parameter
```autoit
$root_get('page{id?}', 'controller_page')

func controller_page($id = 1)
    ConsoleWrite('var: $id --> ' & $id)
endfunc
```


----------


#Views




----------
###ToDo
- [ ] Loop Funktion in Template.au3
- [ ] CLI-Modul like Laravel Artisan
- [ ] Lösungsansätze, wie das Framework optimal kompiliert werden kann, sodass im kompilierten Zustand alle Dateien zur Verfügung stehen.
- [ ] Framework Tests & Bugfixes

###Lizenz
Das Framework steht unter der Open-Source Lizenz.
[MIT-Lizenz](https://github.com/4ern/roma/blob/master/LICENSE.md).

###Packages
-  Systemtime to Http Tie by **trancexx**
-  JSON Package by **Ward**

###Übersetzung
- german to english by **Aladan**

###Ersteller
[4ern.de - Eduard Tschernjaew](http://4ern.de/)


> _roma() befindet sich noch in Entwicklung, weitere Dokumentationen oder Anwendungsbeispiele werden schon bald zur Verfügung stehen._
> 
> _Ich freue mich über jede Unterstützung._

