FROM nginx:1.17.6-alpine

ADD entrypoint.sh /entrypoint.sh
ADD nginx.conf /etc/nginx/nginx.conf

RUN set -ex && chmod +x /entrypoint.sh && \
  apk update && apk --no-cache add -f openssl curl && \
  curl https://get.acme.sh -o /tmp/get.acme.sh && chmod +x /tmp/get.acme.sh \
  && /tmp/get.acme.sh && ln -s /root/.acme.sh/acme.sh /usr/bin/acme.sh && rm -f /tmp/get.acme.sh

CMD [ "/bin/sh", "-c", "/entrypoint.sh" ]