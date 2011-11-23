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
define gpg::agent ($ensure='present', $outfile = '', $options = []) {

  if $outfile == '' {
    $gpg_agent_info = "/home/${name}/.gpg-agent-info"
  }
  else {
    $gpg_agent_info = $outfile
  }

  $command = inline_template('<%= "gpg-agent --allow-preset-passphrase --write-env-file #{gpg_agent_info} --daemon #{options.join(\' \').gsub(/\s+/, \' \')}" %>')

  case $ensure { 
    present: {
      exec { "gpg-agent":
        user    => $name,
        path    => "/usr/bin:/bin:/usr/sbin:/sbin",
        command => $command,
        unless  => "ps -U ${name} -o args | grep -v grep | grep gpg-agent",
        logoutput => on_failure,
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
