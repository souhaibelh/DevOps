# DevOps
A DevOps-focused project demonstrating Dockerized microservices with CI/CD pipelines and Terraform deployment to Azure.  
Both the Flask (Python) and Spring Boot (Java) services are minimal — the project highlights **infrastructure automation and delivery workflows**.

## Table of Contents
- [About](#about)
- [Screenshot](#screenshot)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage / Examples](#usage--examples)
  - [Main Game View](#main-game-view)
  - [Verifiers](#verifiers)
  - [Notes Panel](#notes-panel)

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

- **Docker** [Download here](https://www.docker.com/)
- **Git**

### Installation
- Clone the project: ```git clone https://github.com/souhaibelh/DevOps.git```
- Open the project's root folder: ```cd DevOps```

### Local Development
- Make sure docker is running and run ```docker-compose up```
- Service networking:
    - Both **Spring service** and **Python service** run on the same Docker network, which enables internal communication between them
    - By default, only the Spring service is exposed on **port 8080**
    - If you also need to access the Flask service from your host machine, update **docker-compose.yml**, add the following to the Flask service:
        - ```ports:
                  - "localPort:5000"```


