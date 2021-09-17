# Docker Terraform
Docker example for Terraform. This terraform script deploys 2 docker containers:

## Frontend
* NGINX reverse proxy. Listens on port 8080, forwards requests to NodeJS app on the backend

## NodeApp
* NodeJS app listening on port 3000. Only accessible through NGINX front end

## Prerequisites
* `docker network create terraform-net` (or just swap out the network name under `networks_advanced` for something else)