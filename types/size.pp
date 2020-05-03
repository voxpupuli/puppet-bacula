# A size indication
#
# @example
#   12
#   "7MB"
#   "3 GB"
type Bacula::Size = Variant[
  Integer,
  Pattern[
    /(?i:\A\d+\s*[mg]b?\Z)/,
  ],
]
