class django {

  include apache::mod::python
  package { "python-django": ensure => installed; }

}

