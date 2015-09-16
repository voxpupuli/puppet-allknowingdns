# == Class: allknowingdns
#
# Install and configure allknowingdns using puppet.
#
# === Parameters
#
# [*listen*]
#   Listens on the given address (IPv4 and IPv6 is supported) on port 53.
#   Default: localhost (on both IPv4/v6)
#
# [*network*]
#   Specifies that queries for PTR records within the given network should be answered
#   (any query for an unconfigured network will be answered with NXDOMAIN).
#   You need to specify at least the resolves to directive afterwards.
#
# [*address*]
#   Specifies the address to which PTR records should resolve.
#   When answering AAAA queries, %DIGITS% will be parsed and converted back to an IPv6 address.
#
# [*address_prefix*]
#   Specifies the address prefix (before %DIGITS%) to which PTR records should resolve.
#   Default: ipv6-
#
# [*exceptions*]
#   Specifies exceptions (specific addresses for IPv6 /128)
#   Default: {}
#
# [*upstream*]
#   Before answering a PTR query for this network,
#   AllKnowingDNS will ask the DNS server at address first, appending .upstream to the query.
#
# [*package_name*]
#   All-knowing-dns package name (depends on distribution)
#   Default to 'all-knowing-dns'
#
# === Examples
#
#  class { 'allknowingdns':
#    listen  => ['2001:db8:42::1', '203.0.113.1'],
#    network => '2001:db8:1337::/48',
#    address => 'example.com',
#  }
#
#  class { 'allknowingdns':
#    listen     => ['2001:db8:42::1', '203.0.113.1'],
#    network    => '2001:db8:1337::/48',
#    address    => 'example.com',
#    exceptions => {
#      '2001:db8:1337::1' => 'a.example.com',
#      '2001:db8:1337::2' => 'b.example.com'
#    }
#  }
#
# === Authors
#
# Sebastien Badia <http://sebian.fr>
# Julien Vaubourg <http://julien.vaubourg.com>
#
# === Copyright
#
# Copyleft 2013 Sebastien Badia.
# See LICENSE file.
#
class allknowingdns(
  $listen         = ['::1','127.0.0.1'],
  $network        = 'UNSET',
  $address        = 'UNSET',
  $address_prefix = 'ipv6-',
  $exceptions     = {},
  $upstream       = 'UNSET',
  $package_name   = 'all-knowing-dns',
) {

  validate_array($listen)
  validate_string($address_prefix)
  validate_hash($exceptions)

  if ! is_domain_name($address) {
    fail("${address} is not a valid domaine name")
  }

  package {$package_name:
    ensure => installed;
  }

  file {"/etc/${package_name}.conf":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("allknowingdns/${package_name}.conf.erb"),
    notify  => Service[$package_name],
    require => Package[$package_name],
  }

  service {$package_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package[$package_name];
  }

} # Class:: allknowingdns
