require 'spec_helper' 

describe 'bacula::client' do
  on_supported_os.each do |os, facts|
    let(:facts) { facts }
    context "on #{os}" do
      it { should contain_class('bacula::client') }
    end
  end
end

