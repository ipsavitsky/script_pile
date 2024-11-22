set -o xtrace

sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y

nix profile upgrade --all

flatpak update

rustup self update
rustup update

cargo install-update -ag

ghcup upgrade
ghcup install ghc latest
ghcup install cabal latest
ghcup install hls latest
ghcup install stack latest

cabal v2-update -j
#TODO: somehow get this list ourselves?
cabal v2-install --overwrite-policy=always -j hoogle pandoc-cli

gup update

pipx upgrade-all

bun upgrade
bun update --global

doom upgrade --aot -! -j "$(nproc)"
