# frozen_string_literal: true

require 'spec_helper'

describe 'bacula::director' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      expected_packages = []

      case facts[:os]['family']
      when 'Debian'
        it { is_expected.to contain_class('bacula::director') }

        expected_packages << 'bacula-director'
        expected_packages << 'bacula-director-pgsql'
        expected_packages << 'bacula-console'
      when 'RedHat'
        expected_packages << 'bacula-director'
        expected_packages << 'bacula-console'
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
