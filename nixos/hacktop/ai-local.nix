{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Pascal-specific variant of llama-cpp - pinned to stable nixpkgs to avoid the huge compile each time
    stable.pkgsForCudaArch.sm_61.llama-cpp
  ];
}
