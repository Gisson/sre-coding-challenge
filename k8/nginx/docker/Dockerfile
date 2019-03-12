FROM nginx:1.14
ADD multivac.conf /etc/nginx/conf.d
ADD .htpasswd /etc/nginx/
ADD cacert.cert /etc/nginx/cacert.cert
ADD cacert.key /etc/nginx/cacert.key
RUN [ "rm", "-f", "/etc/nginx/conf.d/default.conf"]
