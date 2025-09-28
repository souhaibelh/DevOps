# DevOps
A DevOps-focused project demonstrating Dockerized microservices with CI/CD pipelines and Terraform deployment to Azure.  
Both the Flask (Python) and Spring Boot (Java) services are minimal, the project highlights **infrastructure automation and delivery workflows**.

## Table of Contents
- [About](#about)
- [Screenshot](#screenshot)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Local Development](#local-development)
  - [Deployment](#deployment)
- [Usage](#usage)
- [CI/CD Workflow](#cicd-workflow)

## About
Multi-Service App is a containerized setup with two toy services (Spring Boot + Flask) that exist to demonstrate a **modern DevOps workflow**.  
The project emphasizes **CI/CD optimization, container orchestration, and infrastructure-as-code** rather than business logic.

## Features
- **Containerized Microservices**  
  - Lightweight Spring Boot and Flask apps running in Docker containers  
  - Unified network via Docker Compose  

- **Infrastructure as Code**  
  - Terraform provisions Azure Resource Group + Container Group  
  - Parameterized with `TF_VAR_*` environment variables  

- **Optimized CI/CD**  
  - GitLab pipeline builds only when relevant files change  
  - Caches Maven artifacts and Python dependencies to reduce build time  
  - Automatically pushes Docker images and applies Terraform changes  

- **Cloud Deployment**  
  - Azure Container Instances run both services in the same group  
  - Easy reproducibility via Terraform  

## Tech Stack
<p align="center">  
  <img src="https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white"/>  
  <img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white"/>  
  <img src="https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white"/>  
  <img src="https://img.shields.io/badge/Terraform-844FBA?style=for-the-badge&logo=terraform&logoColor=white"/>  
  <img src="https://img.shields.io/badge/GitLab%20CI%2FCD-FC6D26?style=for-the-badge&logo=gitlab&logoColor=white"/>  
</p>

## Getting Started

### Prerequisites
Make sure you have the following installed on your system:

#### General
- **Docker** [Download here](https://www.docker.com/)
- **Docker account**

#### Local Development
- **Git**

#### Deployment
- **Azure account**
- **Gitlab account**: Setup a gitlab runner or use a group runner and add these [variables](#deployment) in the project's settings -> ci/cd -> variables
- **Sonarqube**

### Installation
- Clone the project: ```git clone https://github.com/souhaibelh/DevOps.git```
- Open the project's root folder: ```cd DevOps```

### Local Development
- Make sure docker is running and run ```docker-compose up```
- Service networking:
    - Both **Spring service** and **Python service** run on the same Docker network, which enables internal communication between them
    - By default, only the Spring service is exposed on **port 8080**
    - If you also need to access the Flask service from your host machine, update **docker-compose.yml**, add the following to the Flask service, where localPort is the port on your host machine from which you wish to access the service:
        - ```ports: "localPort:5000"```

### Deployment
- To implement CI/CD the project must be pushed to **GitLab**, you will also need the following variables defined for it to work:
  - For **Azure**, using Service Principal:
    - AZURE_CLIENT_ID: Azure Service Principal's Application ID
    - AZURE_CLIENT_SECRET: Service Principal's client secret
    - AZURE_SUBSCRIPTION_ID: Azure subscription ID where resources will be managed
    - AZURE_TENANT_ID: Azure Active Directory tenant ID
    - DNS_NAME: Domain used to access the services, instead of IP, once terraform script is finished running head to Azure portal and check the domain of the container instance
  - For **Docker**:
    - DOCKER_PASSWORD: Your own docker password (deprecated, you should use a Personal Access Token)
    - DOCKER_TERRAFORM_PASSWORD: Your own docker password (deprecated, you should use a Personal Access Token), the reason this field exists is because I wanted to put my password in DOCKER_PASSWORD and a Personal Access Token in DOCKER_TERRAFORM_PASSWORD
    - DOCKER_USERNAME: Your docker username
    - JAVA_IMAGE_NAME: The name you want to give to your java image
    - PYTHON_IMAGE_NAME: The name you want ot give to your python image
  - For **Sonarqube**:
    - SONAR_TOKEN: Token used for code quality analysis in SonarQube (java service only)

### Usage
- Developer pushes a commit to the repo, CI/CD Pipeline will run
- Check if one of the services changed, if they did, run the build and test of the changed services only.
- Test with sonarqube (java service only)
- Build docker image of changed services using the DockerFiles defined in ./service-java and ./service-python
- Push images to the container Registry of docker
- Terraform apply, terraform uses the TF_VAR_java_tag and TF_VAR_python_tag variables defined in the pipeline to update the azurerm_container_group resource, tag changes only if the commit and push changed the source files of the respective service !
- Terraform instructs azure to destroy old container and start a new one with the new image:tag combo
