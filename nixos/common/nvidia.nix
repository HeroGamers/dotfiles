{...}: {
  # Enable cache for Cuda
  # https://wiki.nixos.org/wiki/CUDA#Setting_up_CUDA_Binary_Cache
  nix.settings = {
    substituters = ["https://cache.nixos-cuda.org" "https://cuda-maintainers.cachix.org"];
    trusted-public-keys = ["cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="];
  };

  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
    cudaVersion = "12";
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    open = false;
  };

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    # extraPackages = with pkgs; [
    #   # Required for modern Intel GPUs (Xe iGPU and ARC)
    #   # intel-media-driver # VA-API (iHD) userspace
    #   # vpl-gpu-rt # oneVPL (QSV) runtime

    #   # Optional (compute / tooling):
    #   # intel-compute-runtime # OpenCL (NEO) + Level Zero for Arc/Xe
    #   # NOTE: 'intel-ocl' also exists as a legacy package; not recommended for Arc/Xe.
    #   # libvdpau-va-gl       # Only if you must run VDPAU-only apps
    # ];
  };
}
