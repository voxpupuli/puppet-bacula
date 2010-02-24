class linode::ruby {
  package{'linode':
    ensure   => installed,
    provider => 'gem', 
  } 
}
