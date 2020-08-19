#!/bin/bash -e

# Re-configuration

# Default password
echo 'Updating default_password'
xmlstarlet ed -L -u \
  "/include/X-PRE-PROCESS[@data = 'default_password=1234']/@data" \
  -v "default_password=$DEFAULT_PASSWORD" \
    /etc/freeswitch/vars.xml

xmlstarlet ed -L -u \
  "/include/X-PRE-PROCESS[@data = 'api_url=http://localhost']/@data" \
  -v "api_url=$MAINAPI_URL" \
    /etc/freeswitch/vars.xml

# timerfd support
# https://wiki.freeswitch.org/wiki/Mod_timerfd
if [ "$SOFTTIMER_TIMERFD" = 'true' ]; then
  echo 'Enabling softtimer-timerfd'
  sed -i 's%<!-- <param name="enable-softtimer-timerfd" value="true"/> -->%<param name="enable-softtimer-timerfd" value="true"/>%g' /etc/freeswitch/autoload_configs/switch.conf.xml
fi

#sed -i 's%CPUSchedulingPolicy=rr%#CPUSchedulingPolicy=rr%g' /etc/systemd/system/freeswitch.service
#sed -i 's%CPUSchedulingPolicy=rr%#CPUSchedulingPolicy=rr%g' /lib/systemd/system/freeswitch.service

export EXTERNAL_IP_EXEC_SET="dig @resolver1.opendns.com ANY myip.opendns.com +short -4"
#export EXTERNAL_IP_EXEC_SET="curl -s http://instance-data/latest/meta-data/public-ipv4"



echo executing: "$@"
exec "$@"