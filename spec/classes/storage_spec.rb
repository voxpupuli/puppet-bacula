# frozen_string_literal: true

require 'spec_helper'

describe 'bacula::storage' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:node) { 'foo.example.com' }
      let(:facts) { facts }
      let(:params) do
        {
          storage: param_storage,
          address: param_address,
          password: sensitive('sd-secret')
        }
      end
      let(:param_storage) { :undef }
      let(:param_address) { :undef }

      let(:pre_condition) do
        <<~PP
          class { 'bacula::client':
            password => Sensitive('fd-secret'),
          }
        PP
      end

      it { is_expected.to contain_class('bacula::storage') }

      case facts[:os]['family']
      when 'Debian'
        it { is_expected.to contain_package('bacula-sd') }
      when 'RedHat'
        it do
          is_expected.to contain_package('bacula-storage').with(
            'ensure' => 'installed'
          )
        end
      when 'OpenBSD'
        it { is_expected.to contain_package('bacula-server') }
      when 'FreeBSD'
        it { is_expected.to contain_package('bacula9-server') }
      end

      context 'with default params' do
        it { expect(exported_resources).to contain_bacula__director__storage('foo.example.com').with(address: 'foo.example.com') }
      end

      context 'with a custom name' do
        let(:param_storage) { 'storage.example.com' }

        it { expect(exported_resources).to contain_bacula__director__storage('storage.example.com').with(address: 'foo.example.com') }
      end

      context 'with a custom address' do
        let(:param_address) { 'address.example.com' }

        it { expect(exported_resources).to contain_bacula__director__storage('foo.example.com').with(address: 'address.example.com') }

        context 'with a custom name' do
          let(:param_storage) { 'storage.example.com' }

          it { expect(exported_resources).to contain_bacula__director__storage('storage.example.com').with(address: 'address.example.com') }
        end
      end
    end
  end
end
