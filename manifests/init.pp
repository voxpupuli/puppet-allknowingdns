# @summary Install and configure allknowingdns using puppet.
# @param listen Listens on the given address (IPv4 and IPv6 is supported) on port 53.
# @param network Specifies that queries for PTR records within the given network should be answered (any query for an unconfigured network will be answered with NXDOMAIN). You need to specify at least the resolves to directive afterwards.
# @param address Specifies the address to which PTR records should resolve. When answering AAAA queries, %DIGITS% will be parsed and converted back to an IPv6 address.
# @param address_prefix Specifies the address prefix (before %DIGITS%) to which PTR records should resolve.
# @param exceptions Specifies exceptions (specific addresses for IPv6 /128)
# @param upstream Before answering a PTR query for this network, AllKnowingDNS will ask the DNS server at address first, appending .upstream to the query.
# @param package_name All-knowing-dns package name (depends on distribution)
# @example
#  class { 'allknowingdns':
#    listen  => ['2001:db8:42::1', '203.0.113.1'],
#    network => '2001:db8:1337::/48',
#    address => 'example.com',
#  }
# @example
#  class { 'allknowingdns':
#    listen     => ['2001:db8:42::1', '203.0.113.1'],
#    network    => '2001:db8:1337::/48',
#    address    => 'example.com',
#    exceptions => {
#      '2001:db8:1337::1' => 'a.example.com',
#      '2001:db8:1337::2' => 'b.example.com'
#    }
#  }
class allknowingdns (
  Array[Stdlib::IP::Address] $listen = ['::1','127.0.0.1'],
  String[1] $network                 = 'UNSET',
  String[1] $address                 = 'UNSET',
  String[1] $address_prefix          = 'ipv6-',
  Hash $exceptions                   = {},
  String[1] $upstream                = 'UNSET',
  String[1] $package_name            = 'all-knowing-dns',
) {
  if ! is_domain_name($address) {
    fail("${address} is not a valid domaine name")
  }

  package { $package_name:
    ensure => installed;
  }

  file { "/etc/${package_name}.conf":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("allknowingdns/${package_name}.conf.erb"),
    notify  => Service[$package_name],
    require => Package[$package_name],
  }

  service { $package_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package[$package_name];
  }
}
