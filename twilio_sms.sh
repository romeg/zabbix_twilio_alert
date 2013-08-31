#!/bin/bash
. .twilio_rc
TO=$1;
BODY=$2;
RESPONSE=$(curl -q -XPOST https://api.twilio.com/2010-04-01/Accounts/${SID}/SMS/Messages \
    -d "Body=${BODY}" \
    -d "To=%2B${TO}" \
    -d "From=%2B18327304226" \
    -u "${SID}:${AUTH}" )

SMS_SID=$(echo $RESPONSE | sed -e 's,.*<Sid>\([^<]*\)</Sid>.*,\1,g' )
SMS_STATUS=$(echo $RESPONSE | sed -e 's,.*<Status>\([^<]*\)</Status>.*,\1,g' )
if [ "x${SMS_STATUS}" != "xqueued" ]
then 
exit 1;
fi
for (( c=1; c<=12; c++ ))
do
RESPONSE_STATUS=$(curl -q -G https://api.twilio.com/2010-04-01/Accounts/${SID}/SMS/Messages/${SMS_SID} -u "${SID}:${AUTH}" )
STATUS=$(echo $RESPONSE_STATUS | sed -e 's,.*<Status>\([^<]*\)</Status>.*,\1,g')
if [ "x${STATUS}" == "xsent" ]
then
exit 0;
fi
sleep 5s;
done
exit 1;
