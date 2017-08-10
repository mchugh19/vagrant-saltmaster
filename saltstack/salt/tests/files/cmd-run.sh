#!/bin/sh

#runner (orchestrate)
#JSON='[{"client":"runner","expr_form":"glob","fun":"state.orchestrate","mods":"orchestration.refresh-apache","pillar":{"target":"dyno2v8"},"tgt":"dynocache2*"}]'
JSON='{"client":"local","tgt":"*","expr_form":"glob","fun":"cmd.run","arg":"sleep 5; ls -la","kwarg":{}, "full_return": "True"}'
#JSON='{"client":"local","tgt":"*","expr_form":"glob","fun":"cmd.run","arg":"sleep 5; ls -la","kwarg":{}}'

RESPONSE=`curl -ik http://localhost:8000/login -H 'Content-Type: application/json' -d '{"eauth":"pam","password":"jenkins","username":"jenkins"}' 2>/dev/null`
TOKEN=$(echo $RESPONSE |
    sed -e 's/[{}]/''/g' | 
    awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' |
    grep token | cut -d: -f 2 | cut -d'"' -f 2 )
echo $TOKEN

RESPONSE=`curl -k http://localhost:8000/ -H 'Accept: application/json' -H "X-Auth-Token: $TOKEN" -H 'Content-Type: application/json' -d "$JSON" 2>/dev/null`
echo $RESPONSE
