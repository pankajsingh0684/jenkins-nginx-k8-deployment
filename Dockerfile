# Use the official NGINX base image
FROM nginx:latest

# Set the working directory inside the container
WORKDIR /usr/share/nginx/html

# Remove the default NGINX HTML files
RUN rm -rf ./*

# Copy custom HTML file into the container
COPY index.html .

# Change NGINX default port from 80 to 85
RUN sed -i 's/listen       80;/listen       8191;/' /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 8191

# Start NGINX server
CMD ["nginx", "-g", "daemon off;"]
