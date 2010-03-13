class puppetlabs::wordpress {
  require ::wordpress
#  wordpress::instance{
#
#  } 
}
  
