# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'bacula' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<~PUPPET
        include bacula
        class { 'bacula::director':
          password => 'DirectorPassword',
        }
        class { 'bacula::client':
          password => 'ClientPassword',
        }
        class { 'bacula::storage':
          password => 'StoragePassword',
        }

        # puppet apply has no storeconfigs, so realize the exported resources locally
        Bacula::Director::Client <| |>
        Bacula::Director::Job <| |>
        Bacula::Director::Storage <| |>
      PUPPET
    end
  end

  describe file('/etc/bacula/bacula-fd.conf') do
    its(:content) { is_expected.to match %r{Password = "ClientPassword"} }
  end

  describe file('/etc/bacula/bacula-sd.conf') do
    its(:content) { is_expected.to match %r{Archive Device += /bacula} }
  end

  describe file('/bacula') do
    it { is_expected.to be_directory }
    it { is_expected.to be_owned_by 'bacula' }
  end

  describe package('bacula-director') do
    it { is_expected.to be_installed }
  end

  # The director's systemd unit is bacula-director on Debian and bacula-dir on RedHat
  dir_service = (fact('os.family') == 'Debian') ? 'bacula-director' : 'bacula-dir'
  [dir_service, 'bacula-fd', 'bacula-sd'].each do |svc|
    describe service(svc) do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end

  { 'dir' => 9101, 'fd' => 9102, 'sd' => 9103 }.each do |daemon, port|
    # Run as bacula: the catalog only allows the bacula user to connect over the local socket
    describe command("runuser -u bacula -- bacula-#{daemon} -t -c /etc/bacula/bacula-#{daemon}.conf") do
      its(:exit_status) { is_expected.to eq 0 }
    end

    describe port(port) do
      it { is_expected.to be_listening }
    end
  end

  describe command('echo "status dir" | bconsole -c /etc/bacula/bconsole.conf') do
    its(:exit_status) { is_expected.to eq 0 }
    its(:stdout) { is_expected.to match %r{Daemon started} }
  end
end
