require 'spec_helper'

describe 'bacula::storage' do
  require 'hiera'
  let(:hiera_config) { 'hiera.yaml' }
  context 'Debian' do
    let(:facts) {
      {
        :operatingsystem => 'Debian',
        :concat_basedir => '/dne',
        :ipaddress => '10.0.0.1'
      }
    }
    it { should contain_class('bacula::storage') }
  end
  context 'RedHat' do
    let(:facts) {
      {
        :osfamily => 'RedHat',
        :operatingsystem => 'RedHat',
        :operatingsystemrelease => '7.0',
        :operatingsystemmajrelease => '7',
        :concat_basedir => '/dne',
        :ipaddress => '10.0.0.1'
      }
    }
    it { should contain_class('bacula::storage') }
    context 'New packages' do
      it { should contain_package('bacula-storage').with(
          'ensure' => 'present',
        )
      }
      it { should_not contain_package('bacula-storage-common') }
    end
    context 'Old packages' do
      let(:facts) do
        super().merge(
          {
            :operatingsystemrelease => '6.0',
            :operatingsystemmajrelease => '6',
          }
        )
      end
      it { should contain_package('bacula-storage-common').with(
          'ensure' => 'present',
        )
      }
      it { should_not contain_package('bacula-storage') }
    end
  end
end
