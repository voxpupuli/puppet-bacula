require 'spec_helper' 

describe 'bacula::client' do
  require 'hiera'
  let(:hiera_config) { 'hiera.yaml' }
  let(:facts) {
    {
      :operatingsystem => 'Debian',
      :concat_basedir => '/dne',
      :ipaddress => '10.0.0.1'
    }
  }
  it { should contain_class('bacula::client') }
end

