# frozen_string_literal: true

require 'spec_helper'

describe 'bacula::director' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      case facts[:osfamily]
      when 'Debian'
        it { is_expected.to contain_class('bacula::director') }

        case facts[:operatingsystemmajrelease]
        when '7', '8'
          it { is_expected.to contain_package('bacula-director-common') }
        when '9'
          it { is_expected.to contain_package('bacula-director') }
        end
        it { is_expected.to contain_package('bacula-director-pgsql') }
        it { is_expected.to contain_package('bacula-console') }
      when 'RedHat'
        case facts[:operatingsystemmajrelease]
        when '6'
          it do
            is_expected.to contain_package('bacula-director-common').with(
              'ensure' => 'present'
            )
          end

          it { is_expected.to contain_package('bacula-console') }
          it { is_expected.not_to contain_package('bacula-director') }
        else
          it { is_expected.to contain_package('bacula-director') }
          it { is_expected.to contain_package('bacula-console') }
        end
      when 'OpenBSD'
        it { is_expected.to contain_package('bacula-server') }
        it { is_expected.to contain_package('bacula-pgsql') }
      when 'FreeBSD'
        it { is_expected.to contain_package('bacula9-server') }
      end
    end
  end
end
