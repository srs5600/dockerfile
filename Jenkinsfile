pipeline {
    agent any 	
	environment {
		PROJECT_ID = 'cr-lab-sshastri-1408204213'
                CLUSTER_NAME = 'cluster-1'
                LOCATION = 'us-central1-c'
                CREDENTIALS_ID = 'gcpk8creds'		
	}
	
    stages {	
	   stage('Checkout') {            
		steps {
                  checkout scm
		}	
           }

	   stage('Build Docker Image') { 
		steps {

                   script {
		      customImage = docker.build("sadanandrshastri/customtomcat:${env.BUILD_ID}","--no-cache")
                   }
                }
	   }
	   stage("Push Docker Image to Registry") {
                steps {
                   script {
                      docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
                      customImage.push("${env.BUILD_ID}")
                     }   
                   }
                }
            }
	   
           stage('Deploy to K8s on GCP') { 
                steps{
                   echo 'Deployment started ...'
		   sh 'ls -ltr'
		   sh 'pwd'
       echo env.PROJECT_ID
       echo env.CREDENTIALS_ID
       echo env.CLUSTER_NAME
       echo env.LOCATION

		   sh "sed -i 's/tagversion/${env.BUILD_ID}/g' deployment.yaml"
                   step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'deployment.yaml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])
                   //step([$class: 'KubernetesEngineBuilder', projectId: 'cr-lab-sshastri-1408204213', clusterName: 'cluster-1', location: 'us-central1-c' , manifestPattern: 'deployment.yaml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])
		   echo "Deployment Finished ..."
            }
	   }
    }
}
