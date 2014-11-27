require 'spec_helper' 

describe 'bacula::director' do
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

