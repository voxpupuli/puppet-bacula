require 'spec_helper' 

describe 'bacula::client' do
  require 'hiera'
  let(:facts) {
    {
      :operatingsystem => 'Debian',
      :concat_basedir => '/dne'
    }
  }
  it { should contain_class('bacula::client') }
end

