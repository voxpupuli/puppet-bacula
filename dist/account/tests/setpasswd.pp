user {'testuser':
  ensure => 'present',
  password => setpass('testuser')
}
