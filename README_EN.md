![roma() AutoIt Framework](http://4ern.de/4ern/wp-content/uploads/2016/11/roma_logo.png)

**[by 4ern.de](http://www.4ern.de)**

#Index

- [Introduction](#introduction)
    - [Goals of the Framework](#goals-of-the-framework)
    - [Support](#support)
    - [Content](#content)
- [How it works](#how-it-works)
- [Tree structure](#tree-structure)
- [Rooting](#routing)
    - [GET Request](#get-request)
    - [POST Request](#post-request)
- [ToDo](#todo)
- [License](#license)
- [Packages](#packages)
- [translation](#translation)
- [Creator](#creator)

---

#Introduction
I´m using AutoIt for a long time not only to automate applications but to develop complex stand-alone applications. I am particularly annoyed
by the fact that the logic in AutoIt is difficult to separate from the presentation and the standard GUI elements are very inflexible. If you 
want to create something more sophisticated, you have to use GDI and write many lines for simple effects or animations.

With these thoughts in mind, I looked around for alternatives and unfortunately found nothing that corresponded to my ideas. Therefore, I have thought of a
different solution. I have created this framework in order to separate the logic from the presentation and to use HTML & CSS in my GUI to the full extent.

###Goals of the Framework

- MVC development with AutoIt
- HTML & CSS GUI in AutoIt
- Better and more modern package system(UDF) like [npm](https://www.npmjs.com/)
- CLI support like [Laravel Artisan](https://laravel.com/docs/5.0/artisan)
- faster and more structured application development

###Support
Unfortunately, I do not have much time for the project at the moment. So I thought to myself, I share it and ask you for support.

> The framework primarily serves for the development of stand-alone applications.

###Content

- All necessary settings are preconfigured. You can start immediately with the logic or the view
- All settings are in one place
- The logic(controller) and the presentation are clearly separated from each other
- Development with MVC structure
- You can develop the GUI in realTimer without restarting AutoIt
- GUI can be developed in HTML & CSS
- Any graphic & video integration is possible (.png, .gif etc.). Also everything that is possible in HTML5 and CSS3
- JavaScript & Frameworks are supported
- Debug logs are created including console output
- It is possible to work with multiple languages
- All UDFs are contained in the framework. Reloading is not necessary
- The AutoIt UDFs are also included in the Framework. This ensures that it workds correctly for different Versions of AutoIt
- The framework also provides functions that are necessary for communication between AutoIt and HTML. For example, evaluation of form data (GET & POST) (documentation for this and examples follow.)
- I also developed a template engine. (Similar to Laravel Blade)
- The template engine supports if statements (would like to have help to make loops possible). In the Future I will publish a complete documentation of the template engine and examples.
- Almost finished is a database package. This makes communication with databases an absolute child's play.

*So that was it for once. If something else occurs to me, I will update the list.*

> *This Framework is strongly inspired by [**Laravel _PHP_ Framework** ](https://laravel.com/) so Laravel users will notice many similarities.*

#How it works

![enter image description here](http://4ern.de/4ern/wp-content/uploads/2016/11/Zeichnung1.jpg)


#Tree structure

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
The files for application configuration are located here (as the name implies)
> **aliases.au3** 
The functions are declared here within the function variables
**app.ini** 
General Application and Opt-Settings
**gui.ini** 
GUI-Settings
**onStart.au3**
Functions to be executed before the actual application start
**packages.au3**
Include of the packages that are located in the Vendore Folder

**controller**
The User-Controller are located here. __Subfolders can also be created.__
**Attention** The controller files must still be included in *roma\vendore\roma\mvc_inc.au3*

**model**
The User-Models are located here. __Subfolders can also be created.__
**Attention** The controller files must still be included in *roma\vendore\roma\mvc_inc.au3*

**storage**
In the original state of the framework the application logs are stored here. Also used to store SQLite, JSON, XML Files 

**vendore**
This folder contains the entire framework logic and the packages (udf).
**In this order you do not have to do anything, unless you want to modify the framework.

**views**
Here is your complete view(presentation) (html, css, js usw.).

**application.au3**
The navigation system and at the same time the core of the entire application.
Here you can define the wrapper directives and create the root logic.

>**All files are documented as well as possible, so I'm sure you'll get along well.**


----------


#Routing

###GET Request
```autoit
$root_get('uri', 'function')
```

- **uri** *string* -  Url which was accessed via a link.
- **function** *string* - Function to be called.

**example:** 

>**URL:** `http://localhost:8080/table`
>```autoit
>$root_get('table', 'controller_table')
>```

###POST Request
```autoit
$root_post('uri', 'function')
```
- **uri** *string* -  url which has been called from a form.
- **function** *string* - Function to be called.

**example:** 

> **HTML Form**
> ```html
><form action="welcome" method="post">
>```
> **autoIt roma**
> ```autoit
$root_post('welcome', 'welcome_controller')
```

----------
###ToDo
- [ ] Loop Funktion in Template.au3
- [ ] CLI module like Laravel Artisan
- [ ] Solution approaches, how the framework can be optimally compiled, so that in the compiled state all files are available.
- [ ] Framework Tests & Bugfixes

###License
The framework is under the Open-Source license.
[MIT-Lizenz](https://github.com/4ern/roma/blob/master/LICENSE.md).

###Packages
-  Systemtime to Http Tie by **trancexx**
-  JSON Package by **Ward**

###translation
- german to english by **Aladan**

###Creator
[4ern.de - Eduard Tschernjaew](http://4ern.de/)


> _roma() is still in development. Documentation and application examples will soon be available._
_I am looking forward to any support._
