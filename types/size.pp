type Bacula::Size = Variant[
  Integer,
  Pattern[
    /(?i:\A\d+\s*[mg]b?\Z)/,
  ],
]
