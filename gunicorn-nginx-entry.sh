#!/bin/bash

/vault/vault auth $ONETIME_TOKEN

DJANGO_SECRET=$(/vault/vault read -field=value $VAULT_PATH/django_secret)
AUTH0_DOMAIN_VAULT=$(/vault/vault read -field=value $VAULT_PATH/auth0_domain)
AUTH0_CLIENT_ID_VAULT=$(/vault/vault read -field=value $VAULT_PATH/auth0_client_id)
AUTH0_SECRET_VAULT=$(/vault/vault read -field=value $VAULT_PATH/auth0_secret)
AUTH0_CALLBACK_URL_VAULT=$(/vault/vault read -field=value $VAULT_PATH/auth0_callback_url)
AUTH0_SUCCESS_URL_VAULT=$(/vault/vault read -field=value $VAULT_PATH/auth0_success_url)
AUTH0_LOGOUT_URL_VAULT=$(/vault/vault read -field=value $VAULT_PATH/auth0_logout_url)

export SECRET_KEY=$DJANGO_SECRET
export AUTH0_DOMAIN=$AUTH0_DOMAIN_VAULT
export AUTH0_CLIENT_ID=$AUTH0_CLIENT_ID_VAULT
export AUTH0_SECRET=$AUTH0_SECRET_VAULT
export AUTH0_CALLBACK_URL=$AUTH0_CALLBACK_URL_VAULT
export AUTH0_SUCCESS_URL=$AUTH0_SUCCESS_URL_VAULT
export AUTH0_LOGOUT_URL=$AUTH0_LOGOUT_URL_VAULT

cd /hypatio-app/hypatio-app/

python manage.py migrate
python manage.py collectstatic --no-input

/etc/init.d/nginx restart

gunicorn hypatio.wsgi:application