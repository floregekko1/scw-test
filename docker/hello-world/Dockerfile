FROM nginx:latest
ADD src/hello-world/index.html /usr/share/nginx/html/
RUN chmod +r /usr/share/nginx/html/index.html
CMD ["nginx","-g", "daemon off;"]