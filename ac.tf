variable "docker_username" {}
variable "docker_password" {}
variable "dns_name" {}
variable "java_image_name" {}
variable "python_image_name" {}
variable "java_tag" {}
variable "python_tag" {}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
    name = "microservices-rg"
    location = "West Europe"
}

resource "azurerm_container_group" "microservices" {
    name = "microservices-group"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    os_type = "Linux"
    ip_address_type = "Public"
    dns_name_label = var.dns_name

    image_registry_credential {
        server   = "index.docker.io"
        username = var.docker_username
        password = var.docker_password
    }

    container {
        name = "springboot"
        image = "${var.docker_username}/${var.java-image-name}:${var.java-tag}"
        cpu = "0.5"
        memory = "1.5"

        ports {
            port = 8080
            protocol = "TCP"
        }

        environment_variables = {
            FLASK_URL = "http://localhost:5000"
        }
    }

    container {
        name = "flask"
        image = "${var.docker_username}/${var.python-image-name}:${var.python-tag}"
        cpu = "0.5"
        memory = "1.5"

        ports {
            port = 5000
            protocol = "TCP"
        }
    }

    tags = {
        project = "microservices"
    }
}