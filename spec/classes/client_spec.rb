# frozen_string_literal: true

require 'spec_helper'

describe 'bacula::client' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:node) { 'foo.example.com' }
      let(:facts) { facts }
      let(:params) do
        {
          client: param_client,
          address: param_address
        }
      end
      let(:param_client) { :undef }
      let(:param_address) { :undef }

      it { is_expected.to contain_class('bacula::client') }

      context 'with default params' do
        it { expect(exported_resources).to contain_bacula__director__client('foo.example.com').with(address: 'foo.example.com') }
      end

      context 'with a custom name' do
        let(:param_client) { 'name.example.com' }

        it { expect(exported_resources).to contain_bacula__director__client('name.example.com').with(address: 'foo.example.com') }
      end

      context 'with a custom address' do
        let(:param_address) { 'address.example.com' }

        it { expect(exported_resources).to contain_bacula__director__client('foo.example.com').with(address: 'address.example.com') }

        context 'with a custom name' do
          let(:param_client) { 'name.example.com' }

          it { expect(exported_resources).to contain_bacula__director__client('name.example.com').with(address: 'address.example.com') }
        end
      end
    end
  end
end
