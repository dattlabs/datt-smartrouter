FROM datt/datt-nginx:latest
MAINTAINER John Albietz <inthecloud247@gmail.com>

ADD files/ /files/

# overwrite existing nginx config.
RUN ln -fs /files/nginx.conf /etc/nginx/nginx.conf

RUN `# disable default nginx site`; \
     unlink /etc/nginx/sites-enabled/default;

# Setup sampleapp routing. the nginx way is to have all config files are in
# sites-available. and any enabled configs have symlinks in sites-enabled.
RUN ln -fs /files/smartrouter.conf /etc/nginx/sites-available/smartrouter.conf
RUN ln -fs /files/smartrouter.conf /etc/nginx/sites-enabled/smartrouter.conf
