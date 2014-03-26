FROM datt/datt-nginx:latest
MAINTAINER John Albietz "inthecloud247@gmail.com"

# overwrite existing nginx config.
ADD files/nginx.conf /etc/nginx/nginx.conf


RUN `# disable default nginx site`; \
     unlink /etc/nginx/sites-enabled/default;

# Setup sampleapp routing. the nginx way is to have all config files are in sites-available. and any enabled configs have symlinks in sites-enabled.
ADD files/sampleapp.conf /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/sampleapp.conf /etc/nginx/sites-enabled/sampleapp.conf

# Custom serf config
ADD files/serf-scripts/ /files/
