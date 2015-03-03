class { 'ffnord::params':
  router_id => "10.112.12.1", # The id of this router, probably the ipv4 address
                              # of the mesh device of the providing community
  icvpn_as => "65112",        # The as of the providing community
  wan_devices => ['eth0'],     # A array of devices which should be in the wan zone
}

ffnord::mesh { 'mesh_ffhh':
      mesh_name    => "Freifunk Hamburg",
      mesh_code    => "ffhh",
      mesh_as      => 65112,
      mesh_mac     => "de:ad:be:ef:05:05",
      mesh_ipv6    => "2a03:2267::201/64",
      mesh_ipv4    => "10.112.42.1/18",
      mesh_mtu     => "1406",
      range_ipv4   => "10.112.0.0/16",
      mesh_peerings => "/root/mesh_peerings.yaml",

      fastd_secret => "/root/fastd_secret.key",
      fastd_port   => 10000,
      fastd_peers_git => 'git@git.hamburg.freifunk.net:fastdkeys',

      dhcp_ranges => [ '10.112.10.2 10.112.17.254'
                     ],
      dns_servers => [ '10.112.1.1'
                     ],
}

class {
  'ffnord::monitor::munin':
    host => '78.47.49.236'
}

ffnord::dhcpd::static {
  'ffhh': static_git => 'https://github.com/freifunkhamburg/dhcp-static.git';
}

ffnord::uplink6::bgp {
    'wandale0':
      local_ipv6 => "fd52:2cc2:fd0d::2",
      remote_ipv6 => "fd52:2cc2:fd0d::1",
      remote_as => "49009";
}
ffnord::uplink6::interface {
    'eth1':;
}

class {
  'ffnord::uplink::ip':
    nat_network => '185.66.193.2/32',
    tunnel_network => '100.64.0.0/28',
}
ffnord::uplink::tunnel {
    'ffrlber':
      local_public_ip => "213.238.45.66",
      remote_public_ip => "185.66.195.1",
      local_ipv4 => "100.64.0.5/31",
      remote_ip => "100.64.0.4",
      remote_as => "201701";
    'ffrlfra':
      local_public_ip => "213.238.45.66",
      remote_public_ip => "195.20.242.195",
      local_ipv4 => "100.64.0.7/31",
      remote_ip => "100.64.0.6",
      remote_as => "201701";
}

ffnord::icvpn::setup { 'hamburg02':
    icvpn_as => 65112,
    icvpn_ipv4_address => "10.207.0.64",
    icvpn_ipv6_address => "fec0::a:cf:0:40",
    icvpn_exclude_peerings     => [hamburg],
    tinc_keyfile       => "/root/tinc_rsa_key.priv"
}

class { 'ffnord::alfred': master => false }

class { 'ffnord::etckeeper': }
