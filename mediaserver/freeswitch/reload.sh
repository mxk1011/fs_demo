#! /bin/bash -e

# sync git overlay repo if existing
if [ -e /root/src/fs-custom/.git/config ]; then
  echo 'Performing a pull on existing clone'
  pushd "/root/src/fs-custom"
    git pull
  popd
fi

# sync/copy files
echo 'Copying files'
cp -Rvf /root/src/fs-custom/etc/* /etc/

# reload the xml
echo 'Reloading FreeSwitch XML'
fs_cli -x "reloadxml"

echo 'Done.'