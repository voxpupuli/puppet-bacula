# frozen_string_literal: true

require 'spec_helper'

describe 'bacula::storage::device' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      let(:pre_condition) { 'include bacula' }

      context 'with default parameters' do
        let(:title) { 'Foo' }

        let(:params) do
          {
            # FIXME: `include bacula` setup a default device which use the default device.
            # If we do not customize this, we end-up with a duplicate resource declaration.
            device: '/tank'
          }
        end

        it { is_expected.to contain_concat__fragment('bacula-storage-device-Foo').with(content: <<~FRAGMENT) }
          Device {
              Name           = Foo
              Media Type     = File
              Archive Device = /tank
              LabelMedia     = yes; # lets Bacula label unlabeled media
              Random Access  = yes;
              AutomaticMount = yes;
              RemovableMedia = no;
              AlwaysOpen     = no;
              Maximum Concurrent Jobs = 1
          }
        FRAGMENT

        it { is_expected.to contain_file('/tank').with(ensure: 'directory', owner: 'bacula', group: 'bacula', mode: '0770') }
      end

      context 'with all parameters set' do
        let(:title) { 'Bar' }

        let(:params) do
          {
            device_name: 'Baz',
            media_type: 'File',
            device: '/tank',
            label_media: false,
            random_access: false,
            automatic_mount: false,
            removable_media: true,
            always_open: true,
            maxconcurjobs: 7,
            # conf_dir: # FIXME: Should probably not be a parameter
            device_mode: '0700',
            device_owner: 'bob',
            director_name: 'unused', # FIXME: unused
            group: 'backup', # FIXME: Should probably be device_group
          }
        end

        it { is_expected.to contain_concat__fragment('bacula-storage-device-Bar').with(content: <<~FRAGMENT) }
          Device {
              Name           = Baz
              Media Type     = File
              Archive Device = /tank
              LabelMedia     = no; # lets Bacula label unlabeled media
              Random Access  = no;
              AutomaticMount = no;
              RemovableMedia = yes;
              AlwaysOpen     = yes;
              Maximum Concurrent Jobs = 7
          }
        FRAGMENT

        it { is_expected.to contain_file('/tank').with(ensure: 'directory', owner: 'bob', group: 'backup', mode: '0700') }
      end
    end
  end
end
