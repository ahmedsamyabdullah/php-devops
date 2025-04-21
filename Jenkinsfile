pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-2"
        DOCKER_IMAGE = "php-devops"
        ECR_REPO = "646304591001.dkr.ecr.us-east-2.amazonaws.com/samy-ecr"
        SONARQUBE_SERVER = "SonarQube"
        VAULT_CREDENTIALS_ID = 'jenkins-policy-vault'
        VAULT_SECRET_PATH = 'aws_credentials'
    }

    stages {

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
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Configure VAULT & Push to ECR') {
            steps {
                withVault(
                    vaultSecrets: [[
                        path: "${VAULT_SECRET_PATH}",
                        secretValues: [
                            [envVar: 'AWS_ACCESS_KEY_ID', vaultKey: 'aws_access_key'],
                            [envVar: 'AWS_SECRET_ACCESS_KEY', vaultKey: 'aws_secret_key']
                        ]
                    ]],
                    
                ) {
                    sh '''
                    echo "Logging in to ECR..."
                    aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                    aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO
                    docker tag $DOCKER_IMAGE:latest $ECR_REPO:latest
                    docker push $ECR_REPO:latest
                    echo "Setting up kubeconfig..."
                    aws eks update-kubeconfig --region $AWS_REGION --name eks
                    echo "Deploying using Helm..."
                    helm upgrade --install php-devops ./helm \
                            --set image.repository=$ECR_REPO \
                            --set image.tag=latest
                    '''
                }
            }
        }


    }

    post {
        always {
            cleanWs()
        }
    }
}
