{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}: {
    environment.systemPackages = with pkgs; [
        (python3.withPackages (python-pkgs: [
            python-pkgs.aiohttp
            python-pkgs.beautifulsoup4
            python-pkgs.matplotlib
            python-pkgs.numpy
            python-pkgs.pandas
            python-pkgs.pillow
            python-pkgs.pyaudio
            python-pkgs.requests
            python-pkgs.scipy
            python-pkgs.sympy
            python-pkgs.tkinter
        ]))
    ];
}
