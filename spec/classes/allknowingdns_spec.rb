require 'spec_helper'
require 'shared_examples'

describe 'allknowingdns', :type => :class do

  let :params_set do
    {
      :listen  => ['2001:4d88:100e:1::3','79.140.39.197'],
      :network => '2001:4d88:100e:ccc0::/64',
      :address => 'nutzer.raumzeitlabor.de',
    }
  end

  describe 'input validation' do
    describe 'invalid address' do
      #https://github.com/puppetlabs/puppetlabs-stdlib/blob/master/lib/puppet/parser/functions/is_domain_name.rb
      let(:params) {{ :address => 'wrong%domain.net' }}
      it_raises 'a Puppet::Error', /is not a valid domaine name/
    end
  end

  it { is_expected.to contain_package('all-knowing-dns') }
  it { is_expected.to contain_service('all-knowing-dns').with(
    :ensure     => 'running',
    :enable     => true,
    :hasstatus  => true,
    :hasrestart => true,
    :require    => 'Package[all-knowing-dns]'
  )}

  it { is_expected.to contain_file('/etc/all-knowing-dns.conf').with(
     :ensure   => 'file',
    :owner    => 'root',
    :group    => 'root',
    :mode     => '0644',
    :notify   => 'Service[all-knowing-dns]',
    :require  => 'Package[all-knowing-dns]'
  )}

  context 'With params' do
    let(:params) { params_set }

    it { is_expected.to contain_file('/etc/all-knowing-dns.conf').with_content(/listen #{params_set[:listen][0]}/)}
    it { is_expected.to contain_file('/etc/all-knowing-dns.conf').with_content(/listen #{params_set[:listen][1]}/)}
    it { is_expected.to contain_file('/etc/all-knowing-dns.conf').with_content(/network #{params_set[:network]}/)}
    it { is_expected.to contain_file('/etc/all-knowing-dns.conf').with_content(/resolves to ipv6-%DIGITS%.#{params_set[:address]}/)}
    context 'Without prefix address' do
      let(:params) { params_set.merge({ :address_prefix => 'UNSET' }) }
      it { is_expected.to contain_file('/etc/all-knowing-dns.conf').with_content(/resolves to %DIGITS%.#{params_set[:address]}/)}
    end
    context 'With prefix address' do
      let(:params) { params_set.merge({ :address_prefix => 'adsl.ipv6.' }) }
      it { is_expected.to contain_file('/etc/all-knowing-dns.conf').with_content(/resolves to adsl.ipv6.%DIGITS%.#{params_set[:address]}/)}
    end
    context 'With upstream' do
      context 'set to an IPv6 address' do
        let(:params) { params_set.merge({ :upstream => '2001:4d88:100e:1::2' }) }
        it { is_expected.to contain_file('/etc/all-knowing-dns.conf').with_content(/with upstream 2001:4d88:100e:1::2/)}
      end
      context 'set to an IPv4 address' do
        let(:params) { params_set.merge({ :upstream => '8.8.8.8' }) }
        it { is_expected.to contain_file('/etc/all-knowing-dns.conf').with_content(/with upstream 8.8.8.8/)}
      end
      context 'set to a hostname' do
        let(:params) { params_set.merge({ :upstream => 'google-public-dns-a.google.com' }) }
        it { is_expected.to contain_file('/etc/all-knowing-dns.conf').with_content(/with upstream google-public-dns-a.google.com/)}
      end
    end
  end
end
