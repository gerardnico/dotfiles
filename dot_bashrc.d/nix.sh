# Nix env



if [ -e "$HOME"/.nix-profile/etc/profile.d/nix.sh ]; then
  . "$HOME"/.nix-profile/etc/profile.d/nix.sh;
fi

# https://nix.dev/manual/nix#sec-channels
export NIX_PATH="nixpkgs=channel:nixos-22.25 nix-build"
