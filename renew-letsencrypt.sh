#!/bin/bash

LE_CERTS='/etc/letsencrypt/live'
LE_CONFIG_PATH='/etc/letsencrypt/config'
LE_BIN='/opt/letsencrypt/letsencrypt-auto'
WEB_SERVER='nginx'
EXP_LIMIT=15

for config in $(ls $LE_CONFIG_PATH/*.ini); do
   domain=$(basename "$config" .ini)
   DATE_NOW=$(date -d "now" +%s)
   EXP_DATE=$(date -d "`openssl x509 -in $LE_CERTS/$domain/cert.pem -text -noout | grep "Not After" | cut -c 25-`" +%s)
   EXP_DAYS=$(( (EXP_DATE - $DATE_NOW) / 86400 ))
   if (( $EXP_DAYS < $EXP_LIMIT )) ; then
	echo "The certificate for $domain is about to expire soon. Starting renewal..."
	$LE_BIN certonly --renew-by-default --config $config
	echo "Reloading $WEB_SERVER"
	/usr/sbin/service $WEB_SERVER reload
	echo "Renewal process finished for $domain"
   else
	echo "The certificate for $domain is up to date, no need for renewal ($EXP_DAYS days left for renewal)."
   fi
done
