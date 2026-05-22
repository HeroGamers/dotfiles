{
  pkgs,
  inputs,
  ...
}:
{
  nixpkgs.overlays = [ inputs.llm-agents.overlays.default ];

  nix.settings = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  environment.systemPackages = with pkgs; [
    (llama-cpp.override { cudaSupport = true; })
  ];
}
