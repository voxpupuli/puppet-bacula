Fragment { target => 'fragment', path => '/tmp/test' } 
fragment{
  'fragment-test-header': order => '00', content => "FRAGMENT-TEST-HEADER\n";
  'fragment-test-body': order => '01', source => 'puppet:///modules/fragment/body';
  'fragment-test-footer': order => '02', content => "FRAGMENT-TEST-FOOTER\n";
}
fragment::concat{'fragment':
  owner => 'root',
  group => 'root',
  mode => '0640',
  path => '/tmp/test',
}
