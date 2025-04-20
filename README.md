# Project : php-devops
## BY : Ahmed Samy
***
## I Created Terraform dir that contain  files infrastructure :
1. variables.tf
  - Define variables that we using in terraform files resources.
  - This file not contain the default values.

2. terraform.tfvars
  - Contained Values of Variables that defines in variables.tf

3. provider.tf 
  - Define AWS provider.
  - Set profile (php-devops) that contains my aws_credentials
  - Define region = us-east-2

4. network.tf
  - VPC 
  - IGW
  - Security Group
  - Subnets (Public & Private)
  - EIP
  - NAT
  - Route Table
  - RT associate

5. iam-roles.tf
  - iam role for ec2
  - Role policies (S3,ECR,EKS,SSM for vault)
  - Roles for eks
  - Roles for worker node

6. ec2.tf
  - Three ec2 instances:
  - jenkins ec2
  - sonarqube ec2
  - vault ec2

7. eks.tf
  - EKS (Elastic K8S Service) control node on AWS 

8. worker.tf
  - Worker node on AWS to join to eks master.





* After finishing we run commands : 
- ```
    terraform init
  ```
<h5> To initialize provider & Backend </h5>

- ```
    terraform plan
  ```

- ```
    terraform apply
  ```
***
## Ansible dir that contains files :
  1. ansible.cfg
  2. instances
    - It is inventory file that contains informations for three ec2 instances (jenkins, sonarqube, vault).
    - It is a static inventory manually.
  3. jenkins.yaml
    - Ansible Playboot to install jenkins on ubuntu ec2.
  4. sonarqube.yaml
    - Ansible Playbook to install sonarqube on ubunt ec2.
  5. vault.yaml
    - Ansible Playbook to install hashicorp vault on ubunt ec2.
  6. jenkins-vault.yaml
       - What This Playbook Does:
          - Enables AppRole auth method in Vault.
          - Creates a policy for Jenkins to read secrets.
          - Creates an AppRole role for Jenkins.
          - Retrieves the Role ID and Secret ID.
  7. vault-vars.yaml
    - Encrypted file by ansible-vault.

* Then run commands:

- ```
  ansible-playbook -i ./instances jenkins.yaml
  ```

- ```
  ansible-playbook -i ./instances sonarqube.yaml
  ```

- ```
  ansible-playbook -i ./instances vault.yaml
  ```

- ```
  ansible-playbook -i ./instances jenkins-vault.yaml --ask-vault-pass
  ```

***
## CI/CD (jenkins + Github )
1. Trigger pipeline on GitHub push.
    - We will use the **GitHub plugin** for Jenkins to create a webhook and enable Jenkins to listen for push events from GitHub,Upon a push  event, the pipeline will be triggered to run the necessary build, tests, and deployment tasks.
    - Step 1: Install the GitHub Plugin in Jenkins.
    - Step 2: Configure Jenkins to Connect with GitHub.
    - Step 3: Set Up GitHub Webhook in GitHub repository.
