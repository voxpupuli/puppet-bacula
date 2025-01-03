# Temporary workarond to accept Sensitive and non-Sensitive passwords
type Bacula::Password = Variant[
  String[1],
  Sensitive[String[1]],
]
