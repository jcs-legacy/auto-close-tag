# auto-close-tag #

[![Build Status](https://travis-ci.com/jcs090218/auto-close-tag.svg?branch=master)](https://travis-ci.com/jcs090218/auto-close-tag)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

Automatically add HTML/XML close tag.<br/><br/>


## Configuration ##
Set the tag list that would not be auto closed.
```
(setq auto-close-tag-excluded-tags '("area"
                                     "base"
                                     "br"
                                     "col"
                                     "command"
                                     "embed"
                                     "hr"
                                     "img"
                                     "input"
                                     "keygen"
                                     "link"
                                     "meta"
                                     "param"
                                     "source"
                                     "track"
                                     "wbr")
```


## Usage ##
Enable for all buffers.
```
(global-auto-close-tag-mode t)
```
Or you can just enable in specific buffer you want.
```
(auto-close-tag-mode t)
```


## Screenshot ##
After typing in the closing bracket of the opening tag, the closing tag
will be inserted automatically.
<img src="./screenshot/auto-close-tag-demo-1.gif" width="600" height="241"/>

To automatically add close tag
<img src="./screenshot/auto-close-tag-demo-2.gif" width="600" height="241"/>


## Contribution ##
If you would like to contribute to this project. You may either
clone and make pull request to this repository. Or you can
clone the project and make your own branch of this tool. Any
methods are welcome!
