{
  config,
  lib,
  ...
}:
{
  # https://wiki.nixos.org/wiki/NVIDIA#Offload_mode
  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];

  hardware.nvidia = {
    # The NVIDIA NVIDIA GeForce GTX 1050 GPU installed in this system is supported through the NVIDIA 580.xx Legacy drivers.
    package = lib.mkForce config.boot.kernelPackages.nvidiaPackages.legacy_580;

    # Required for Optimus laptops
    modesetting.enable = true;

    # Power management (cause, well, laptop)
    powerManagement.enable = true;

    # https://wiki.nixos.org/wiki/NVIDIA#Hybrid_graphics_with_PRIME
    prime = {
      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:1@0:0:0";
      # amdgpuBusId = "PCI:5@0:0:0"; # If you have an AMD iGPU

      # https://wiki.nixos.org/wiki/NVIDIA#Offload_mode
      offload = {
        enable = true;
        enableOffloadCmd = true; # adds `nvidia-offload` helper command
      };
    };
  };

  # Disable PCIe ASPM - it caused some issues on my old-ass Pascal card (1050)
  boot.kernelParams = [ "pcie_aspm=off" ];

  # Be more conservative about power state transitions
  # boot.extraModprobeConfig = ''
  #   options nvidia NVreg_DynamicPowerManagement=0x02
  # '';
}
