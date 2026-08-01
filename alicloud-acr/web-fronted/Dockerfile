# build stage
FROM nginx:alpine

# copy static files
COPY index.html /usr/share/nginx/html/
COPY style.css /usr/share/nginx/html/

# copy nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

# start nginx
CMD ["nginx", "-g", "daemon off;"]