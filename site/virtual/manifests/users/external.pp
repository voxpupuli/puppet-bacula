class virtual::users::external {

  @account::user {
    'dansupinski':
      comment => 'Dan Supinski',
      group   => contractors,
      groups  => ["www-dev"],
      key     => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAsJ1AN1iOfjhQTUF6wIMwckmPXgqEFDkEwMEOXUVOX/zyFxdXlBqspTgiQTCGLHsW11CIRVsFYEAqtAubH4JSPbYaOwKcpao4TLH6SXWZxbmwYrhg2Qil2lqINVEfff2xAM11EhsCdzGpB8a3uhKMTT5EfJcXge19LQDNAXA7drxywJVWwgtCYzW1L6uYWaY+skMwSTl125QnC+A/XYim024m29eBvIQU+dp1D9+PJaE9Nl/sZYX2yryY+t97HyCL4LBDHhq2CXT1jaJK+lZxObyiLMA6rybA021akvBTkblNvYmdelq/MRtUxEG2XswytWmRlg6YetLzuZ8tcZElQQ==',
      keytype => "ssh-rsa",
      expire  => "2011-10-01",
  }
  
  @account::user {
    'maxlynch':
      comment => 'Max Lynch',
      group   => contractors,
      groups  => ["www-dev"],
      key     => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA9FGaGvZoXdwPhtK/AGmYhlDf6tP2Oqwd2cRUi5ntpHgib7lonOIqq5swuBYhwL8Mxhe5hZrhqDoP7aZhHqKyIggkMrTXtq6RTSVSAMxXS9EjHfMSoy9wvNtFcr4ArTh3eqWRCAPIFRb+i7qmqTlPb0dqnDrjJF2NJteutkKLe31w3uQ0G+3mvHjkioj1HIVGeylypgEgp54yqF0CSqxL5yLzpPtJ8fdfdpfRSp/fiWgJS3r98u+6dMDE2iyuGn5HpPNsHbQJ/jmtPXX7uehCQcWusomBz4/3uS9Dp+FOA3MgLf6O2/HiOdV2erV0F3Tugdmx81xQEU2+J1hx9vjhxQ==',
      keytype => "ssh-rsa",
      expire  => "2011-10-01",
  }

  @account::user {
    'donaldseigler':
      comment => 'Donald Seigler',
      group   => contractors,
      groups  => ["www-dev"],
      expire  => "2011-10-01",
  }

}

