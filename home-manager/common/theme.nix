{
  inputs,
  ...
}:
{
  imports = [
    # Import Catpuccin
    inputs.catppuccin.homeModules.catppuccin
  ];

  # Catpuccin options
  # https://nix.catppuccin.com/options/home-manager-options.html
  catppuccin = {
    enable = true;
    autoEnable = true;
    cache.enable = true;

    accent = "pink";
    flavor = "macchiato";

    # keep-sorted start block=yes

    btop.enable = true;
    lazygit.enable = true;
    nvim.enable = true;
    tmux.enable = true;
    yazi.enable = true;
    zellij.enable = true;
    zsh-syntax-highlighting.enable = true;
    # keep-sorted end
  };
}
