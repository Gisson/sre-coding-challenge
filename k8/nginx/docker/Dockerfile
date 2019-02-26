FROM nginx:1.14
ADD multivac.conf /etc/nginx/conf.d
ADD .htpasswd /etc/nginx/
RUN [ "rm", "-f", "/etc/nginx/conf.d/default.conf"]
