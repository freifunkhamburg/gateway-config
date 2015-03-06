class { 'ffnord::params':
  router_id => "10.112.1.11", # The id of this router, probably the ipv4 address
                              # of the mesh device of the providing community
  icvpn_as => "49009",        # The as of the providing community
  wan_devices => ['eth0'],     # A array of devices which should be in the wan zo                                                                                       ne
}

ffnord::mesh { 'mesh_ffhh':
      mesh_name    => "Freifunk Hamburg",
      mesh_code    => "ffhh",
      mesh_as      => 49009,
      mesh_mac     => "de:ad:be:ef:01:01",
      mesh_ipv6    => "2a03:2267::202/64",
      mesh_ipv4    => "10.112.1.11/18",
      mesh_mtu     => "1406",
      range_ipv4   => "10.112.0.0/16",
      mesh_peerings => "/root/mesh_peerings.yaml",

      fastd_secret => "/root/fastd_secret.key",
      fastd_port   => 10000,
      fastd_peers_git => 'git@git.hamburg.freifunk.net:fastdkeys',

      dhcp_ranges => [ '10.112.2.2 10.112.9.254'
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
    'suede0':
      local_ipv6 => "fd2a:322:6700:cc00::2",
      remote_ipv6 => "fd2a:322:6700:cc00::1",
      remote_as => "49009",
      uplink_interface => "eth1";
}
ffnord::uplink6::interface {
    'eth1':;
}

ffnord::icvpn::setup { 'hamburg01':
    icvpn_as => 49009,
    icvpn_ipv4_address => "10.207.0.61",
    icvpn_ipv6_address => "fec0::a:cf:0:31",
    icvpn_exclude_peerings => [hamburg],
    tinc_keyfile       => "/root/tinc_rsa_key.priv"
}


class {
  'ffnord::uplink::ip':
    nat_network => '185.66.193.61/32',
    tunnel_network => '100.64.0.128/26',
}
ffnord::uplink::tunnel {
    'ffrlber':
      local_public_ip => "80.252.100.115",
      remote_public_ip => "185.66.195.1",
      local_ipv4 => "100.64.0.161/31",
      remote_ip => "100.64.0.160",
      remote_as => "201701";
    'ffrldus':
      local_public_ip => "80.252.100.115",
      remote_public_ip => "185.66.193.1",
      local_ipv4 => "100.64.0.163/31",
      remote_ip => "100.64.0.162",
      remote_as => "201701";
}

class { 'ffnord::alfred': master => false }

class { 'ffnord::etckeeper': }
