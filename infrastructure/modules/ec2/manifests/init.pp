#
# this class sets up things for the ec2 provider of the machine type
#
#

class ec2 {
  # install Amazons ruby API
  package{'amazon-ec2':
    ensure   => installed,
    provider => 'gem',
  }
}
