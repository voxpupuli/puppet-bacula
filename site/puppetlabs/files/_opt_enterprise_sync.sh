#!/bin/bash

DIR="/opt/enterprise"

[[ -d $DIR ]] || (echo 'FUCK!'; exit 1)

inotifywait -mr --timefmt '%d/%m/%y %H:%M' --format '%T %w %f' \
-e close_write -e delete $DIR | while read date time dir file; do
  FILECHANGE=${dir}${file}
  rsync -a  /usr/bin/rsync -a /opt/enterprise/ tb-driver.puppetlabs.lan:/opt/enterprise/ && \
  logger $FILECHANGE synced
done

