#!/usr/bin/env bash

# Loading environment variables into files
envsubst < azure.ini.tpl > azure.ini
envsubst < policy.json.tpl > policy.json
chmod 600 azure.ini

# Login to Azure
az login \
    --service-principal \
    -u $AZ_APP_ID \
    -p $AZ_APP_SECRET \
    --tenant $AZ_TENANT_ID \
    --allow-no-subscriptions

# Creating CSR in keyvault
az rest \
    --method post \
    --url "https://$KV_NAME.vault.azure.net/certificates/cert/create?api-version=7.1" \
    --body @policy.json \
    --resource "https://vault.azure.net"

# Retrieving CSR
bash -c     'echo "-----BEGIN CERTIFICATE REQUEST-----" && az keyvault certificate pending show --vault-name $KV_NAME --name cert --query csr -o tsv && echo "-----END CERTIFICATE REQUEST-----"' > cert.csr

# Sending CSR to CA
certbot certonly \
    --authenticator dns-azure \
    --preferred-challenges dns \
    --noninteractive \
    --agree-tos \
    --dns-azure-config azure.ini \
    -d $DOMAIN \
    --email $EMAIL \
    --csr cert.csr

# Merging the certificate to keyvault
az keyvault certificate pending merge \
    --name cert \
    --vault-name $KV_NAME \
    --file 0001_chain.pem

rm azure.ini policy.json cert.csr *.pem
