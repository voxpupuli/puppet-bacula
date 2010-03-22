class wordpress {
  include php::mysql
  include apache::php
  #realize(A2mod['rewrite'])
}
