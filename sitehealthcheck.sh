#!/bin/bash
if curl -Is "https://xxxxx.com" 2>&1 | grep -w "200\|301" ; then
    echo "xxxxxx.com is up"
else
#    echo "xxxxx.com is down"
    sleep 30s
    if curl -Is "https://xxxxxxxx.com" 2>&1 | grep -w "200\|301" ; then
    	echo "xxxxxxx is up"
    else
    	echo "Website is down.." | mail -s "[Error] website.com healthcheck" receiver@gmail.com -a "FROM:sitehealthcheck@xx.com"
        echo "Website is down.." | mail -s "[Error] website.com healthcheck" receiver@xxxx.com -a "FROM:sitehealthcheck@xxxxx.com"
    	systemctl restart nginx
    fi
fi
