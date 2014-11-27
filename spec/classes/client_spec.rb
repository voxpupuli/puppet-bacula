require 'spec_helper' 

describe 'bacula::client' do
  let(:facts) {
    {
      :operatingsystem => 'Debian',
      :concat_basedir => '/dne'
    }
  }
  let(:params) { {:director => 'mydirector.lan'} }
  it { should contain_class('bacula::client') }
end

