pipeline {
    agent any 	
	environment {
		PROJECT_ID = 'cr-lab-sshastri-1408204213'
                CLUSTER_NAME = 'cluster-1'
                LOCATION = 'eus-central1-c'
                CREDENTIALS_ID = 'kubernetes'		
	}
	
    stages {	
	   stage('Checkout') {            
		steps {
                  checkout scm
		}	
           }
           
	   stage('Build') { 
                steps {
                  echo 'Build a clean package...'
                  sh 'mvn clean package'
                }
           }
	    
	   stage('Test') { 
		steps {
	          echo 'Testing...'
		  sh 'mvn test'
		}
	   }
	   stage('Build Docker Image') { 
		steps {
		   sh 'whoami'
                   script {
		      customImage = docker.build("sadanandrshastri/customtomcat:${env.BUILD_ID}")
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
		   sh "sed -i 's/tagversion/${env.BUILD_ID}/g' deployment.yaml"
                   step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'deployment.yaml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])
		   echo "Deployment Finished ..."
            }
	   }
    }
}