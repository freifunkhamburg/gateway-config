class { 'ffnord::params':
  router_id => "10.112.1.5", # The id of this router, probably the ipv4 address
                              # of the mesh device of the providing community
  icvpn_as => "49009",   # The as of the providing community
  wan_devices => ['eth0'],     # A array of devices which should be in the wan zone
}

ffnord::mesh { 'mesh_ffhh':
      mesh_name    => "Freifunk Hamburg",
      mesh_code    => "ffhh",
      mesh_as      => 49009,
      mesh_mac     => "de:ad:be:ef:22:22",
      vpn_mac      => "de:ad:be:ff:22:22",
      mesh_ipv6    => "2a03:2267::d01/64",
      mesh_ipv4    => "10.112.1.5/18",
      mesh_mtu     => "1426",
      range_ipv4   => "10.112.0.0/16",
      mesh_peerings => "/root/mesh_peerings.yaml",

      fastd_secret => "/root/fastd_secret.key",
      fastd_port   => 10000,
      fastd_peers_git => 'git@git.hamburg.freifunk.net:fastdkeys',

      dhcp_ranges => [ '10.112.34.2 10.112.41.254'
                     ],
      dns_servers => [ '10.112.1.1'
                     ],
}


ffnord::dhcpd::static {
  'ffhh': static_git => 'https://github.com/freifunkhamburg/dhcp-static.git';
}

class {
  'ffnord::uplink::ip':
    nat_network => '185.66.193.60/32',
    tunnel_network => '100.64.0.0/28',
}
ffnord::uplink::tunnel {
    'ffrldus':
      local_public_ip => "192.168.0.150",
      remote_public_ip => "185.66.193.1",
      local_ipv4 => "100.64.0.119/31",
      remote_ip => "100.64.0.118",
      remote_as => "201701";
    'ffrlfra':
      local_public_ip => "192.168.0.150",
      remote_public_ip => "185.66.194.1",
      local_ipv4 => "100.64.0.117/31",
      remote_ip => "100.64.0.116",
      remote_as => "201701";
}

class { 'ffnord::alfred': master => false }

class { 'ffnord::etckeeper': }

class {
  'ffnord::monitor::zabbix':
    zabbixserver => "80.252.106.17";
}
