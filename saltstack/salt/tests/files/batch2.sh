#!/bin/sh

port=8000

JSON='{"client":"local_batch","batch":"1","tgt":"*","expr_form":"glob","fun":"state.sls","arg":"tests.pillar-show"}'

RESPONSE=`curl -sik http://localhost:${port} -H 'Content-Type: application/json' 2>&1`
echo $RESPONSE


RESPONSE=`curl -ik http://localhost:${port}/login -H 'Content-Type: application/json' -d '{"eauth":"pam","password":"jenkins","username":"jenkins"}' 2>/dev/null`
TOKEN=$(echo $RESPONSE |
    sed -e 's/[{}]/''/g' | 
    sed -e 's/[{}]/''/g' | sed -e 's/"return"://g' |
    awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' |
    grep token | cut -d: -f 2 | cut -d'"' -f 2 )

RESPONSE=`curl -k http://localhost:${port}/ -H 'Accept: application/json' -H "X-Auth-Token: $TOKEN" -H 'Content-Type: application/json' -d "$JSON" 2>/dev/null`
echo $RESPONSE
