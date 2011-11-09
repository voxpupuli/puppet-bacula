# Ensures that a gpg-agent instance is running for a specific user
#
# == Parameters
#
#
# == Examples
#
# gpg::agent { "git":
#   ensure => present,
# }
#
define gpg::agent ($ensure='present', $outfile = '') {

  if $outfile {
    $info = $outfile
  }
  else {
    $info = "/home/${name}/.gpg-agent-info"
  }

  case $ensure { 
    present: {
      exec { "gpg-agent":
        user    => $name,
        path    => "/usr/bin:/bin:/usr/sbin:/sbin",
        command => "gpg-agent --write-env-file ${info} --daemon",
        unless  => "ps -U ${name} -o args | grep -v grep | grep gpg-agent",
      }
    }
    absent: {
      exec { "kill gpg-agent":
        user    => $name,
        path    => "/usr/bin:/bin:/usr/sbin:/sbin",
        command => "ps -U ${name} -eo pid,args | grep -v grep | grep gpg-agent | xargs kill",
        onlyif  => "ps -U ${name} -o args | grep -v grep | grep gpg-agent",
      }
    }
    default: {
      fail("Undefined ensure parameter \"${ensure}\" for gpg::agent")
    }
  }
}
