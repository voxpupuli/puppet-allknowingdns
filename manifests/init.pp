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
# [*upstream*]
#   Before answering a PTR query for this network,
#   AllKnowingDNS will ask the DNS server at address first, appending .upstream to the query.
#
# === Examples
#
#  class { 'allknowingdns':
#    listen  => ['2001:4d88:100e:1::3','79.140.39.197'],
#    network => '2001:4d88:100e:ccc0::/64',
#    address => 'nutzer.raumzeitlabor.de',
#  }
#
# === Authors
#
# Sebastien Badia <http://sebian.fr>
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
  $upstream       = 'UNSET',
  $package_name   = 'all-knowing-dns',
) {

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
