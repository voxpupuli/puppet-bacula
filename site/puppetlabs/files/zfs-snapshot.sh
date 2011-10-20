#! /usr/local/bin/bash

# Path to ZFS
ZFS=/sbin/zfs

# Parse arguments
TARGET=$1
SNAP=$2
COUNT=$3

# Display usage
usare () {
  scriptname=`/usr/bin/basename $0`
  echo "$scriptname: Rotate snapshots on a ZFS filesystem"
  echo
  echo "  Usage:"
  echo
  echo "  target:    ZFS file system to act on"
  echo "  snap_name: Base name for snapshots, to be followed by a '.' and"
  echo "             an integer indicating the relative age of the snapshot"
  echo "  count:     Number of snapshots in the snap_name.number format to"
  echo "             keep at one time.  Newest snapshot ends in '.0'."
  echo
  echo
  exit
}

# Basic argument checks:
if [ -z $COUNT ]; then
  usage
fi

if [ ! -z $4 ]; then
  usage
fi

max_snap=$(($COUNT -1))

# Clean oldest snapshot:
dest=$max_snap
while [ $dest -gt 0 ]; do
  src=$(($dest - 1))
  if [ -d /${TARGET}/.zfs/snapshot/${SNAP}.${src} ]; then
    $ZFS rename -r ${TARGET}@${SNAP}.${src} ${TARGET}@${SNAP}.${dest}
  fi
  dest=$(($dest - 1))
done

# Create new snapshot:
$ZFS snapshot -r ${TARGET}@${SNAP}.0

