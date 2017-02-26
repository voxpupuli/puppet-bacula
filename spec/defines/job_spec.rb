require 'spec_helper'

describe 'bacula::job' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      let(:pre_condition) do
        'include bacula::client'
      end

      context 'A simple files job' do
        let(:title) { 'Etc' }
        let(:params) do
          {
            files: ['/etc']
          }
        end

        it { is_expected.to contain_bacula__job('Etc') }
        it do
          expect(exported_resources).to contain_bacula__director__job('Etc').with_content(
            %r{Job \{\n.*Name.*=.*Etc\n.*Type.*= Backup}
          )
        end

        it do
          expect(exported_resources).to contain_bacula__director__job('Etc').with_content(
            %r{FileSet.*=.*Etc}
          )
        end

        it do
          expect(exported_resources).to contain_bacula__director__fileset('Etc').with_files(
            ['/etc']
          )
        end
      end

      context 'with job_tag' do
        let(:title) { 'Etc' }
        let(:params) do
          {
            files: ['/etc'],
            job_tag: 'simple'
          }
        end

        it { is_expected.to contain_bacula__job('Etc') }
      end
    end
  end
end
