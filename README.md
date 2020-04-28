# Tina, The Project
### Capstone Project for Udacity Cloud DevOps Nanodegree, April 2020

### Brief Summary
##### How about a story?
The developer team in your organization is building an application that will be deployed on kubernetes, and you - Cloud/DevOps Engineer - are required to automate everything; from the moment the development team commits to their Source Code Management platform (mostly GitHub or BitBucket), down to kubernetes cluster. To do this, you will need to:
- Test the application's sourcecode for errors
- Package the application as a Dockerfile and build an image
- Push the image to a docker registry (DockerHub)
- Deploy it into pods running on cluster nodes

But hold on, you work in an organization that practices DevOps methodologies, hence the development team will be releasing numerous builds in a day. However, to deploy the new build to production, you will need the CTO's approval. You also have sensitive users, so you don't want two versions of the same app to be on production environment at the same time. What is it going to be?
- Implemet Blue/Green Deployment approach
- Get the Approval of the CTO

### Requirements
Yeah! All the steps above are quite fun. But before you can achieve them, you will need to carry out a one time architecting task:
1. AWS Billing Account and awscli user profile
The awscli profile will be needing the following permission:
- Programatic Access
- EKSAdmin: You will need to create a policy for this
- AmazonEC2FullAccess
- IAMFullAccess
- ssm:Get-Credentials
- AWSCloudFormationFullAccess

2. You will need a Cloud Infrastructure - on AWS
- VPC network, InternetGateway, Public and Private Networks, Elastic IPs and Security Groups
- Kubernetes Cluster
- Kubernetes worker nodes.

In this project, AWS CloudFormation is used to provision all the resources above. Do so by running the following commands:

First, you create the network infrastructure
```
cd aws-infra
./create <stack-name> eks-network/eks-network.yaml eks-network/eks-network-params.json
```
Next, you create the EKS cluster
```
cd aws-infra
./create <stack-name> eks-cluster/eks-cluster.yaml eks-cluster/eks-cluster-params.json
```
Lastly, create the node group
```
cd aws-infra
./create <stack-name> eks-worknodes/eks-workers.yaml eks-network/eks-params.json
```