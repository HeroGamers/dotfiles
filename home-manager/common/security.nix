{
  lib,
  inputs,
  pkgs,
  ...
}:
{
  programs.zsh.initContent = lib.mkOrder 1337 ''
    function ctf() {
            local output exit_code nav_path temp_file

            # Temp file for navigation path
            temp_file="${"TMPDIR:-/tmp"}/ctf-man.path"

            # No arguments = TUI mode, run directly to preserve TTY
            if [ $# -eq 0 ]; then
                "${inputs.ctf-man.packages.${pkgs.stdenv.hostPlatform.system}.ctf-man}/bin/ctf-man"
                exit_code=$?

                # Check if navigation path was written to temp file
                if [ $exit_code -eq 0 ] && [ -f "$temp_file" ]; then
                    nav_path=$(cat "$temp_file")
                    rm -f "$temp_file"

                    if [ -d "$nav_path" ]; then
                        cd "$nav_path" || return 1
                    fi
                fi

                return $exit_code
            fi

            # CLI mode - capture output for error handling
            output=$("${
              inputs.ctf-man.packages.${pkgs.stdenv.hostPlatform.system}.ctf-man
            }/bin/ctf-man" "$@" 2>&1)
            exit_code=$?

            if [ $exit_code -eq 0 ]; then
                # Check temp file for navigation path
                if [ -f "$temp_file" ]; then
                    nav_path=$(cat "$temp_file")
                    rm -f "$temp_file"

                    if [ -d "$nav_path" ]; then
                        echo "Created and entering: $nav_path"
                        cd "$nav_path" || return 1
                    fi
                else
                    printf '%s\n' "$output"
                fi
            else
                printf '%s\n' "$output" >&2
                return $exit_code
            fi
        }
  '';
}
