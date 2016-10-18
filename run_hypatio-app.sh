ONETIME_TOKEN=$(vault token-create -policy="hypatio" -use-limit=8 -ttl="1m" -format="json" | jq -r .auth.client_token)

docker stop hypatio-app
docker rm hypatio-app

docker run -d --name hypatio-app -p 80:80 -e ONETIME_TOKEN=$ONETIME_TOKEN -e VAULT_ADDR=https://vault.aws.dbmi.hms.harvard.edu:443 -e VAULT_SKIP_VERIFY=1 -e VAULT_PATH=secret/dbmi/hypatio -i -t dbmi/hypatio-app 

#docker exec -i -t hypatio-app /bin/bash