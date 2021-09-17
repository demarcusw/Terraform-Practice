terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }
}

provider "docker" {}

// Build our node app. This will sit behind our NGINX reverse proxy
resource "docker_image" "node-app" {
    name = "node-app"
    build {
        path = "./node-src/"
        tag = ["node-app:latest"]
    }
}

// Our frontend. User will go through NGINX to get to our app
resource "docker_image" "nginx-frontend" {
  name         = "nginx-frontend"
  keep_locally = false
  build {
      path = "./nginx-proxy/"
      tag = ["nginx-frontend:latest"]
  }
}

resource "docker_container" "node-app" {
    name = "node-app"
    image = docker_image.node-app.latest
    must_run = true
    
    // This should only be accessible by reverse proxy. Bind to localhost only
    ports {
        internal = 3000
        ip = "127.0.0.1"
    }

    networks_advanced {
        name = "terraform-net"
        aliases = ["nodeapp"]
    }
}

resource "docker_container" "nginx" {
  image = docker_image.nginx-frontend.latest
  name  = "example-terraform-docker"
  
  ports {
    internal = 80
    external = 8080
  }

  networks_advanced {
        name = "terraform-net"
        aliases = ["frontend"]
    }
}
