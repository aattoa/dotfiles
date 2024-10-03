# Configuration instructions

## bash

- Symlink `~/.bashrc` → `configs/bash/bashrc`.

## editline

- `$EDITRC` should expand to `configs/editline/editrc`

## feh

- Symlink `$XDG_CONFIG_HOME/feh` → `configs/feh`.

## fzf

- `$FZF_DEFAULT_OPTS_FILE` should expand to `configs/fzf/fzfrc`.

## ghci

- Symlink `$XDG_CONFIG_HOME/ghc/ghci.conf` → `configs/ghci/ghci`
- Symlink `~/.haskeline` → `configs/ghci/haskeline`

## git

- Execute `configs/git/configure`

## less

- Symlink `$XDG_CONFIG_HOME/lesskey` → `configs/less/lesskey`

## mpv

- Symlink `$XDG_CONFIG_HOME/mpv` → `configs/mpv`

## neovim

- Symlink `$XDG_CONFIG_HOME/nvim` → `configs/neovim`

## newsboat

- Symlink `$XDG_CONFIG_HOME/newsboat/config` → `configs/newsboat/config`
- Store the url file at `$XDG_CONFIG_HOME/newsboat/urls`

## ocaml

- Symlink `$XDG_CONFIG_HOME/utop` → `configs/ocaml/utop`
- Symlink `$XDG_CONFIG_HOME/lambda-term-inputrc` → `configs/ocaml/lambda-term-inputrc`

## python

- Invoke the repl with `-i configs/python/startup.py`

## readline

- `$INPUTRC` should expand to `configs/readline/inputrc`

## rust

- Symlink `$XDG_CONFIG_HOME/rustfmt` → `configs/rust`

## shellcheck

- Symlink `$XDG_CONFIG_HOME/shellcheckrc` → `configs/shellcheck/shellcheckrc`

## vim

- If recent enough version, symlink `$XDG_CONFIG_HOME/vim` → `configs/vim`. Otherwise symlink `~/.vim/vimrc` → `configs/vim/vimrc`

## x11

- `$XINITRC` should expand to `configs/x/xinitrc`

## zathura

- Symlink `$XDG_CONFIG_HOME/zathura` → `configs/zathura`
