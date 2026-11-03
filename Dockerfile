FROM nginx:alpine

COPY index.html admin.html config.js manifest.webmanifest /usr/share/nginx/html/
COPY data/ /usr/share/nginx/html/data/
COPY icons/ /usr/share/nginx/html/icons/
COPY images/ /usr/share/nginx/html/images/
COPY audio/ /usr/share/nginx/html/audio/

EXPOSE 80