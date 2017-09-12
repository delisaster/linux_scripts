#!/bin/bash

# create a crontab with this script
# Example:
# 0 */3 * * *   /usr/bin/bash   /opt/scripts/check_cert.sh
# Will run check every 3 hours, and will send email if certificate is going to expire in 2 weeks time.

# CONFIG
CERT_PATH=/etc/grid-security/hostcert.pem
EMAIL=dsimonovic@ebi.ac.uk


exp_date=$(date -u --date="$(openssl x509 -in $CERT_PATH -noout -enddate | cut -d= -f 2)"|awk '{print $1, $2, $3, $5, $6}')
#test_date="Mon 6 Nov UTC 2017"
echo $exp_date
two_weeks_time=$(date -ud "+15 day"|awk '{print $1, $2, $3, $5, $6}')
echo $two_weeks_time

if [[ $exp_date == $two_weeks_time ]]
then
     echo "The certificate on "$HOSTNAME"is going to expire in two weeks!!"| mail -s "Certificate expiry warning for $HOSTNAME" $EMAIL
fi
