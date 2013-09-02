#!/bin/bash
SCRIPT_PATH="`dirname \"$0\"`"
. $SCRIPT_PATH/.twilio_rc
TO=$1;
SUBJECT=$2;
urlencode() {
    local l=${#1}
    for (( i = 0 ; i < l ; i++ )); do
        local c=${1:i:1}
        case "$c" in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            ' ') printf + ;;
            *) printf '%%%X' "'$c"
        esac
    done
}
FIX_SUBJECT=$(urlencode "${SUBJECT}")
RESPONSE=$(curl -XPOST https://api.twilio.com/2010-04-01/Accounts/${SID}/Calls \
    --data-urlencode "Url=${SERVER_URL}/twilio.php?subject=${FIX_SUBJECT}" \
    -d "To=%2B${TO}" \
    -d "From=%2B18327304226" \
    -u "${SID}:${AUTH}" )
CALL_SID=$(echo $RESPONSE | sed -e 's,.*<Sid>\([^<]*\)</Sid>.*,\1,g' )
CALL_STATUS=$(echo $RESPONSE | sed -e 's,.*<Status>\([^<]*\)</Status>.*,\1,g' )
if [ "x${CALL_STATUS}" != "xqueued" ]
then 
exit 1;
fi
for (( c=1; c<=12; c++ ))
do
RESPONSE_STATUS=$(curl -G https://api.twilio.com/2010-04-01/Accounts/${SID}/Calls/${CALL_SID} -u "${SID}:${AUTH}" )
STATUS=$(echo $RESPONSE_STATUS | sed -e 's,.*<Status>\([^<]*\)</Status>.*,\1,g')
if [ "x${STATUS}" == "xcompleted" ]
then
exit 0;
fi
sleep 5s;
done
exit 1;
