#!/bin/sh

nix eval --impure --expr 'builtins.fromJSON (builtins.readFile ./settings.json)' | sed 's/«repeated»/"«repeated»"/g' | nixfmt > settings_convert.nix
nix eval --impure --expr 'builtins.fromJSON (builtins.readFile ./session.json)' | sed 's/«repeated»/"«repeated»"/g' | nixfmt > session_convert.nix
