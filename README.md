Personal Flask App with Docker and Kubernetes on Docker Desktop

This repository demonstrates how to build a Dockerized Flask application, create a Kubernetes cluster on Docker Desktop, and deploy the application using Kubernetes resources like Deployment, Service, ServiceAccount, and more. It also includes configuration for accessing the app via a NodePort, and explains how to set up a local Docker registry for pushing and pulling images. The setup is fully contained within your local machine, making it ideal for local development and testing with Kubernetes.
Prerequisites

    Docker Desktop installed with Kubernetes enabled.
    A working knowledge of Docker, Flask, and Kubernetes.
    Basic understanding of kubectl and docker commands.
    A local Docker registry running (if pushing images to a custom registry).

Additional Requirements:

    Ensure that kubectl is installed and properly configured to communicate with the Kubernetes cluster in Docker Desktop.
    Make sure that Docker Desktop's Kubernetes is running and that you're connected to the correct context in your kubectl configuration.

Directory Structure

.
├── app.py
├── cluster-role-binding.yaml
├── deployment.yaml
├── Dockerfile
├── requirements.txt
├── service.yaml
└── service-account.yaml

File Overview

    app.py: The main Flask application that serves a simple "Hello, Docker!" message.
    cluster-role-binding.yaml: Kubernetes RBAC configuration to bind the service account to the cluster-admin role.
    deployment.yaml: Kubernetes Deployment resource to manage the app's lifecycle.
    Dockerfile: The Dockerfile used to build the Docker image for the Flask app.
    requirements.txt: Python dependencies for the Flask app.
    service.yaml: Kubernetes Service resource to expose the Flask app on a NodePort.
    service-account.yaml: Kubernetes ServiceAccount configuration for the app.

Step-by-Step Setup
1. Build the Docker Image

First, we need to build the Docker image for our Flask app. This is done using the Dockerfile provided.
Clone the repository:

git clone https://github.com/your-username/your-repository.git
cd your-repository

Build the Docker image:

docker build -t 10.0.0.3:5000/my-app:latest .

Push the Docker image to the local Docker registry:

Before you can push the image, ensure that the Docker registry is running on 10.0.0.3:5000. Docker Desktop automatically provides a registry if configured, or you can manually start a local registry with:

docker run -d -p 5000:5000 --name registry registry:2

Push the Docker image:

docker push 10.0.0.3:5000/my-app:latest

2. Configure Kubernetes Cluster on Docker Desktop

Ensure that Kubernetes is enabled on your Docker Desktop:

    Open Docker Desktop and go to Settings > Kubernetes.
    Enable Kubernetes and wait for the cluster to initialize.

Verify the Kubernetes cluster is running:

kubectl cluster-info

This should output the API server's URL, indicating that your cluster is running.
3. Apply Kubernetes Configurations

Next, we need to configure Kubernetes to deploy our Flask app.
Create the Service Account:

kubectl apply -f service-account.yaml

Create the Cluster Role Binding (to grant cluster-admin privileges):

kubectl apply -f cluster-role-binding.yaml

Deploy the Flask App:

kubectl apply -f deployment.yaml

Expose the Flask App with a Service:

kubectl apply -f service.yaml

4. Access the Flask Application

After the Kubernetes resources are created, you can access your Flask app via the NodePort specified in service.yaml.

If you used nodePort: 31000, open your browser and visit:

http://localhost:31000

You should see the message "Hello, Docker!" from your Flask app.
5. Troubleshooting and Debugging

If you encounter any issues, here are some common troubleshooting commands:
Check the status of your pods:

kubectl get pods

View logs for a specific pod:

kubectl logs <pod-name>

Check the services and their exposed ports:

kubectl get services

Check the deployment status:

kubectl describe deployment flask-app

Check the current Kubernetes context (ensure you're connected to the correct cluster):

kubectl config current-context

Common issues:

    ErrImagePull: If your pods are stuck in ErrImagePull, ensure that the Docker registry is running and accessible, and the image name is correct. If using a private registry, ensure that Kubernetes is correctly configured to access it (using imagePullSecrets if necessary).
    Pod is CrashLoopBackOff: Inspect pod logs and check for application errors (e.g., Flask application issues).

6. Clean Up Resources

To delete the Kubernetes resources (deployment, service, service account), run:

kubectl delete -f deployment.yaml
kubectl delete -f service.yaml
kubectl delete -f service-account.yaml
kubectl delete -f cluster-role-binding.yaml

Docker Desktop Configuration

Ensure that you have the following Docker configuration for the local registry (/etc/docker/daemon.json or Docker Desktop settings):

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

This configuration allows Docker to push and pull images from the local registry at 10.0.0.3:5000.
Kubernetes Proxy Token Setup (If Needed)

If you encounter issues with Kubernetes authentication via proxy tokens or service account tokens, ensure that the Kubernetes context is correctly configured. If necessary, generate a new service account and token:
Create a new service account (if the old token is invalid):

kubectl create -f service-account.yaml

Generate a new token:

kubectl create token new-service-account -n default

Set the new token for kubectl:

kubectl config set-credentials new-user --token=<new-token>
kubectl config set-context $(kubectl config current-context) --user=new-user

Advanced: Stateful Deployment and Persistent Storage

For more complex applications, you may need StatefulSets or Persistent Volumes for stateful applications. In these cases, modify the deployment.yaml to handle StatefulSets and configure persistent storage using PersistentVolume (PV) and PersistentVolumeClaim (PVC) for database storage, for example.
Conclusion

You’ve successfully built and deployed a Flask application within a Dockerized Kubernetes cluster using Docker Desktop. This setup provides a comprehensive local development environment for testing and experimentation with Docker and Kubernetes.
License

This project is licensed under the MIT License - see the LICENSE file for details.
