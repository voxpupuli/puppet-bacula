# frozen_string_literal: true

require 'spec_helper'

describe 'bacula::storage' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:node) { 'foo.example.com' }
      let(:facts) { facts }

      let(:pre_condition) do
        <<~PP
          class { 'bacula::client':
            password => Sensitive('fd-secret'),
          }
        PP
      end

      context 'with default parameters' do
        let(:params) do
          {
            password: sensitive('sd-secret')
          }
        end
        let(:sd_package) do
          {
            'Debian' => 'bacula-sd',
            'RedHat' => 'bacula-storage',
            'OpenBSD' => 'bacula-server',
            'FreeBSD' => 'bacula9-server'
          }[facts[:os]['family']]
        end

        it { is_expected.to compile.with_all_deps }

        it do
          expect(exported_resources).to contain_bacula__director__storage('foo.example.com').with(address: 'foo.example.com')
        end

        it { is_expected.to contain_package(sd_package).with(ensure: 'installed') }
      end

      context 'with all parameters set' do
        let(:params) do
          {
            password: sensitive('sd-secret'),
            address: 'address.example.com',
            storage: 'storage.example.com'
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          expect(exported_resources).to contain_bacula__director__storage('storage.example.com').with(address: 'address.example.com')
        end
      end
    end
  end
end
