{pkgs, ...}: {
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  # Tailscale + Mullvad coexistence.
  #
  # Mullvad's kill switch is an nftables ruleset that drops every packet
  # lacking its firewall mark, so the tailscale0 overlay dies whenever the
  # VPN is up (ssh over tailscale just times out). Mullvad's own split-tunnel
  # gets excluded traffic past that firewall by stamping it with a ct mark
  # (0x00000f41). Do the same for the tailscale0 interface: mark it so
  # Mullvad's always-present "accept ct mark 0x00000f41" rule lets it through.
  # Only the ct mark, not Mullvad's routing mark (0x6d6f6c65): that one shoves
  # traffic out the physical NIC, which is wrong for the overlay (it must stay
  # on tailscale0). The firewall drop is the whole problem; the ct mark alone
  # clears it.
  #
  # This lives in its own nftables table, so Mullvad flushing and rebuilding
  # its ruleset on every reconnect can't wipe it. Rules match by interface, so
  # they're inert until tailscale0 exists. Marks per Mullvad's
  # split-tunneling-with-linux-advanced doc.
  systemd.services.tailscale-mullvad = {
    description = "let tailscale through Mullvad's kill switch";
    after = ["mullvad-daemon.service" "tailscaled.service" "firewall.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.nftables}/bin/nft -f ${pkgs.writeText "ts-mullvad.nft" ''
        table inet ts-mullvad {
          chain prerouting {
            type filter hook prerouting priority -160; policy accept;
            iifname "tailscale0" ct mark set 0x00000f41
          }
          chain output {
            type filter hook output priority -160; policy accept;
            oifname "tailscale0" ct mark set 0x00000f41
          }
        }
      ''}";
      ExecStop = "${pkgs.nftables}/bin/nft delete table inet ts-mullvad";
    };
  };
}
