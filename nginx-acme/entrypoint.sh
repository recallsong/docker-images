
#!/bin/sh
set -e;

if [ "$DOMAIN" ]; then
    if [ ! "$ACME_DOMAINS" ]; then
        ACME_DOMAINS="-d $DOMAIN"
    fi
    echo "domain: ${DOMAIN}"
    mkdir -p /etc/nginx/ssl;
    if [ -f "/root/.acme.sh/${DOMAIN}/${DOMAIN}.key" ]; then
        "/root/.acme.sh/acme.sh" --cron --home "/root/.acme.sh";
    else
        if [ "$ACME_CMD" ]; then
            eval $ACME_CMD;
        fi
    fi
    if [ -f "/root/.acme.sh/${DOMAIN}/${DOMAIN}.key" ]; then
        if [ ! -f "/etc/nginx/ssl/certificate.key" ]; then
            "/root/.acme.sh/acme.sh" ${ACME_DOMAINS} --installcert --keypath /etc/nginx/ssl/certificate.key --fullchainpath /etc/nginx/ssl/certificate.key.pem
        fi
        if [ ! -f "/etc/nginx/ssl/dhparam.pem" ]; then
            openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048;
        fi
        sed -i "s/\#ssl_certificate/ssl_certificate/" /etc/nginx/nginx.conf
        sed -i "s/\#ssl_dhparam/ssl_dhparam/" /etc/nginx/nginx.conf
    fi
fi

echo "starting nginx..."
nginx -g "daemon off;"