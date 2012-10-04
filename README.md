vim-markmultiple
================

An emacs-like mark multiple plugin, inspired from this plugin:

[mark-multiple.el](https://github.com/magnars/mark-multiple.el)

## Usage
**Ctrl-n** to activate and to go to the next match.
When you are tired, simply change the word under the cursor the usual way.

Screencast coming soon.

## Why matches are not highlighted?
The more I look at it, the more my suspect become true. As far as I have
understood, _:3match_ allows you to only have 3 match on the screen, which is no
good if you have multiple occurences. It also raises non trivial problems when
you want to clear the matches: if you are substituting word with mark-multiple
no-problem, because I can hook the clear inside _autocmd InsertLeave_, but what
happen if the user scans the first occurence using ctrl-n and then decide to
abort? In Vim there is no _VisualLeave autocmd_ to hook into, so you'll end up
with "stale" highlighting.

## Installation
Like any Pathogen bundle.

## Contributes
Yes, please. Pull requests welcome.
