pipeline {
	agent any
	stages {
		stage('Lint HTML') {
			steps {
				sh 'tidy -q -e *.html'
                echo "Linting Dockerfile"
			}
		}
		
		stage('Build Docker Image') {
			steps {
				withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'tina-project', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]){
					sh '''
						docker build -t mmdafegbua/tina-the-project .
					'''
				}
			}
		}

		stage('Push Image To Dockerhub') {
			steps {
				withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'tina-project', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]){
					sh '''
						docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
						docker push mmdafegbua/tina-the-project
					'''
				}
			}
		}

		stage('Remove Docker Image From Build Server') {
			steps {
				sh '''
				    docker rmi mmdafegbua/tina-the-project
				'''	
			}
		}

		stage('Set Current Kubectl Context') {
			steps {
				environment { 
					KUBECONFIG='~/.kube/config'
				}				
				withAWS(region:'us-west-2', credentials:'tina-eks') {
					sh '''
						kubectl config set-context arn:aws:eks:us-west-2:321382273430:cluster/EKSCluster-9fVO5lycvYR4
						kubectl apply -f k8s-deployment-config/aws-auth.yaml --kubeconfig=$KUBECONFIG
					'''
				}
			}
		}

		stage('Deploy to Blue') {
			steps {
				withAWS(region:'us-west-2', credentials:'tina-eks') {
					sh '''
						kubectl apply -f ./k8s-deployment-config/blue-controller.json
					'''
				}
			}
		}

		stage('Deploy To Green') {
			steps {
				withAWS(region:'us-west-2', credentials:'tina-eks') {
					sh '''
						kubectl apply -f ./k8s-deployment-config/green-controller.json
					'''
				}
			}
		}

		stage('Create Service and Redirect to Blue') {
			steps {
				withAWS(region:'us-west-2', credentials:'tina-eks') {
					sh '''
						kubectl apply -f ./k8s-deployment-config/blue-service.json
					'''
				}
			}
		}

		stage('CTO Approval') {
            steps {
                input "Ready to redirect traffic to green?"
            }
        }

		stage('Create Service and Redirect to Green') {
			steps {
				withAWS(region:'us-west-2', credentials:'tina-eks') {
					sh '''
						kubectl apply -f ./k8s-deployment-config/green-service.json
					'''
				}
			}
		}

	}
}