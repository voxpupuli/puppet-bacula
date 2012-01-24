#!/usr/bin/env ruby
#

Okay     = 0
Warning  = 1
Critical = 2
Unknown  = 3

output = %x{zpool status -x}.chomp

# We currently don't know what what the other output looks like, so we should update here
if output == "all pools are healthy"
  puts "OK: #{output}"
  exit Okay
else
  puts "Critical: output not matched"
  exit Critical
end

