# Copyright 2009 Larry Ludwig (larrylud@gmail.com)
#
# Licensed under the Apache License, Version 2.0 (the "License"); you 
# may not use this file except in compliance with the License. You 
# may obtain a copy of the License at 
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, 
# software distributed under the License is distributed on an "AS IS"
# BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express 
# or implied. See the License for the specific language governing 
# permissions and limitations under the License. 
#
# $Id$
#
define line::ensure ($file, $pattern, $line = '', $ensure = 'present') {
  case $ensure {
    default : { err ( "unknown ensure value ${ensure}" ) }
    present: {
      case $line {
        "" : { err ( "unknown pattern value ${line}" ) }
        default: {
          $pattern_no_slashes = slash_escape($pattern)
          $replacement_no_slashes = slash_escape($line)
          # insert at end if does not exist
          exec { "/bin/echo '${line}' >> '${file}'":
            unless => "/usr/bin/perl -ne 'BEGIN { \$ret = 1; } \$ret = 0 if /$pattern_no_slashes/ ; END { exit \$ret; }' '$file'",
          }
# if exists in bad form replace with correct one
# assume replacement_no_slashes need to be on it's own line without comments and match exactly
          exec { "/usr/bin/perl -pi -e 's/$pattern_no_slashes/$replacement_no_slashes/' '$file'":
            onlyif => "/usr/bin/perl -ne 'BEGIN { \$ret = 1; } \$ret = 0 if /$pattern_no_slashes/ && ! /^$replacement_no_slashes\$/ ; END { exit \$ret; }' '$file'",
          }
        }
      }
    }
    absent: {
      exec { "/usr/bin/perl -ni -e 'print unless /${pattern}/' '${file}'":
        onlyif => "/bin/grep -qPx '${pattern}' '${file}'"
      }
    }
  }
}
