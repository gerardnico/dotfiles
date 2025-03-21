# Nix env



if [ -e "$HOME"/.nix-profile/etc/profile.d/nix.sh ]; then
  . "$HOME"/.nix-profile/etc/profile.d/nix.sh;
fi

# Nix package path
# The path are separated by space
# for now, only a channel, but people generally add a `nix-build` directory
# https://nix.dev/manual/nix#sec-channels / https://nixos.wiki/wiki/Nix_channels
# Most users will want the stable/large channel
# https://channels.nixos.org/
export NIX_PATH="nixpkgs=channel:nixos-24.11"
