# A Bacula Runscript specification
type Bacula::Runscript = Struct[{
  runs_when         => Optional[Enum[
    'Before',
    'After',
    'Always',
    'AfterVSS',
    'Never',
  ]],
  fail_job_on_error => Optional[Bacula::Yesno],
  runs_on_success   => Optional[Bacula::Yesno],
  runs_on_failure   => Optional[Bacula::Yesno],
  runs_on_client    => Optional[Bacula::Yesno],
  command           => String,
}]
