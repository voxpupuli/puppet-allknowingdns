# Puppet-allknowingdns

[![Build Status](https://github.com/voxpupuli/puppet-allknowingdns/workflows/CI/badge.svg)](https://github.com/voxpupuli/puppet-allknowingdns/actions?query=workflow%3ACI)
[![Release](https://github.com/voxpupuli/puppet-allknowingdns/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/puppet-allknowingdns/actions/workflows/release.yml)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/allknowingdns.svg)](https://forge.puppetlabs.com/puppet/allknowingdns)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/allknowingdns.svg)](https://forge.puppetlabs.com/puppet/allknowingdns)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/allknowingdns.svg)](https://forge.puppetlabs.com/puppet/allknowingdns)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/allknowingdns.svg)](https://forge.puppetlabs.com/puppet/allknowingdns)
[![puppetmodule.info docs](http://www.puppetmodule.info/images/badge.png)](http://www.puppetmodule.info/m/puppet-allknowingdns)
[![AGPL v3 License](https://img.shields.io/github/license/voxpupuli/puppet-allknowingdns.svg)](LICENSE)

[all-knowing-dns](https://metacpan.org/release/AllKnowingDNS) - Tiny DNS server for IPv6 Reverse DNS

See this [website](http://all-knowing-dns.zekjur.net/) for more informations.

## Table of contents

1. [Overview](#overview)
2. [Module description](#module-description)
   * [Dependencies](#dependencies)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)
7. [Authors](#authors)

## Overview

AllKnowingDNS provides reverse DNS for IPv6 networks which use SLAAC (autoconf), e.g. for a /64 network.

The problem with IPv6 reverse DNS and traditional nameservers is that the nameserver requires you to provide a zone file. Assuming you want to provide RDNS for a /64 network, you have 2\*\*64 = 18446744073709551616 different usable IP addresses (a little less if you are using SLAAC). Providing a zone file for that, even in a very terse notation, would consume a huge amount of disk space and could not possibly be held in the memory of the computers availablenowadays.

AllKnowingDNS instead generates PTR and AAAA records on the fly. You only configure which network you want to serve and what your entries should look like.

A [Puppet Module](https://puppet.com/docs/puppet/latest/modules.html) is a collection of related content that can be used to model the configuration of a discrete service.

# Module description

- [puppet-allknowingdns](https://forge.puppet.com/modules/puppet/allknowingdns/) on puppet forge.

## Dependencies

- [puppetlabs/puppetlabs-stdlib](https://github.com/puppetlabs/puppetlabs-stdlib) >= 4.1.0

## Usage

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

## Limitations

- Tested only debian for the moment.

## Contributors

* https://github.com/voxpupuli/puppet-allknowingdns/graphs/contributors

## Release Notes

See [CHANGELOG](https://github.com/voxpupuli/puppet-allknowingdns/blob/master/CHANGELOG.md) file.

## Development

Want to help - send a pull request.

## Authors

This module got migrated from sbadia to Vox Pupuli
