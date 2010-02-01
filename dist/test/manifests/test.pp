#
# This tests rather or not dependencies effect the order of 
# function calls
#



#file{"/tmp/test":
#  content => template('test/test.erb'),
#}
include test
class test {
  three{'three':
  } 
  one{'one':
    require => Two['two']
  } 
  two{'two':
    before => Three['three']
  } 
}

define three() {
  fail('three')
}

define one() {
  fail('one') 
}

define two() {
  fail('two')
}
