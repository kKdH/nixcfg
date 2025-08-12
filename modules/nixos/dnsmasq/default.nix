{ pkgs, lib, config, ... }:
let
  dhcp-host-address = "192.168.122.173";
in
{
  options = {
    dnsmasq.enable = lib.mkEnableOption "Enable dnsmasq";
    dnsmasq.interface = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = lib.mkIf config.dnsmasq.enable {
    services.dnsmasq = {
      enable = true;
      settings = {
        # upstream DNS servers
        server = [ "9.9.9.9" "8.8.8.8" "1.1.1.1" ];
        # sensible behaviours
        domain-needed = true;
        bogus-priv = true;
        no-resolv = true;

        # don't use /etc/hosts
        no-hosts = true;

        # Cache dns queries.
        cache-size = 1000;

        dhcp-range = [ "${config.dnsmasq.interface},192.168.122.10,192.168.122.254,24h" ];
        interface = config.dnsmasq.interface;
        dhcp-host = dhcp-host-address;

        # local domains
        local = "/steinweg4.net/";
        domain = "steinweg4.net";
        expand-hosts = true;

        address = "/steinweg4.net/192.168.122.10";
      };
    };
  };
}
