#!/bin/sh

#runner (orchestrate)
#JSON='[{"client":"runner","expr_form":"glob","fun":"state.orchestrate","mods":"orchestration.refresh-apache","pillar":{"target":"dyno2v8"},"tgt":"dynocache2*"}]'
JSON='[{"client":"runner","fun":"state.orchestrate","mods":"orchestrate.pillar","pillar":{"key1":"somevalue", "key2":"othervalue"}}]'

RESPONSE=`curl -ik http://localhost:8000/login -H 'Content-Type: application/json' -d '[{"eauth":"pam","password":"jenkins","username":"jenkins"}]' 2>/dev/null`
TOKEN=`echo $RESPONSE | grep -oP "[[:alnum:]]{40}"  | uniq`

RESPONSE=`curl -k http://localhost:8000/ -H 'Accept: application/json' -H "X-Auth-Token: $TOKEN" -H 'Content-Type: application/json' -d "$JSON" 2>/dev/null`
echo $RESPONSE | tr '\n' ' ' | grep -q 'got somevalue and othervalue'
if [ $? -eq 0 ]; then
  echo $0 passed
else
  echo $0 failed
  exit 1
fi
