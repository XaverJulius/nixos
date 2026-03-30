# connect to wifi
nmtui

# generate ssh key
ssh-keygen
cat ~/.ssh/id_ed25519.pub

# install system
nix-shell -p git --run "git clone git@github.com:XaverJulius/nixos.git && cd nixos && ./install.sh"