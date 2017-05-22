#!/bin/bash

/vault/vault auth $ONETIME_TOKEN

DJANGO_SECRET=$(/vault/vault read -field=value $VAULT_PATH/django_secret)
AUTH0_DOMAIN_VAULT=$(/vault/vault read -field=value $VAULT_PATH/auth0_domain)
AUTH0_CLIENT_ID_VAULT=$(/vault/vault read -field=value $VAULT_PATH/auth0_client_id)
AUTH0_SECRET_VAULT=$(/vault/vault read -field=value $VAULT_PATH/auth0_secret)
AUTH0_SUCCESS_URL_VAULT=$(/vault/vault read -field=value $VAULT_PATH/auth0_success_url)
AUTH0_LOGOUT_URL_VAULT=$(/vault/vault read -field=value $VAULT_PATH/auth0_logout_url)
COOKIE_DOMAIN=$(/vault/vault read -field=value $VAULT_PATH/cookie_domain)

export COOKIE_DOMAIN
export SECRET_KEY=$DJANGO_SECRET
export AUTH0_DOMAIN=$AUTH0_DOMAIN_VAULT
export AUTH0_CLIENT_ID=$AUTH0_CLIENT_ID_VAULT
export AUTH0_SECRET=$AUTH0_SECRET_VAULT
export AUTH0_SUCCESS_URL=$AUTH0_SUCCESS_URL_VAULT
export AUTH0_LOGOUT_URL=$AUTH0_LOGOUT_URL_VAULT

ACCOUNT_SERVER_URL=$(/vault/vault read -field=value $VAULT_PATH/authentication_login_url)
SCIREG_SERVER_URL=$(/vault/vault read -field=value $VAULT_PATH/register_user_url)
AUTHZ_BASE=$(/vault/vault read -field=value $VAULT_PATH/authorization_server_url)

export ACCOUNT_SERVER_URL
export SCIREG_SERVER_URL
export AUTHZ_BASE

SSL_KEY=$(/vault/vault read -field=value $VAULT_PATH/ssl_key)
SSL_CERT_CHAIN=$(/vault/vault read -field=value $VAULT_PATH/ssl_cert_chain)

echo $SSL_KEY | base64 -d >> /etc/nginx/ssl/server.key
echo $SSL_CERT_CHAIN | base64 -d >> /etc/nginx/ssl/server.crt

cd /hypatio/

python manage.py migrate
python manage.py loaddata dataprojects
python manage.py collectstatic --no-input

/etc/init.d/nginx restart

gunicorn hypatio.wsgi:application