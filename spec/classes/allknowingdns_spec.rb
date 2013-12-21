require 'spec_helper'

describe 'allknowingdns', :type => :class do

  let :params_set do
    {
      :listen  => ['2001:4d88:100e:1::3','79.140.39.197'],
      :network => '2001:4d88:100e:ccc0::/64',
      :address => 'nutzer.raumzeitlabor.de',
    }
  end

  describe 'input validation' do
    describe 'invalid upstream' do
      let(:params) { params_set.merge({ :upstream => '1.2.3.4.1' }) }
      it { expect { subject }.to raise_error(Puppet::Error, /is not a valid IP address/)}
    end

    describe 'invalid address' do
      #https://github.com/puppetlabs/puppetlabs-stdlib/blob/master/lib/puppet/parser/functions/is_domain_name.rb
      let(:params) {{ :address => 'wrong%domain.net' }}
      it { expect { subject }.to raise_error(Puppet::Error, /is not a valid domaine name/)}
    end
  end

  it { should contain_package('all-knowing-dns') }
  it { should contain_service('all-knowing-dns').with(
    :ensure     => 'running',
    :enable     => true,
    :hasstatus  => true,
    :hasrestart => true,
    :require    => 'Package[all-knowing-dns]'
  )}

  it { should contain_file('/etc/all-knowing-dns.conf').with(
     :ensure   => 'file',
    :owner    => 'root',
    :group    => 'root',
    :mode     => '0644',
    :notify   => 'Service[all-knowing-dns]',
    :require  => 'Package[all-knowing-dns]'
  )}

  context 'With params' do
    let(:params) { params_set }

    it { should contain_file('/etc/all-knowing-dns.conf').with_content(/listen #{params_set[:listen][0]}/)}
    it { should contain_file('/etc/all-knowing-dns.conf').with_content(/listen #{params_set[:listen][1]}/)}
    it { should contain_file('/etc/all-knowing-dns.conf').with_content(/network #{params_set[:network]}/)}
    it { should contain_file('/etc/all-knowing-dns.conf').with_content(/resolves to ipv6-%DIGITS%.#{params_set[:address]}/)}
    context 'Without prefix address' do
      let(:params) { params_set.merge({ :address_prefix => 'UNSET' }) }
      it { should contain_file('/etc/all-knowing-dns.conf').with_content(/resolves to %DIGITS%.#{params_set[:address]}/)}
    end
    context 'With prefix address' do
      let(:params) { params_set.merge({ :address_prefix => 'adsl.ipv6.' }) }
      it { should contain_file('/etc/all-knowing-dns.conf').with_content(/resolves to adsl.ipv6.%DIGITS%.#{params_set[:address]}/)}
    end
    context 'With upstream' do
      let(:params) { params_set.merge({ :upstream => '2001:4d88:100e:1::2' }) }
      it { should contain_file('/etc/all-knowing-dns.conf').with_content(/with upstream #{params_set[:upstream]}/)}
    end
  end
end
