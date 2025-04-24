# Stage 0, "build-stage", based on Node.js, to build and compile the frontend
FROM node:23.11.0-slim as build-stage
WORKDIR /app
COPY ./ingestion-cwa/ /app/
ADD wss.crt /etc/ssl/wss.crt
ENV NODE_EXTRA_CA_CERTS=/etc/ssl/wss.crt
RUN npm install
RUN npm run build
# Stage 1, based on Nginx, to have only the compiled app, ready for production with Nginx
FROM nginx:1.15
COPY --from=build-stage /app/build/ /usr/share/nginx/html
# Copy the default nginx.conf provided by tiangolo/node-frontend
COPY nginx.conf /etc/nginx/conf.d/default.conf