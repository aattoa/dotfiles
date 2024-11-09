DOTFILES        ?= $(error DOTFILES is undefined)
XDG_CONFIG_HOME ?= $(error XDG_CONFIG_HOME is undefined)
CARGO_HOME      ?= $(error CARGO_HOME is undefined)
HOME            ?= $(error HOME is undefined)

all: bash feh git haskell less mpv neovim newsboat ocaml python rust shellcheck vim zathura

bash:
	@ln -sviT ${DOTFILES}/configs/bash/bashrc ${HOME}/.bashrc || true

feh:
	@ln -sviT ${DOTFILES}/configs/feh ${XDG_CONFIG_HOME}/feh || true

git:
	@${DOTFILES}/configs/git/configure

ghci:
	@mkdir -pv ${XDG_CONFIG_HOME}/ghc
	@ln -sviT ${DOTFILES}/configs/haskell/ghci ${XDG_CONFIG_HOME}/ghc/ghci.conf || true

haskeline:
	@ln -sviT ${DOTFILES}/configs/haskell/haskeline ${HOME}/.haskeline || true

haskell: ghci haskeline

less:
	@ln -sviT ${DOTFILES}/configs/less/lesskey ${XDG_CONFIG_HOME}/lesskey || true

mpv:
	@ln -sviT ${DOTFILES}/configs/mpv ${XDG_CONFIG_HOME}/mpv || true

neovim:
	@ln -sviT ${DOTFILES}/configs/neovim ${XDG_CONFIG_HOME}/nvim || true

newsboat:
	@# Store the url file at $XDG_CONFIG_HOME/newsboat/urls
	@mkdir -pv ${XDG_CONFIG_HOME}/newsboat
	@ln -sviT ${DOTFILES}/configs/newsboat/config ${XDG_CONFIG_HOME}/newsboat/config || true

utop:
	@ln -sviT ${DOTFILES}/configs/ocaml/utop ${XDG_CONFIG_HOME}/utop || true

lambda-term:
	@ln -sviT ${DOTFILES}/configs/ocaml/lambda-term-inputrc ${XDG_CONFIG_HOME}/lambda-term-inputrc || true

ocaml: utop lambda-term

pylint:
	@ln -sviT ${DOTFILES}/configs/python/pylintrc ${HOME}/.config/pylintrc || true

pycodestyle:
	@ln -sviT ${DOTFILES}/configs/python/pycodestyle ${XDG_CONFIG_HOME}/pycodestyle || true

python: pylint pycodestyle

rustfmt:
	@ln -sviT ${DOTFILES}/configs/rust/fmt ${XDG_CONFIG_HOME}/rustfmt || true

cargo:
	@ln -sviT ${DOTFILES}/configs/rust/cargo/config.toml ${CARGO_HOME}/config.toml || true

rust: rustfmt cargo

shellcheck:
	@ln -sviT ${DOTFILES}/configs/shellcheck/shellcheckrc ${XDG_CONFIG_HOME}/shellcheckrc || true

vim:
	@# With an older vim might have to symlink ~/.vim/vimrc to configs/vim/vimrc
	@ln -sviT ${DOTFILES}/configs/vim ${XDG_CONFIG_HOME}/vim || true

zathura:
	@ln -sviT ${DOTFILES}/configs/zathura ${XDG_CONFIG_HOME}/zathura || true
