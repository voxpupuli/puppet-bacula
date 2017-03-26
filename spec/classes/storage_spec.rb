require 'spec_helper'

describe 'bacula::storage' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

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
    end
  end
end
