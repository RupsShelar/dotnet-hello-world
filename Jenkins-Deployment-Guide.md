Jenkins Pipeline Setup and Deployment Guide

This document explains how to set up the Jenkins pipeline for building, pushing, and deploying a .NET Core application using Docker, with parameters for UAT and Production environments.

1. Jenkins Pipeline Overview

The pipeline automates the following steps:

Clone the Git repository containing the application.

Build a Docker image of the .NET Core application.

Login to Docker Hub using stored credentials.

Push the Docker image to Docker Hub.

Deploy the Docker container to the chosen environment (UAT or Production).

2. Jenkinsfile Parameters

The pipeline uses a choice parameter called ENV to select the environment:

UAT — Deploy to the UAT server.

PROD — Deploy to the Production server.

3. Required Credentials

Make sure you add the following credentials in Jenkins under Manage Jenkins → Credentials → Global:

Credential ID	Type	Value
dockerhub-user	Secret Text	Your Docker Hub username
dockerhub-pass	Secret Text	Your Docker Hub password or token
aws-access-key	Secret Text	AWS Access Key ID
aws-secret-key	Secret Text	AWS Secret Access Key
ec2-user	SSH Username/Key	Private key to connect to EC2 instances
4. Deploying to UAT or Production

When you run the pipeline, select the ENV parameter:

If you choose UAT, the pipeline will deploy the Docker container to the UAT server.

If you choose PROD, it will deploy to the Production server.

The pipeline automatically stops any running container with the same name, removes it, and starts a new one.

5. Notes

Make sure Docker and SSH are installed and running on both Jenkins and the target servers.

Ensure the Docker image tag (v1) matches in the Jenkinsfile and your Docker build command.

The .NET Core version in the Dockerfile must match your application’s target framework.
