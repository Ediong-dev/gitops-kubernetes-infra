# Use the lightweight alpine distribution of the stable Nginx web server layer
FROM nginx:alpine

# Inject a custom entry landing block text template to represent your engineering tag
# RUN echo "<h1>Edionsenyene Enterprise Cloud-Native Infrastructure Staging Success!</h1>" > /usr/share/nginx/html/index.html

# Expose web ingress port 80
EXPOSE 80
