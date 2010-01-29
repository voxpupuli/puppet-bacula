Fragment { target => 'fragment-test', path => '/tmp/fragment-test' } 
fragment{
  'fragment-test-header': order => '00', content => 'FRAGMENT-TEST-HEADER';
  'fragment-test-body': order => '01', source => 'puppet:///modules/fragment/body';
  'fragment-test-footer': order => '02', content => 'FRAGMENT-TEST-FOOTER';
}
fragment::concat{'fragment-test':
  owner => 'root',
  group => 'root',
  mode => '0640',
  path => '/tmp/fragment-test',
}
