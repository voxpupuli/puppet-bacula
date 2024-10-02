# frozen_string_literal: true

require 'spec_helper'

describe 'bacula::director::console' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      let(:pre_condition) { 'include bacula' }

      context 'with default parameters' do
        let(:title) { 'Monitoring' }

        let(:params) do
          {
            password: 'monitoring_password',
          }
        end

        it { is_expected.to contain_concat__fragment('bacula-director-console-Monitoring').with(content: <<~FRAGMENT) }
          Console {
              Name        = Monitoring
              Password    = "monitoring_password"
              CatalogACL  = *all*
              CommandACL  = list
          }
        FRAGMENT
      end

      context 'with all parameters set' do
        let(:title) { 'restricted-user' }

        let(:params) do
          {
            password: 'A different UntrustedUser',
            jobacl: 'Restricted Client Save',
            clientacl: 'restricted-client',
            storageacl: 'second-storage',
            scheduleacl: 'weekly-schedule',
            poolacl: 'backup-pool',
            filesetacl: "Restricted Client's FileSet",
            catalogacl: 'RestrictedCatalog',
            commandacl: %w[run restore],
            whereacl: '/',
          }
        end

        it { is_expected.to contain_concat__fragment('bacula-director-console-restricted-user').with(content: <<~FRAGMENT) }
          Console {
              Name        = restricted-user
              Password    = "A different UntrustedUser"
              JobACL      = Restricted Client Save
              ClientACL   = restricted-client
              StorageACL  = second-storage
              ScheduleACL = weekly-schedule
              PoolACL     = backup-pool
              FileSetACL  = Restricted Client's FileSet
              CatalogACL  = RestrictedCatalog
              CommandACL  = run, restore
              WhereACL = /
          }
        FRAGMENT
      end
    end
  end
end
