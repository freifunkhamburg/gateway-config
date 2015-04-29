class { 'ffnord::params':
  router_id => "10.112.1.3",
  icvpn_as => "49009",
  wan_devices => ['eth0'],

  conntrack_max => 131072,
  conntrack_tcp_timeout => 3600,
  conntrack_udp_timeout => 600,

  wmem_default => 83886080,
  wmem_max     => 83886080,
  rmem_default => 83886080,
  rmem_max     => 83886080,

  max_backlog  => 1000,
}

ffnord::mesh { 'mesh_ffhh':
      mesh_name    => "Freifunk Hamburg",
      mesh_code    => "ffhh",
      mesh_as      => 49009,
      mesh_mac     => "de:ad:be:ef:03:03",
      vpn_mac      => "de:ad:be:ff:03:03",
      mesh_ipv6    => "2a03:2267::301/64",
      mesh_ipv4    => "10.112.1.3/18",
      mesh_mtu     => "1406",
      range_ipv4   => "10.112.0.0/16",
      mesh_peerings => "/root/mesh_peerings.yaml",

      fastd_secret => "/root/fastd_secret.key",
      fastd_port   => 10000,
      fastd_peers_git => 'git@git.hamburg.freifunk.net:fastdkeys',

      dhcp_ranges => [ '10.112.18.2 10.112.25.254'
                     ],
      dns_servers => [ '10.112.1.1'
                     ],
}

ffnord::dhcpd::static {
  'ffhh': static_git => 'https://github.com/freifunkhamburg/dhcp-static.git';
}

ffnord::uplink6::bgp {
    'wende0':
      local_ipv6 => "2a03:2267:ffff:0b00::2",
      remote_ipv6 => "2a03:2267:ffff:0b00::1",
      remote_as => "49009",
      uplink_interface => "eth1";
}
ffnord::uplink6::interface {
    'eth1':;
}

class {
  'ffnord::uplink::ip':
    nat_network => '185.66.193.59/32',
    tunnel_network => '100.64.0.0/28',
}
ffnord::uplink::tunnel {
    'ffrlber':
      local_public_ip => "213.128.138.161",
      remote_public_ip => "185.66.195.0",
      local_ipv4 => "100.64.0.3/31",
      remote_ip => "100.64.0.2",
      tunnel_mtu => "1400",
      remote_as => "201701";
    'ffrlfra':
      local_public_ip => "213.128.138.161",
      remote_public_ip => "195.20.242.196",
      local_ipv4 => "100.64.0.9/31",
      remote_ip => "100.64.0.8",
      tunnel_mtu => "1400",
      remote_as => "201701";
}

ffnord::icvpn::setup { 'hamburg03':
    icvpn_as => 49009,
    icvpn_ipv4_address => "10.207.0.63",
    icvpn_ipv6_address => "fec0::a:cf:0:3f",
    icvpn_exclude_peerings => [hamburg],
    tinc_keyfile       => "/root/tinc_rsa_key.priv"
}

class { 'ffnord::alfred': master => false }

class { 'ffnord::etckeeper': }

class {
  'ffnord::monitor::zabbix':
    zabbixserver => "80.252.106.17";
}
