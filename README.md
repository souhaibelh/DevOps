# Multi-Service App (Java + Python)

This project contains two services — a *Java (SpringBoot)* service and a *Python (Flask)* service — that can run locally via Docker Compose or be deployed to Azure using Terraform.  

The project also includes a **GitLab CI/CD pipeline** that builds, tests, produces Docker images, and publishes both services only when relevant changes are detected.  

---

## Project Structure

```
.
├── terraform/
│ └── ac.tf
├── service-java/
│ ├── spring.Dockerfile
│ ├── spring-pipeline-optimized.Dockerfile
│ └── src/...
├── service-python/
│ ├── flask.Dockerfile
│ ├── app.py
│ └── requirements.txt
├── docker-compose.yml
└── .gitlab-ci.yml
```


---

## Local Development

Run the services locally with Docker Compose:

docker-compose up --build


* Creates a network for the services  
* Runs both Java and Python containers  
* Allows them to communicate with each other  

Access the service:

* Java: [http://localhost:8080/proxy](http://localhost:8080/proxy)  
* Python: [http://localhost:5000/api/message](http://localhost:5000/api/message)  

---

## Terraform Deployment (Azure)

The `terraform/` folder defines:

1. An **Azure Resource Group**  
2. An **Azure Container Group** with two containers (Java + Python)  

### Required Variables

Terraform accepts environment variables via the `TF_VAR_*` prefix.  

| Category   | Variables |
|------------|-----------|
| **Docker** | `TF_VAR_docker_username`, `TF_VAR_docker_password`, `TF_VAR_java_image`, `TF_VAR_java_tag`, `TF_VAR_python_image`, `TF_VAR_python_tag` |
| **Azure**  | `ARM_client_id`, `ARM_client_secret`, `ARM_subscription_id`, `ARM_tenant_id` |

---

## GitLab CI/CD

The pipeline (`.gitlab-ci.yml`) provides:

### Conditional Builds
* Java service builds **only when code in `service-java/` changes**  
* Python service builds **only when code in `service-python/` changes**  

### Build & Test
* Java uses Maven → produces a `target/` artifact  
* Python installs dependencies and runs tests  

### Optimized Docker Builds
* Java service in CI uses the **artifact** instead of pulling Maven again  
* Python service installs requirements from **cache** to speed up builds  

### Deployment
1. Pushes Docker images with tags  
2. Terraform deploys the updated images into the Azure Container Group  

---

## Workflow Overview

flowchart LR

    A[Developer Commit] --> B[GitLab CI/CD Pipeline]

    B --> C{Service Changed?}

    C -->|Java Changed| D[Build & Test Java Service]
    C -->|Python Changed| E[Build & Test Python Service]

    D --> F{Java Service Changed?}
    F -->|Yes| G[Rebuild Java Docker Image & Push to Registry]
    F -->|No| H[Skip Java Image Build]

    E --> I{Python Service Changed?}
    I -->|Yes| J[Rebuild Python Docker Image & Push to Registry]
    I -->|No| K[Skip Python Image Build]

    G --> L[(Container Registry)]
    J --> L

    L --> M[Terraform Apply]
    M --> N[Azure Resource Group]
    N --> O[Azure Container Group]
    O --> P[Java + Python Containers Running]