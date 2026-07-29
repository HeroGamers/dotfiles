# Configuration
server := "wss://ws.qs.ax"
fw_mark := "51820"

# Paths to SOPS secrets
secret_wg_privkey := "/run/secrets/wg-key-client"
secret_wstunnel := "/run/secrets/services/wstunnel/path_prefix"

# WireGuard Client settings
wg_ipv4_base := "10.100.100"
wg_ipv6_base := "fdf1:80c2:33a9::"
wg_server_pubkey := "e784IO8IPkTKO6sZSDZ4XVnZliEFQWp3Pt+cRfcGj1I="

default:
    @just --list

# Bring up the VPN purely in memory. 
# Usage: just ws-wg [octet] [sni]
ws-wg octet="2" sni="ws.qs.ax":
    #!/usr/bin/env bash
    set -e
    
    # Enforce strict file permissions for the ephemeral config
    umask 077
    
    # Verify SOPS secrets exist
    if [ ! -f "{{secret_wg_privkey}}" ] || [ ! -f "{{secret_wstunnel}}" ]; then
        echo "Error: Required secrets not found in /run/secrets/"
        exit 1
    fi
    
    echo "Reading secrets from SOPS..."
    WG_PRIVKEY=$(cat "{{secret_wg_privkey}}")
    WSTUNNEL_SECRET=$(cat "{{secret_wstunnel}}")

    # Verify not empty
    if [ -z "$WG_PRIVKEY" ] || [ -z "$WSTUNNEL_SECRET" ]; then
        echo "Error: Secrets are empty. Please check your SOPS configuration."
        exit 1
    fi
    
    # Create an ephemeral directory for the config
    WG_TEMP_DIR=$(mktemp -d)
    WG_CONF="$WG_TEMP_DIR/wg0.conf"
    
    echo "Generating ephemeral WireGuard configuration..."
    cat <<EOF > "$WG_CONF"
    [Interface]
    PrivateKey = $WG_PRIVKEY
    Address = {{wg_ipv4_base}}.{{octet}}/24, {{wg_ipv6_base}}{{octet}}/128
    FwMark = {{fw_mark}}
    
    [Peer]
    PublicKey = {{wg_server_pubkey}}
    Endpoint = 127.0.0.1:51820
    AllowedIPs = 0.0.0.0/0, ::/0
    EOF
    
    echo "Bringing up ephemeral interface wg0 using config at $WG_CONF..."
    sudo wg-quick up "$WG_CONF"
    
    # Trap ensures teardown of both the interface and the temp directory
    trap 'echo -e "\nShredding ephemeral config and shutting down..."; sudo wg-quick down "$WG_CONF" || true; rm -rf "$WG_TEMP_DIR"' EXIT INT TERM
    
    echo "Starting wstunnel connection to {{server}} using SNI: {{sni}}..."
    sudo wstunnel client \
        --socket-so-mark {{fw_mark}} \
        -P "$WSTUNNEL_SECRET" \
        -L "udp://51820:127.0.0.1:51820?timeout_sec=0" \
        --tls-sni-override "{{sni}}" \
        "{{server}}"

# Start an isolated SSH tunnel over wstunnel
# Usage: just ws-ssh [sni] [local_port]
ws-ssh sni="ws.qs.ax" local_port="9922":
    #!/usr/bin/env bash
    set -e
    
    if [ ! -f "{{secret_wstunnel}}" ]; then
        echo "Error: Wstunnel secret not found in /run/secrets/"
        exit 1
    fi
    
    WSTUNNEL_SECRET=$(cat "{{secret_wstunnel}}")
    
    echo "Starting wstunnel SSH tunnel on localhost:{{local_port}} using SNI: {{sni}}..."
    echo "-> Open another terminal and run: ssh -p {{local_port}} your_username@127.0.0.1"
    
    sudo wstunnel client \
        -P "$WSTUNNEL_SECRET" \
        -L "tcp://{{local_port}}:127.0.0.1:22" \
        --tls-sni-override "{{sni}}" \
        "{{server}}"

# Emergency teardown if the terminal is killed ungracefully
ws-down:
    sudo ip link delete wg0 || true
    sudo pkill wstunnel || true
