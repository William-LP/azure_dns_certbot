FROM mcr.microsoft.com/azure-cli:latest
ENV KV_NAME=""
ENV AZ_APP_ID=""
ENV AZ_APP_SECRET=""
ENV AZ_TENANT_ID=""
ENV AZ_SUBSCRIPTION_ID=""
ENV DOMAIN=""
ENV EMAIL=""
ENV AZ_DNS_RG=""
RUN pip3 install certbot certbot-dns-azure envsubst
COPY policy.json.tpl azure.ini.tpl main.sh .