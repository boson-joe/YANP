YANP
====

Notetaking plugin that supports recurring topics structure and customisable syntax.<br>

YANP - Yes, Another Notetaking Plugin.

-----

Table of contents
-----------------

+ [Description](https://github.com/boson-joe/YANP#description)
+ [Navigation Bar](https://github.com/boson-joe/YANP#navigation-bar)

-----

Description
-----------

Long story short, here are the main features of this plugin that may distinguish it from the others:

+ Recursive structure. Every topic is represented with its own directory within recursive structure of subdirectories. YANP handles creation of files and directories, maintains this structure as well as provides simple user interface for defining links to different files.

![yanp_structure](https://user-images.githubusercontent.com/85287376/134817650-0c85ec16-f513-4714-b312-7906abf0494a.png "graph of YANP structure")

+ Customizable syntax plugin. YANP doesn't handle syntax by itself - thus you can choose any markup syntax (like Markdown, HTML, etc) you want to define links between files, provided you have a plugin that utilizes YANP API. By default, YANP works with [MarkdowneyJr](https://github.com/boson-joe/markdowneyJR) Markdown formatting plugin. The list plugins know to integrate YANP can be found [here](https://github.com/boson-joe/YANP/wiki/YANP-List-of-known-syntax-formatting-plugins).

+ API for syntax formatting plugins. YANP delegates syntax formatting (like replacing selected text with a link to a desired file) to other plugins while providing a clear API that allows maintaining a unified structure of notes. Definition of exact paths to files and its creation is done by YANP, syntax plugin is only responsible for replacing a text with a link. [Documentation for the API](https://github.com/boson-joe/YANP/wiki/YANP-Integration-Guide) is provided to make syntax plugin integration easier.

+ Links. Links are everywhere. Defined with a single keystroke.

+ Customization. You can [change quite a lot of stuff](https://github.com/boson-joe/YANP/wiki/YANP-Customization-Guide), starting from names of index files and default contents of created files, till how the path for different types of files will look like.

+ Fast access to last created files, last visited index files, today's fast notes, and other supplementary, but useful features. 

Please refer to the [User Guide](https://github.com/boson-joe/YANP/wiki/YANP-User-Guide), [Customization Guide](https://github.com/boson-joe/YANP/wiki/YANP-Customization-Guide), [Installation Guide](https://github.com/boson-joe/YANP/wiki/YANP-Installation-Guide) or [YANP Integration Guide](https://github.com/boson-joe/YANP/wiki/YANP-Integration-Guide) to see how to use different features of the plugin, install it or integrate your syntax plugin, respectively.

Please refer to the [Contacts](https://github.com/boson-joe/YANP/wiki/YANP-Contacts) page if you would like to contact the devs.


Navigation Bar
--------------

[[User Guide]](https://github.com/boson-joe/YANP/wiki/YANP-User-Guide)
[[Customization Guide]](https://github.com/boson-joe/YANP/wiki/YANP-Customization-Guide)
[[Installation Guide]](https://github.com/boson-joe/YANP/wiki/YANP-Installation-Guide)
[[Integration Guide]](https://github.com/boson-joe/YANP/wiki/YANP-Integration-Guide)
[[License]](https://github.com/boson-joe/YANP/blob/master/license.txt)
[[Development]](https://github.com/boson-joe/YANP/wiki/YANP-Development)
[[Contacts]](https://github.com/boson-joe/YANP/wiki/YANP-Contacts) 

-----

[Go up](https://github.com/boson-joe/YANP#yanp)
