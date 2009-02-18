class git::server {
    # This isn't really quite right, since the daemon is started
    # using supervise, but I don't think we have a supervise provider yet,
    # and certainly not in 0.24.4, which is how this was run.
    package { git-daemon-run: ensure => installed }
    file { "/etc/sv/git-daemon/run": source => "puppet:///git/run", owner => 0, group => 0, mode => 755 }
    service { git-daemon: ensure => running, require => [File['/etc/sv/git-daemon/run'], Package[git-daemon-run]] }
}
