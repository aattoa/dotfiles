CFLAGS = -std=c99 -Wall -Wextra -Wpedantic -Werror -s -O3

DOTFILES        ?= $(error DOTFILES is undefined)
XDG_CONFIG_HOME ?= $(error XDG_CONFIG_HOME is undefined)
XDG_CACHE_HOME  ?= $(error XDG_CACHE_HOME is undefined)
XDG_DATA_HOME   ?= $(error XDG_DATA_HOME is undefined)
XDG_STATE_HOME  ?= $(error XDG_STATE_HOME is undefined)
CARGO_HOME      ?= $(error CARGO_HOME is undefined)
HOME            ?= $(error HOME is undefined)

all: dirs base dev newsboat feh mpv zathura status-bar

base: bash git less vim

lang: haskell ocaml rust python

dev: base neovim shellcheck lang

haskell: ghci haskeline

ocaml: utop lambda-term

rust: rustfmt cargo

python: pylint pycodestyle

dirs:
	@mkdir -pv ${XDG_CONFIG_HOME} ${XDG_CACHE_HOME} ${XDG_DATA_HOME} ${XDG_STATE_HOME} || true

status-bar: configs/x/status-bar.c
	mkdir -pv ${HOME}/.local/bin
	@cc ${CFLAGS} -lX11 -D_DEFAULT_SOURCE -o ${HOME}/.local/bin/$@ $^ || true

bash:
	@ln -sviT ${DOTFILES}/configs/bash/bashrc ${HOME}/.bashrc || true

git:
	@${DOTFILES}/configs/git/configure

less: dirs
	@ln -sviT ${DOTFILES}/configs/less/lesskey ${XDG_CONFIG_HOME}/lesskey || true

vim: dirs
	@# With an older vim might have to symlink ~/.vim/vimrc to configs/vim/vimrc
	@ln -sviT ${DOTFILES}/configs/vim ${XDG_CONFIG_HOME}/vim || true

neovim: dirs
	@ln -sviT ${DOTFILES}/configs/neovim ${XDG_CONFIG_HOME}/nvim || true

newsboat: dirs
	@# Store the url file at $XDG_CONFIG_HOME/newsboat/urls
	@mkdir -pv ${XDG_CONFIG_HOME}/newsboat
	@ln -sviT ${DOTFILES}/configs/newsboat/config ${XDG_CONFIG_HOME}/newsboat/config || true

shellcheck: dirs
	@ln -sviT ${DOTFILES}/configs/shellcheck/shellcheckrc ${XDG_CONFIG_HOME}/shellcheckrc || true

feh: dirs
	@ln -sviT ${DOTFILES}/configs/feh ${XDG_CONFIG_HOME}/feh || true

mpv: dirs
	@ln -sviT ${DOTFILES}/configs/mpv ${XDG_CONFIG_HOME}/mpv || true

zathura: dirs
	@ln -sviT ${DOTFILES}/configs/zathura ${XDG_CONFIG_HOME}/zathura || true

ghci: dirs
	@mkdir -pv ${XDG_CONFIG_HOME}/ghc
	@ln -sviT ${DOTFILES}/configs/haskell/ghci ${XDG_CONFIG_HOME}/ghc/ghci.conf || true

haskeline:
	@ln -sviT ${DOTFILES}/configs/haskell/haskeline ${HOME}/.haskeline || true

utop: dirs
	@ln -sviT ${DOTFILES}/configs/ocaml/utop ${XDG_CONFIG_HOME}/utop || true

lambda-term: dirs
	@ln -sviT ${DOTFILES}/configs/ocaml/lambda-term-inputrc ${XDG_CONFIG_HOME}/lambda-term-inputrc || true

rustfmt: dirs
	@ln -sviT ${DOTFILES}/configs/rust/fmt ${XDG_CONFIG_HOME}/rustfmt || true

cargo:
	@mkdir -pv ${CARGO_HOME}
	@ln -sviT ${DOTFILES}/configs/rust/cargo/config.toml ${CARGO_HOME}/config.toml || true

pylint:
	@ln -sviT ${DOTFILES}/configs/python/pylintrc ${HOME}/.config/pylintrc || true

pycodestyle: dirs
	@ln -sviT ${DOTFILES}/configs/python/pycodestyle ${XDG_CONFIG_HOME}/pycodestyle || true
