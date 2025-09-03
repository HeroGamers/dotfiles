{
  inputs,
  pkgs,
  lib,
  ...
}: {
  # Enable cache for the Walker flake
  # https://wiki.hyprland.org/Nix/Cachix/
  nix.settings = {
    substituters = ["https://walker.cachix.org" "https://walker-git.cachix.org"];
    trusted-public-keys = ["walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM=" "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="];
  };
}
