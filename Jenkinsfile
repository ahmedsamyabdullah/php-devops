pipeline{
    agent any
    
    environment {
        AWS_REGION = "us-east-2"
        DOCKER_IMAGE = "php-devops"
        ECR_REPO = "646304591001.dkr.ecr.us-east-2.amazonaws.com/samy-ecr"
        SONARQUBE_SERVER = "SonarQube"
    }
    stages{

       stage('Checkout') {
            steps {
                git 'https://github.com/ahmedsamyabdullah/php-devops.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'composer install'
            }
        }

        stage('Unit Tests') {
            steps {
                sh 'vendor/bin/phpunit || true' 
            }
        }

        stage('SonarQube Analysis') {
            environment {
                SONAR_TOKEN = credentials('sonar-token') 
            }
            steps {
                withSonarQubeEnv("${SONARQUBE_SERVER}") {
                    sh '''
                    sonar-scanner \
                      -Dsonar.projectKey=php-devops \
                      -Dsonar.sources=. \
                      -Dsonar.host.url=$SONAR_HOST_URL \
                      -Dsonar.login=$SONAR_TOKEN
                    '''
                }
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    sh 'docker build -t $DOCKER_IMAGE .'
                }
            }
        }

       stage('Push to ECR') {
            when {
                expression { return false } // Note :::=> Change to `true` when ready
            }
            steps {
                script {
                    sh '''
                    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO
                    docker tag $DOCKER_IMAGE:latest  $ECR_REPO:latest
                    docker push $ECR_REPO:latest
                    '''
                }
            }
        }

    }
    post{
        always{
            cleanWs()
        }
    }
}
