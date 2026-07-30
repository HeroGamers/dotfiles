{ lib, ... }:
{
  options.dotfiles.settings.services = {
    domain = lib.mkOption {
      type = lib.types.str;
      default = "herogamers.dev";
      description = "The base domain used for services.";
    };
  };
}
