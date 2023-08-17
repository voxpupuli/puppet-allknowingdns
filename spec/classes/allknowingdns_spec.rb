# frozen_string_literal: true

require 'spec_helper'
require 'shared_examples'

describe 'allknowingdns' do
  let :node do
    'foo.example.com'
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let :facts do
        os_facts
      end
      let :params_set do
        {
          listen: ['2001:4d88:100e:1::3', '79.140.39.197'],
          network: '2001:4d88:100e:ccc0::/64',
          address: 'nutzer.raumzeitlabor.de'
        }
      end

      it { is_expected.to contain_package('all-knowing-dns') }

      it {
        is_expected.to contain_service('all-knowing-dns').with(
          ensure: 'running',
          enable: true,
          hasstatus: true,
          hasrestart: true,
          require: 'Package[all-knowing-dns]'
        )
      }

      it {
        is_expected.to contain_file('/etc/all-knowing-dns.conf').with(
          ensure: 'file',
          owner: 'root',
          group: 'root',
          mode: '0644',
          notify: 'Service[all-knowing-dns]',
          require: 'Package[all-knowing-dns]'
        )
      }

      context 'With params' do
        let(:params) { params_set }

        it { is_expected.to contain_file('/etc/all-knowing-dns.conf').with_content(%r{listen #{params_set[:listen][0]}}) }
        it { is_expected.to contain_file('/etc/all-knowing-dns.conf').with_content(%r{listen #{params_set[:listen][1]}}) }
        it { is_expected.to contain_file('/etc/all-knowing-dns.conf').with_content(%r{network #{params_set[:network]}}) }
        it { is_expected.to contain_file('/etc/all-knowing-dns.conf').with_content(%r{resolves to ipv6-%DIGITS%.#{params_set[:address]}}) }

        context 'Without prefix address' do
          let(:params) { params_set.merge(address_prefix: 'UNSET') }

          it { is_expected.to contain_file('/etc/all-knowing-dns.conf').with_content(%r{resolves to %DIGITS%.#{params_set[:address]}}) }
        end

        context 'With prefix address' do
          let(:params) { params_set.merge(address_prefix: 'adsl.ipv6.') }

          it { is_expected.to contain_file('/etc/all-knowing-dns.conf').with_content(%r{resolves to adsl.ipv6.%DIGITS%.#{params_set[:address]}}) }
        end

        context 'With upstream' do
          context 'set to an IPv6 address' do
            let(:params) { params_set.merge(upstream: '2001:4d88:100e:1::2') }

            it { is_expected.to contain_file('/etc/all-knowing-dns.conf').with_content(%r{with upstream 2001:4d88:100e:1::2}) }
          end

          context 'set to an IPv4 address' do
            let(:params) { params_set.merge(upstream: '8.8.8.8') }

            it { is_expected.to contain_file('/etc/all-knowing-dns.conf').with_content(%r{with upstream 8.8.8.8}) }
          end

          context 'set to a hostname' do
            let(:params) { params_set.merge(upstream: 'google-public-dns-a.google.com') }

            it { is_expected.to contain_file('/etc/all-knowing-dns.conf').with_content(%r{with upstream google-public-dns-a.google.com}) }
          end
        end
      end
    end
  end
end
