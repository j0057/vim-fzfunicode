# vim-fzfunicode

Plugin to use [fzf] to fuzzy-find Unicode codepoints based on their descriptions
in the [Unicode Character Database][ucd], specifically the `NamesList.txt`.

[fzf]: https://github.com/junegunn/fzf
[ucd]: https://www.unicode.org/Public/14.0.0/

## How to use

Install the plugin however you do it — I like to get crazy and use git
submodules to manage my vim plugins. Then add an insert-mode mapping:

    imap <F12> <Plug>fzfu#FzfUnicode

Now when you press F12 in insert mode, the `NamesList.txt` gets downloaded and cached,
Fzf is fired up and you can fuzzily search for the thing you need. Multiple select is
supported with Tab.
