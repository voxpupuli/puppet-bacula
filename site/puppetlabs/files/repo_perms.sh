#! /bin/bash
# This script will set permissions on the yum and apt repos 

dir="/opt/repository"
cd $dir || (echo "Oh, Fuck!"; exit 1)

perm_guid () {
  sub=$1
  group=$2
  find ${dir}/${sub} -type f -print0 | xargs -0 chmod 0664
  find ${dir}/${sub} -type d -print0 | xargs -0 chmod 2775
  chown -R root:$group ${dir}/${sub}
  wait
}

for x in `find {yum,apt}/* -maxdepth 0 -type d`; do
  echo "Setting permissions for: ${dir}/${x}/"
  current=`basename $x`
  case "$current" in
    prosvc|prosvc.unsigned)
      perm_guid $x prosvc;
      ;;
    enterprise)
      perm_guid $x enterprise;
      ;;
    *)
      perm_guid $x release;
      ;;
  esac
done

for x in `find * -maxdepth 0 -type f`; do
  chown root:release $x
  chmod 0664 $x
done

