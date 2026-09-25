{
  ...
}:
{
  programs.ssh = {
    enable = true;

    settings = {
      "nuc01" = {
        hostname = "192.168.13.244";
        user = "soc";
      };
      "nuc02" = {
        hostname = "192.168.13.245";
        user = "soc";
      };
      "nuc03" = {
        hostname = "192.168.13.246";
        user = "soc";
      };
      "nuc04" = {
        hostname = "192.168.13.247";
        user = "soc";
      };
      "nuc05" = {
        hostname = "192.168.13.249";
        user = "soc";
      };
      "nuc06" = {
        hostname = "192.168.13.250";
        user = "soc";
      };
      "nuc07" = {
        hostname = "192.168.13.248";
        user = "soc";
      };
      "wb-rpi" = {
        hostname = "192.168.13.15";
        user = "pi";
      };
    };
  };
}
