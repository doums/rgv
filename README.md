## rgv

A [n](https://neovim.io/)/[vim](https://www.vim.org/) plugin that use [ripgrep](https://github.com/BurntSushi/ripgrep) to perform fast search

### prerequisites

[rg](https://github.com/BurntSushi/ripgrep)

### install

If you use a plugin manager, follow the traditional way eg.

```
Plug 'doums/rgv'
```

If you use vim package `:h packages`.

#### commands
```
:Rg arg(s)
```
runs `rg --vimgrep` followed by your `args`
```
:Rga arg(s)
```
runs `rg --vimgrep --hidden --no-ignore` followed by your `args`

If no `arg` is provided, default to the word under the cursor.

#### map
```
<Plug>RgToggle
```
Toggle the location list window.

### license
Mozilla Public License 2.0
