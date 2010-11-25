class django {
  include apache::python
	package { "python-django": ensure => installed; }
} 

