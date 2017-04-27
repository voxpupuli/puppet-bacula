require 'spec_helper'

describe 'bacula::client' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      it { is_expected.to contain_class('bacula::client') }

      context 'client with a custom address' do
        let(:params) do
          {
            address: 'bar.example.com'
          }
        end
        it { expect(exported_resources).to contain_bacula__director__client('foo.example.com').with(address: 'bar.example.com') }
      end
    end
  end
end
