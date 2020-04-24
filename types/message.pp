# A Bacula message specification
type Bacula::Message = Struct[{
  mname       => String,
  append      => Optional[String],
  catalog     => Optional[String],
  console     => Optional[String],
  daemon      => Optional[String],
  director    => Optional[String],
  mail        => Optional[String],
  mailcmd     => Optional[String],
  operator    => Optional[String],
  operatorcmd => Optional[String],
  syslog      => Optional[String],
}]
