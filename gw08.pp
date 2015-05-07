class { 'ffnord::params':
  router_id => "10.112.1.8", # The id of this router, probably the ipv4 address
                              # of the mesh device of the providing community
  icvpn_as => "49009",        # The as of the providing community
  wan_devices => ['eth0'],     # A array of devices which should be in the wan zone
  
  conntrack_max => 131072,
  conntrack_tcp_timeout => 3600,
  conntrack_udp_timeout => 600,

  wmem_default => 83886080
  wmem_max     => 83886080
  rmem_default => 83886080,
  rmem_max     => 83886080,

  max_backlog  => 1000,
}

ffnord::mesh { 'mesh_ffhh':
      mesh_name    => "Freifunk Hamburg",
      mesh_code    => "ffhh",
      mesh_as      => 49009,
      mesh_mac     => "de:ad:be:ef:88:88",
      vpn_mac      => "de:ad:be:ff:88:88",
      mesh_ipv6    => "2a03:2267::b01/64",
      mesh_ipv4    => "10.112.1.8/18",
      mesh_mtu     => "1406",
      range_ipv4   => "10.112.0.0/16",
      mesh_peerings => "/root/mesh_peerings.yaml",

      fastd_secret => "/root/fastd_secret.key",
      fastd_port   => 10000,
      fastd_peers_git => 'git@git.hamburg.freifunk.net:fastdkeys',

      dhcp_ranges => [ '10.112.50.2 10.112.53.254'
                     ],
      dns_servers => [ '10.112.1.1'
                     ],
}

ffnord::dhcpd::static {
  'ffhh': static_git => 'https://github.com/freifunkhamburg/dhcp-static.git';
}

class {
  'ffnord::uplink::ip':
    nat_network => '185.66.193.62/32',
    tunnel_network => '100.64.0.160/27',
}
ffnord::uplink::tunnel {
    'ffrlfra':
      local_public_ip => "81.7.3.229",
      remote_public_ip => "185.66.194.1",
      local_ipv4 => "100.64.0.175/31",
      remote_ip => "100.64.0.174/31",
      tunnel_mtu => "1400",
      remote_as => "201701";
    'ffrldus':
      local_public_ip => "81.7.3.229",
      remote_public_ip => "185.66.193.1",
      local_ipv4 => "100.64.0.177/31",
      remote_ip => "100.64.0.176/31",
      tunnel_mtu => "1400",
      remote_as => "201701";
}

class { 'ffnord::alfred': master => false }

class { 'ffnord::etckeeper': }

class {
  'ffnord::monitor::zabbix':
    zabbixserver => "80.252.106.17";
}
