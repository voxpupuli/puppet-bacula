require 'spec_helper'


describe 'bacula::storage' do
  let(:facts) {
    {
      :operatingsystem => 'Debian',
      :concat_basedir => '/dne'
    }
  }
  let(:params) { {:director => 'mydirector.lan'} }
  it { should contain_class('bacula::storage') }
end

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
