#!/bin/sh

port=8000
IFS='
'

#runner (orchestrate)
#JSON='[{"client":"runner","expr_form":"glob","fun":"state.orchestrate","mods":"orchestration.refresh-apache","pillar":{"target":"dyno2v8"},"tgt":"dynocache2*"}]'
JSON='{"client":"local_async","tgt":"*","expr_form":"glob","fun":"cmd.run","arg":"sleep 5; ls -la","kwarg":{}}'

RESPONSE=`curl -sik http://localhost:${port} -H 'Content-Type: application/json' 2>&1`
echo $RESPONSE


RESPONSE=`curl -ik http://localhost:${port}/login -H 'Content-Type: application/json' -d '{"eauth":"pam","password":"jenkins","username":"jenkins"}' 2>/dev/null`
TOKEN=$(echo $RESPONSE |
    sed -e 's/[{}]/''/g' | 
    sed -e 's/[{}]/''/g' | sed -e 's/"return"://g' |
    awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' |
    grep token | cut -d: -f 2 | cut -d'"' -f 2 )

RESPONSE=`curl -k http://localhost:${port}/minions -H 'Accept: application/json' -H "X-Auth-Token: $TOKEN" -H 'Content-Type: application/json' -d "$JSON" 2>/dev/null`
echo $RESPONSE
echo ""
echo $RESPONSE |
    awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' |
    sed -e 's/[{}]/''/g' | sed -e 's/"return"://g' |
    grep jid | awk '{print $2}'
exit
JID=$(echo $RESPONSE |
    awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' |
    sed -e 's/[{}]/''/g' | sed -e 's/"return"://g' |
    grep jid | cut -d: -f 2 | cut -d'"' -f 2)

echo "got jid: $JID"

RESPONSE=`curl -k http://localhost:${port}/jobs/$JID -H 'Accept: application/json' -H "X-Auth-Token: $TOKEN" -H 'Content-Type: application/json' 2>/dev/null`
echo $RESPONSE

sleep 8
RESPONSE=`curl -k http://localhost:${port}/jobs/$JID -H 'Accept: application/json' -H "X-Auth-Token: $TOKEN" -H 'Content-Type: application/json' 2>/dev/null`
echo $RESPONSE
