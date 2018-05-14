type Bacula::Size = Variant[
  Integer,
  Pattern[
    /(?i:\A\d+[mg]b?\Z)/,
  ],
]
