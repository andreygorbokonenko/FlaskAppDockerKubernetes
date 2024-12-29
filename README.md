# Flask App with Docker and Kubernetes on Docker Desktop

This repository demonstrates how to build, containerize, and deploy a Flask web application using Docker and Kubernetes. The setup uses Docker Desktop with an integrated Kubernetes cluster to run the app in a local development environment. The project includes everything from creating a Docker image for the Flask app to deploying it with Kubernetes resources like `Deployment`, `Service`, and `ServiceAccount`.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Directory Structure](#directory-structure)
- [Setup Instructions](#setup-instructions)
  - [1. Build the Docker Image](#1-build-the-docker-image)
  - [2. Configure Kubernetes Cluster](#2-configure-kubernetes-cluster)
  - [3. Apply Kubernetes Resources](#3-apply-kubernetes-resources)
  - [4. Access the Flask Application](#4-access-the-flask-application)
  - [5. Troubleshooting](#5-troubleshooting)
  - [6. Clean Up Resources](#6-clean-up-resources)
- [Docker Desktop Configuration](#docker-desktop-configuration)
- [Conclusion](#conclusion)
- [License](#license)

## Prerequisites

- **Docker Desktop** with Kubernetes enabled. If you don't have Docker Desktop, [download it here](https://www.docker.com/products/docker-desktop).
- Basic knowledge of Docker, Flask, and Kubernetes.
- Familiarity with `kubectl` and Docker commands.
- Local Docker registry setup at `10.0.0.3:5000`.

## Directory Structure

```plaintext
.
├── app.py                # Flask application
├── cluster-role-binding.yaml  # Kubernetes RBAC configuration
├── deployment.yaml       # Kubernetes Deployment for Flask app
├── Dockerfile            # Dockerfile to build the Flask app container
├── requirements.txt      # Python dependencies for Flask
├── service.yaml          # Kubernetes Service to expose Flask app
└── service-account.yaml  # Kubernetes ServiceAccount configuration
```
# Setup Instructions

### 1. Build the Docker Image

To containerize the Flask app, follow the steps below:

1. **Clone the repository** to your local machine:

    ```bash
    git clone https://github.com/your-username/your-repository.git
    cd your-repository
    ```

2. **Build the Docker image** using the provided Dockerfile. The image will be tagged as `10.0.0.3:5000/my-app:latest` for use with your local Docker registry.

    ```bash
    docker build -t 10.0.0.3:5000/my-app:latest .
    ```

3. **Push the Docker image** to the local registry. Make sure your Docker Desktop is configured to use an insecure registry (`10.0.0.3:5000`). You can do this under **Settings > Docker Engine** in Docker Desktop.

    After the registry is set up, push the image using the following command:

    ```bash
    docker push 10.0.0.3:5000/my-app:latest
    ```

### 2. Configure Kubernetes Cluster

Ensure that Kubernetes is enabled in Docker Desktop:

1. Open Docker Desktop.
2. Navigate to **Settings > Kubernetes** and enable Kubernetes.
3. Wait for the Kubernetes cluster to initialize.

### 3. Apply Kubernetes Resources

Now, we need to deploy the Flask app to Kubernetes:

1. **Create the Service Account:**

    Apply the service account configuration:

    ```bash
    kubectl apply -f service-account.yaml
    ```

2. **Create the Cluster Role Binding:**

    Apply the RBAC configuration to bind the service account to the appropriate role:

    ```bash
    kubectl apply -f cluster-role-binding.yaml
    ```

3. **Deploy the Flask App:**

    Apply the deployment configuration to run the Flask app in Kubernetes:

    ```bash
    kubectl apply -f deployment.yaml
    ```

4. **Expose the Flask App with a Service:**

    Finally, expose the Flask app to external traffic:

    ```bash
    kubectl apply -f service.yaml
    ```

### 4. Access the Flask Application

Once the resources are applied, you can access your Flask app using the NodePort specified in `service.yaml`. For example, if the `nodePort` is set to `31000`, open a web browser and go to: `http://localhost:31000`

You should see the message `Hello, Docker!`.

### 5. Troubleshooting

If you encounter issues, use the following commands to troubleshoot:

1. **View the status of your pods:**

    ```bash
    kubectl get pods
    ```

2. **Check the logs of a specific pod:**

    ```bash
    kubectl logs <pod-name>
    ```

3. **List services to ensure the Flask app is exposed:**

    ```bash
    kubectl get services
    ```

### 6. Clean Up Resources

To delete the Kubernetes resources (deployment, service, and service account), run:

```bash
kubectl delete -f deployment.yaml
kubectl delete -f service.yaml
kubectl delete -f service-account.yaml
kubectl delete -f cluster-role-binding.yaml
```
## Docker Desktop Configuration

Ensure that Docker is configured with the local registry (`10.0.0.3:5000`). Add the following to your Docker configuration file (`/etc/docker/daemon.json` or Docker Desktop settings):

```json
{
  "builder": {
    "gc": {
      "defaultKeepStorage": "20GB",
      "enabled": true
    }
  },
  "experimental": false,
  "insecure-registries": [
    "10.0.0.3:5000"
  ]
}
```
## Conclusion

You have successfully built and deployed a Flask web application in a local Kubernetes cluster using Docker Desktop. This setup can be used for local development and testing, providing a simple but effective environment for working with Docker and Kubernetes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

