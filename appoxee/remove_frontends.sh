#!/bin/bash

export AWS_DEFAULT_REGION=us-east-1

INSTANCE_IPS=`list_instances.rb --environment Production --group Frontend | jq -r '.[] | .private_ip_address'`" "`list_instances.rb --environment Production --group Frontend-Engage | jq -r '.[] | .private_ip_address'`
/root/zabbix/zabbix-gnomes/zhostfinder.py -A | grep -E 'ip-10-0-1[4|5]' | grep -v appoxee | sort > /root/zabbix/fe-zbx-hosts

for i in $(echo $INSTANCE_IPS | tr '.' '-'); do sed -i "/ip-$i/d" /root/zabbix/fe-zbx-hosts; done

for i in $(cat /root/zabbix/fe-zbx-hosts); do /root/zabbix/zabbix-gnomes/zhostdelete.py $i; done
rm -f /root/zabbix/fe-zbx-hosts
