# Azure DNS Certbot

This docker image is a wrapper for the [certbot-dns-azure library](https://certbot-dns-azure.readthedocs.io/en/latest/index.html) with the extra effort of shipping the certificate directly into an azure keyvault.

## Why and how

This docker image allows you to dynamically register a certificate for a domain linked in your DNS zone and save it within a keyvault.

- Creating a CSR in the keyvault
- Retrieving the CSR
- Sending CSR to the CA
- Merging the certificate to keyvault

## Usage

You must have a service principal with `DNS Zone Contributor` on your DNS zone and `Create` certificate permissions in your keyvault's access policies.

```bash
git clone https://github.com/William-LP/azure_dns_certbot
cd https://github.com/William-LP/azure_dns_certbot
docker build . -t azure_dns_certbot
docker run \
    -e KV_NAME=<KEYVAULT NAME> \
    -e AZ_APP_ID=<APP ID> \
    -e AZ_APP_SECRET=<APP SECRET> \
    -e AZ_TENANT_ID=<AZ TENANT ID> \
    -e AZ_SUBSCRIPTION_ID=<AZ SUBSCRIPTION ID> \
    -e DOMAIN=<DOMAIN> \
    -e EMAIL=<EMAIL> \
    -e AZ_DNS_RG=<AZ DNS RG> \
    --rm -i -t azure_dns_certbot
```
