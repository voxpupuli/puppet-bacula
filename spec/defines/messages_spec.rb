require 'spec_helper'

describe 'bacula::messages' do
  let(:title) { 'title' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts.merge(concat_basedir: '/dne') }

      context 'mail messages' do
        let(:params) do
          {
            mailcmd: '"/usr/sbin/bsmtp -h localhost -f \\"(Bacula) <bacula@example.com>\\" -s \\"Bacula: %t %e of %n %l\\" %r"',
            mail: 'all-backups@example.com = all, !skipped',
            mailonerrorcmd: '"/usr/sbin/bsmtp -h localhost -f \\"(Bacula) <bacula@example.com>\\" -s \\"BACULA ERROR: %t %e of %n %l\\" %r"',
            mailonerror: 'sysadmins@example.com = all',
            mailonsuccesscmd: '"/usr/sbin/bsmtp -h localhost -f \\"(Bacula) <bacula@example.com>\\" -s \\"Backup: %t %e of %n %l\\" %r"',
            mailonsuccess: 'customer@example.net = all'
          }
        end

        it { is_expected.to contain_concat__fragment('bacula-messages-dir-title').with(content: %r{Mail += all-backups@example.com = all, !skipped}) }
        it { is_expected.to contain_concat__fragment('bacula-messages-dir-title').with(content: %r{Mail On Error += sysadmins@example\.com = all}) }
        it { is_expected.to contain_concat__fragment('bacula-messages-dir-title').with(content: %r{Mail On Success += customer@example\.net = all}) }
        it { is_expected.to contain_concat__fragment('bacula-messages-dir-title').with(content: %r{Mail Command += "/usr/sbin/bsmtp -h localhost -f \\"\(Bacula\) <bacula@example\.com>\\" -s \\"Bacula: %t %e of %n %l\\" %r"}) }
        it { is_expected.to contain_concat__fragment('bacula-messages-dir-title').with(content: %r{Mail Command += "/usr/sbin/bsmtp -h localhost -f \\"\(Bacula\) <bacula@example\.com>\\" -s \\"BACULA ERROR: %t %e of %n %l\\" %r"}) }
        it { is_expected.to contain_concat__fragment('bacula-messages-dir-title').with(content: %r{Mail Command += "/usr/sbin/bsmtp -h localhost -f \\"\(Bacula\) <bacula@example\.com>\\" -s \\"Backup: %t %e of %n %l\\" %r"}) }
      end
    end
  end
end
