# frozen_string_literal: true

require 'spec_helper'

describe 'bacula::director' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      expected_packages = []

      case facts[:osfamily]
      when 'Debian'
        it { is_expected.to contain_class('bacula::director') }

        case facts[:operatingsystemmajrelease]
        when '7', '8'
          expected_packages << 'bacula-director-common'
        when '9'
          expected_packages << 'bacula-director'
        end
        expected_packages << 'bacula-director-pgsql'
        expected_packages << 'bacula-console'
      when 'RedHat'
        case facts[:operatingsystemmajrelease]
        when '6'
          expected_packages << 'bacula-director-common'
          expected_packages << 'bacula-console'
          expected_packages << 'bacula-director'
        else
          expected_packages << 'bacula-director'
          expected_packages << 'bacula-console'
        end
      when 'OpenBSD'
        expected_packages << 'bacula-server'
        expected_packages << 'bacula-pgsql'
      when 'FreeBSD'
        expected_packages << 'bacula9-server'
      end

      expected_packages.each do |package|
        it { is_expected.to contain_package(package).with('ensure' => 'installed') }
      end
    end
  end
end
