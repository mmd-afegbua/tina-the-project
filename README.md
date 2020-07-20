# Tina, The Project

### Brief Summary
##### How about a story?
The developer team in your organization is building an application that will be deployed on kubernetes, and you - Cloud/DevOps Engineer - are required to automate everything; from the moment the development team commits to their Source Code Management (SCM) platform (mostly GitHub or BitBucket), down to kubernetes cluster. To do this, you will need to:
- Test the application's sourcecode for errors
- Package the application as a Dockerfile and build an image
- Push the image to a docker registry (DockerHub)
- Deploy it into pods running on cluster nodes

But hold on, you work in an organization that practices DevOps methodologies, hence the development team will be releasing numerous builds in a day. However, to deploy the new build to production, you will need the CTO's approval. You also have sensitive users, so you don't want two versions of the same app to be on production environment at the same time. What is it going to be? When a new version is released, you will:

- Implemet Blue/Green Deployment approach
- Keep old version in Blue pods
- Deploy new version to Green pods
- Get the Approval of the CTO
- Direct service to Green pods

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
./create <stack-name> eks-cluster/eks-cluster.yaml eks-cluster/eks-cluster-params.json
```
Lastly, create the node group
```
./create <stack-name> eks-worknodes/eks-workers.yaml eks-network/eks-params.json
```
3. You will need a *Jenkins Server*
"A Jenkins server is easy to set up," you say to yourself. But you have to choose between visiting https://wiki.jenkins.io/display/JENKINS/Installing+Jenkins+on+Ubuntu or simpy running the script below:

```
cd .. && cd jenkins-server
./create <jenkins-name> jenkins-server/jenkins.yaml jenkins-server/jenkins-parameters.json
```
The Jenkins server will be needing a lot of dependencies, some of which might be outdated by the time you read this. So I removed the userData that will install Jenkins. You can install it using the link above. Also, you will need to install docker.io, kubectl, eksctl and tidy; or whatever testing binary you feel like using. Dont forget to edit the KeyName in the parameter file.And oh, add docker to the usergroup https://www.digitalocean.com/community/questions/how-to-fix-docker-got-permission-denied-while-trying-to-connect-to-the-docker-daemon-socket

### CI/CD Steps
1. You will have to Configure Jenkins and Jenkinsfile
- Plugins: BlueOcean, GitHub Authentication, Kubernetes Authentication. 
- Docker Credentials, withAWS Credentials.

Edit your Jenkinsfile in the root of the repository with the necessary details. That is `arn:aws:eks:us-west-2:321382273430:cluster/EKSCluster-9fVO5lycvYR4`, `tina-eks` and `tina-project` has to go. Except you decided to name your credentials as such The arn:aws thingy is your cluster arn (amazon resource name).

2. You will also need to connect your worker nodegroup to your eks cluster.
```
aws eks --region us-west-2 update-kubeconfig --name <Your-Cluster-Name>
kubectl config set-context <cluster-arn>

```
3. Configure the cluster and the nodes, and change the green/blue configuration by changing the NodeInstance role.
Change directory into k8s-deployment-config folder and run:
```
kubectl apply -f aws-auth.yaml
```
Well, you still have to change the green/blue configuration.

4. Connect your organization's SCM repository to Jenkins using BlueOcean

Nah! There is no way I am going to write about that. Look it up here: https://www.jenkins.io/doc/book/blueocean/creating-pipelines/

### Final Words
If you are among people that thinks that the processes highlighted above are simple and can be easily implemented, let me tell you that minor errors will probably, most likely, definitely frustrate you. But then you are a DevOps Engineer right? You Only Deploy Once (YOLO!).
