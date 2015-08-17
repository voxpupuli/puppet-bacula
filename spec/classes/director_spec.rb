require 'spec_helper' 

describe 'bacula::director' do
  context 'Debian' do 
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
  context 'RedHat' do
    let(:facts) {
      {
        :osfamily => 'RedHat',
        :operatingsystem => 'RedHat',
        :operatingsystemrelease => '7.0',
        :operatingsystemmajrelease => '7',
        :concat_basedir => '/dne'
      }
    }
    let(:params) { {:storage => 'mystorage.lan'} }
    it { should contain_class('bacula::director') }
    context 'New packages' do
      it { should contain_package('bacula-director').with(
          'ensure' => 'present',
        )
      }
      it { should_not contain_package('bacula-director-common') }
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
      it { should contain_package('bacula-director-common').with(
          'ensure' => 'present',
        )
      }
      it { should_not contain_package('bacula-director') }
    end
  end
end
