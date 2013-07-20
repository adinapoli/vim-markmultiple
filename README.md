vim-markmultiple
================

An emacs-like mark multiple plugin, inspired from this plugin:

[mark-multiple.el](https://github.com/magnars/mark-multiple.el)

## Usage
**Ctrl-n** to activate and to go to the next match.
When you are tired, simply change the word under the cursor the usual way.

## Customisation
You can put this inside your .vimrc to customize which keybinding you want associate to
vim-markmultiple. In the example, we are using Control + m:

```
let g:mark_multiple_trigger = "<C-n>"
```

[Watch the screencast!](http://www.youtube.com/watch?v=deGhhILp2PY&feature=youtu.be)

## Why highlighted words remain on screen?
Because you "Interrupted" the marking process without actually substituting
nothing. If this happens, simply call ```MarkMultipleClean()```


## Installation
Like any Pathogen bundle.

## Contributes
Yes, please. Pull requests welcome.
