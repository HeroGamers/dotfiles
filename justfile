# https://nix.dev/manual/nix/latest/package-management/garbage-collection
gc: nix-gc

# deletes all old generations of all profiles in /nix/var/nix/profiles
nix-gc:
    nix-collect-garbage --delete-older-than 7d
