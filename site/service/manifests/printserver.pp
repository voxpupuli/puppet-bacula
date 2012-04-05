class service::printserver {

  exec { 'expand_xerox_phaser_8560mfp_ppd':
    command   => 'gunzip -c /Library/Printers/PPDs/Contents/Resources/Xerox\ Phaser\ 8560MFP.gz > Xerox_Phaser_8560MFP.ppd',
    logoutput => on_failure,
    cwd       => '/private/etc/cups/ppd',
    path      => [ '/bin', '/usr/bin' ],
    creates   => '/private/etc/cups/ppd/Xerox_Phaser_8560MFP.ppd',
  }

  file { '/private/etc/cups/ppd/Xerox_Phaser_8560MFP.ppd':
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => '_lp',
    require => Exec['expand_xerox_phaser_8560mfp_ppd']
  }

  printer { 'Xerox_Phaser_8560MFP':
    ensure      => present,
    uri         => 'socket://192.168.100.96/',
    description => 'Xerox Phaser 8560 Multi-function Printer that is available for use over Airprint',
    location    => 'Puppet Labs Suite 500',
    ppd         => '/private/etc/cups/ppd/Xerox_Phaser_8560MFP.ppd',
  }
}
