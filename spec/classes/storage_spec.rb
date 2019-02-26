require 'spec_helper'

describe 'bacula::storage' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:node) { 'foo.example.com' }
      let(:facts) { facts }
      let(:params) do
        {
          storage: param_storage,
          address: param_address
        }
      end
      let(:param_storage) { :undef }
      let(:param_address) { :undef }

      it { is_expected.to contain_class('bacula::storage') }

      case facts[:osfamily]
      when 'Debian'
        it { is_expected.to contain_package('bacula-sd') }
        it { is_expected.to contain_package('bacula-sd-pgsql') }
      when 'RedHat'
        case facts[:operatingsystemmajrelease]
        when '6'
          it do
            is_expected.to contain_package('bacula-storage-common').with(
              'ensure' => 'present'
            )
          end
          it { is_expected.not_to contain_package('bacula-storage') }
        else
          it do
            is_expected.to contain_package('bacula-storage').with(
              'ensure' => 'present'
            )
          end
          it { is_expected.not_to contain_package('bacula-storage-common') }
        end
      when 'OpenBSD'
        it { is_expected.to contain_package('bacula-server') }
      when 'FreeBSD'
        it { is_expected.to contain_package('bacula-server') }
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
