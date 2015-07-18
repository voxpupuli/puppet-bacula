require 'spec_helper' 

describe 'bacula::director' do
  context 'when debian' do
    let(:facts) {
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Debian',
        :operatingsystemrelease => '7.0',
        :concat_basedir => '/dne'
      }
    }
    let(:params) { {:storage => 'mystorage.lan'} }
    it { should contain_class('bacula::director') }
  end

  context 'when openbsd' do
    let(:facts) {
      {
        :osfamily => 'OpenBSD',
        :operatingsystem => 'OpenBSD',
        :operatingsystemrelease => '5.6',
        :concat_basedir => '/dne'
      }
    }
    let(:params) { {:storage => 'mystorage.lan'} }
    it { should contain_class('bacula::director') }
  end
end
