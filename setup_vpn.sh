#!/bin/bash

function setup_vpn {
    local original_vpn_connection_id="$1"
    local ovpn_file="$2"
    local new_vpn_connection_id="$3"

    nmcli connection show "${new_vpn_connection_id}" &> /dev/null
    vpn_connection_exists=$?
    if [ $vpn_connection_exists -eq 0 ]; then
        echo "VPN client configuration for ${new_vpn_connection_id} already exists. Skipping."
    else
        nmcli connection import type openvpn file ${ovpn_file} && \
        nmcli connection modify id "${original_vpn_connection_id}" \
        connection.id "${new_vpn_connection_id}" \
        ipv4.never-default yes \
        ipv6.never-default yes
    fi
}

###setup_vpn "VPN_Server_mzesch" "$HOME/mydata/auth_certificates_keys/vpn/tarent_vpn/tarent_vpn_2022/VPN_Server_mzesch.ovpn" "tarent VPN"
###setup_vpn "vpn-rewe-rz" "$HOME/mydata/auth_certificates_keys/vpn/rewe_digital_vpn/mzesch/vpn-rewe-rz.ovpn" "vpn-rewe-rz"
###setup_vpn "marks_expressvpn_germany_frankfurt_1_udp" "$HOME/mydata/auth_certificates_keys/vpn/expressvpn_private_vpn/marks_expressvpn_germany_frankfurt_1_udp.ovpn" "ExpressVPN Germany-Frankfurt-1"
