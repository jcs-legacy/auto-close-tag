[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

# auto-close-tag
> Automatically add HTML/XML close tag.

[![Build Status](https://travis-ci.com/jcs090218/auto-close-tag.svg?branch=master)](https://travis-ci.com/jcs090218/auto-close-tag)

## Configuration

Set the tag list that would not be auto closed.

```el
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

## Usage

Enable for all buffers.

```el
(global-auto-close-tag-mode t)
```

Or you can just enable in specific buffer you want.

```el
(auto-close-tag-mode t)
```

## Screenshot

After typing in the closing bracket of the opening tag, the closing tag
will be inserted automatically. <br/><br/>
<img src="./etc/auto-close-tag-demo-1.gif" width="600" height="241"/>

To automatically add close tag. <br/><br/>
<img src="./etc/auto-close-tag-demo-2.gif" width="600" height="241"/>

## Contribution

If you would like to contribute to this project, you may either 
clone and make pull requests to this repository. Or you can 
clone the project and establish your own branch of this tool. 
Any methods are welcome!
