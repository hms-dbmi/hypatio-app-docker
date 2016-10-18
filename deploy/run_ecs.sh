ONETIME_TOKEN=$(vault token-create -policy="hypatio" -use-limit=9 -ttl="1m" -format="json" | jq -r .auth.client_token)

aws ecs run-task --cluster default --task-definition hypatio-app --overrides "{\"containerOverrides\":[{\"name\":\"hypatio-app\",\"environment\": [{\"name\":\"ONETIME_TOKEN\",\"value\": \"$ONETIME_TOKEN\"}]}]}"