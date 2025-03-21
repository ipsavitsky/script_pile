set -o xtrace

sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y

# unfortunately, nixGL requires --impure to build
nix profile upgrade --all --impure

flatpak update

rustup self update
rustup update

cargo install-update -ag

ghcup upgrade
ghcup install ghc latest
ghcup install cabal latest
ghcup install hls latest
ghcup install stack latest

cabal update -j
#TODO: somehow get this list ourselves?
cabal install --overwrite-policy=always -j hoogle pandoc-cli ShellCheck

gup update

pipx upgrade-all

bun upgrade
bun update --global

doom upgrade --aot -! -j "$(nproc)"
