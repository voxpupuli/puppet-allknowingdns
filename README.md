# Puppet-allknowingdns

[![Build Status](https://travis-ci.org/voxpupuli/puppet-allknowingdns.png?branch=master)](https://travis-ci.org/voxpupuli/puppet-allknowingdns)
[![Puppet Forge](http://img.shields.io/puppetforge/v/voxpupuli/allknowingdns.svg)](https://forge.puppetlabs.com/voxpupuli/allknowingdns)
[![License](http://img.shields.io/:license-gpl3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0.html)

[all-knowing-dns](https://metacpan.org/release/AllKnowingDNS) - Tiny DNS server for IPv6 Reverse DNS

See this [website](http://all-knowing-dns.zekjur.net/) for more informations.

#### Table of contents

1. [Overview](#overview)
2. [Module description](#module-description)
   * [Dependencies](#dependencies)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

# Overview

AllKnowingDNS provides reverse DNS for IPv6 networks which use SLAAC (autoconf), e.g. for a /64 network.

The problem with IPv6 reverse DNS and traditional nameservers is that the nameserver requires you to provide a zone file. Assuming you want to provide RDNS for a /64 network, you have 2\*\*64 = 18446744073709551616 different usable IP addresses (a little less if you are using SLAAC). Providing a zone file for that, even in a very terse notation, would consume a huge amount of disk space and could not possibly be held in the memory of the computers availablenowadays.

AllKnowingDNS instead generates PTR and AAAA records on the fly. You only configure which network you want to serve and what your entries should look like.

A [Puppet Module](http://docs.puppetlabs.com/learning/modules1.html#modules) is a collection of related content that can be used to model the configuration of a discrete service.

# Module description

- [puppet-allknowingdns](http://forge.puppetlabs.com/voxpupuli/allknowingdns) on puppet forge.

## Dependencies
- [puppetlabs/puppetlabs-stdlib](https://github.com/puppetlabs/puppetlabs-stdlib) >= 4.1.0

# Usage

```puppet
class { 'allknowingdns':
  listen  => ['2001:db8:42::1', '203.0.113.1'],
  network => '2001:db8:1337::/48',
  address => 'example.com',
}
```

```puppet
class { 'allknowingdns':
  listen     => ['2001:db8:42::1', '203.0.113.1'],
  network    => '2001:db8:1337::/48',
  address    => 'example.com',
  exceptions => {
    '2001:db8:1337::1' => 'a.example.com',
    '2001:db8:1337::2' => 'b.example.com'
  }
}
```

# Limitations

- Tested only debian for the moment.

# Contributors

* https://github.com/voxpupuli/puppet-allknowingdns/graphs/contributors

# Release Notes

See [CHANGELOG](https://github.com/voxpupuli/puppet-allknowingdns/blob/master/CHANGELOG.md) file.

# Development

Want to help - send a pull request.
