{
  pkgs,
  ...
}:
{
  # Enable cache for Cuda
  # https://wiki.nixos.org/wiki/CUDA#Setting_up_CUDA_Binary_Cache
  nix.settings = {
    substituters = [
      "https://cache.nixos-cuda.org"
      "https://cuda-maintainers.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
    cudaVersion = "13";
  };

  environment.systemPackages = with pkgs; [
    cudatoolkit
  ];

  # https://wiki.nixos.org/wiki/CUDA#CUDA_under_WSL
  environment.variables = {
    CUDA_PATH = [ "${pkgs.cudatoolkit}" ];
    LD_LIBRARY_PATH = [ "/usr/lib/wsl/lib:${pkgs.linuxPackages.nvidia_x11}/lib:${pkgs.ncurses5}/lib" ];
    EXTRA_LDFLAGS = [ "-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib" ];
    EXTRA_CCFLAGS = [ "-I/usr/include" ];
  };
}
