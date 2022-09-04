[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

# auto-close-tag
> Automatically add HTML/XML close tag.

[![CI](https://github.com/jcs-elpa/auto-close-tag/actions/workflows/test.yml/badge.svg)](https://github.com/jcs-elpa/auto-close-tag/actions/workflows/test.yml)

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

## Contribute

[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)
[![Elisp styleguide](https://img.shields.io/badge/elisp-style%20guide-purple)](https://github.com/bbatsov/emacs-lisp-style-guide)
[![Donate on paypal](https://img.shields.io/badge/paypal-donate-1?logo=paypal&color=blue)](https://www.paypal.me/jcs090218)
[![Become a patron](https://img.shields.io/badge/patreon-become%20a%20patron-orange.svg?logo=patreon)](https://www.patreon.com/jcs090218)

If you would like to contribute to this project, you may either 
clone and make pull requests to this repository. Or you can 
clone the project and establish your own branch of this tool. 
Any methods are welcome!
