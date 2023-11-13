# Kickballs.nvim

This is a starting point for your own neovim configuration! You are encouraged to fork this
repository and make it your own. Read the comments, read the manual (`:help`) and most imporantly:
read the fucking manual

# Installation

To install kickballs you first need to figure out where your config directory is.

Open neovim and run `:echo stdpath('config')`. Then navigate to its parent directory in
a terminal. On Linux for example this directory is `~/.config/nvim` so we go into `~/.config`.

Then clone kickballs into a directory. This directory can either be `nvim` (your default neovim
configuration) or any other name. If you set the `NVIM_APPNAME` environment variable neovim will
use that location instead of the default one. If you already have a neovim configuration you can
clone kickballs into a `kickballs` directory and try it out without affecting your current config!

```sh
$ cd ~/.config
$ git clone "https://github.com/TheBallsUp/kickballs.nvim" kickballs
```

If you clone into the `nvim` directory you can simply run `nvim` and kickballs should open. If you
chose a different directory (like `kickballs`) you need to set `NVIM_APPNAME` before running
neovim.

```sh
# Linux
$ NVIM_APPNAME=kickballs nvim

# Windows (powershell)
$ $env:NVIM_APPNAME = 'kickballs'
```
