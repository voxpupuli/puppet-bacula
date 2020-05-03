# A Boolean value
type Bacula::Yesno = Variant[
  Boolean,
  Enum[
    'yes',
    'no',
    'true',  # lint:ignore:quoted_booleans
    'false', # lint:ignore:quoted_booleans
  ],
]
