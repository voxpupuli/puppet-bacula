# A time indication
#
# @example
#   "12"
#   "12 hours 7 seconds"
#   "8d 2h 12m"
type Bacula::Time = Pattern[
  /^\d+$/,
  /^\d+\s+(s|sec|seconds?|mins?|minutes?|h|hours?|d|days?|w|weeks?|m|months?|q|quarters?|y|years?)(\s+\d+\s+(s|sec|seconds?|mins?|minutes?|h|hours?|d|days?|w|weeks?|m|months?|q|quarters?|y|years?))*$/, # lint:ignore:140chars
  # XXX: The above regular expression does not match _all_ valid time expressions.
  # It tries to match the most usual syntaxes.  The following expression matches _all_ valid time expressions.
  # /^\d+\s+(s(e(c(o(n(ds?)?)?)?)?)|mi(n(s|u(t(es?)?)?)?)|h(o(u(rs?)?)?)|d(a(ys?)?)|w(e(e(ks?)?)?)|m(o(n(t(hs?)?)?)?)|q(u(a(r(t(e(rs?)?)?)?)?)?)|y(e(a(rs?)?)?))(\s+\d+\s+(s(e(c(o(n(ds?)?)?)?)?)|mi(n(s|u(t(es?)?)?)?)|h(o(u(rs?)?)?)|d(a(ys?)?)|w(e(e(ks?)?)?)|m(o(n(t(hs?)?)?)?)|q(u(a(r(t(e(rs?)?)?)?)?)?)|y(e(a(rs?)?)?)))*$/ # lint:ignore:140chars
]
