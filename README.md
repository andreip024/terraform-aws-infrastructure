
# Fault tolerant AWS infrastructure as code for docker applications using Terraform

<p align="center">
    <a href="https://github.com/andreip024/terraform-aws-infrastructure/commits/main">
    <img src="https://img.shields.io/github/last-commit/andreip024/terraform-aws-infrastructure?color=blue"
         alt="GitHub last commit">
	<a href="https://github.com/andreip024/terraform-aws-infrastructure/commits/main">
    <img alt="GitHub commit activity (branch)" src="https://img.shields.io/github/commit-activity/m/andreip024/terraform-aws-infrastructure/main?color=blue">
    <a href="https://github.com/andreip024/terraform-aws-infrastructure/issues">
    <img alt="GitHub issues" src="https://img.shields.io/github/issues-raw/andreip024/terraform-aws-infrastructure?color=blue">
	<a href="https://github.com/andreip024/terraform-aws-infrastructure/releases">
	<img alt="GitHub version" src="https://img.shields.io/github/v/release/andreip024/terraform-aws-infrastructure?color=blue">
    <a href="https://github.com/andreip024/terraform-aws-infrastructure/blob/main/LICENSE">
	<img alt="GitHub License" src="https://img.shields.io/github/license/andreip024/terraform-aws-infrastructure?color=blue">
</p>

---

<p align="center">
  <a href="#about">About</a> •
  <a href="#project-arhitecture">Project Arhitecture</a> •
  <a href="#prerequisites">Prerequisites</a> •
  <a href="#variables-file">Variables</a> •
  <a href="#deployment">Deployment</a> •
  <a href="#roadmap">Roadmap</a> •
  <a href="#changelog">Changelog</a> •
  <a href="#license">License</a> •
  <a href="#support">Support</a>
  
</p>

---

## About
Part of a cross-project with [CheckAWSip](https://github.com/andreip024/checkawsip)

This project aims to create a highly available and fault-tolerant infrastructure in AWS for a dockerized application using Terraform. The infrastructure includes multiple Availability Zones, Elastic Load Balancer, ECS Fargate, Auto Scaling Groups, and other necessary resources that provide high availability and fault tolerance.

One of the key features of this project is its high configurability. All the necessary variables, such as the application name, region, Docker repository, domain, and many more, are defined in a separate **variables.json** file, making it easy to update and maintain the application configuration.


## Project Arhitecture

![Project Arhitecture](https://images-0168749535.s3.eu-central-1.amazonaws.com/AWS_Project_Arhitecture.jpg)

## Prerequisites

- An AWS account with programatic access (Access Key and Private Key)
- A domain in AWS Route53
- Create an S3 bucket for terraform remote state. Needs to be in the same AWS Region as the deployment of infrastructure;
- A GitHub repo with dockerize application in it;
- Create a repository and copy this project there;
- Create an GitHub Access Token;
- Create 3 secretes in GitHub AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY and GH_ACCESS_TOKEN an populate them with your data;
- Populate the variables.json file with your values.
- Rename the **.github/workflows/build.yml_off** file to **/.github/workflows/build.yml**. This will enable the deployment of the infrastructure.


**Note:**
 - The project has attached a destory job **.github/workflows/destroy.yml_off**. This will destory everything created with the project.


## Variables file

| Variables name               |  Description                         |
|----------------|-------------------------------|
|project_name	|Name of the project           |
|region          |AWS Region where you want to deploy the infrastructure|
|vpc_cidr          |Set you VPC CIDR address|
|pipeline_buket          |The name of the S3 Bucket for Artifacts (no need to be created manually)|
|domain_name          |Domain name that you have registered in AWS Route 53 |
|ci_project_name          |Name of the GitHub project of the docker app|
|ci_project_user          |Name of the user under your docker project app|
|ci_project_url          |URL of the GitHub of your docker app|
|remote_state_key_infra          |Name of remote state file for infra - **DO NOT EDIT**|
|remote_state_key_elb          |Name of remote state file for elb - **DO NOT EDIT**|
|remote_state_key_ecs          |Name of remote state file for ecs - **DO NOT EDIT**|
|remote_state_key_code          |Name of remote state file for code - **DO NOT EDIT**|
|remote_state_bucket          |Name of the S3 bucket for Terraform remote states (check prerequisites)|
|logs_retentions_days          |Number of days for logs to be stored|
|limit_amount          |Buget limit amount|
|incremental_value          |Value of incremental alerting on budget|
|email_notification          |Email address for sending Budgets Alerts|
|min_capacity          |Minimum number of running Tasks in ECS|
|desired_capacity          |Desired number of running Tasks in ECS|
|max_capacity          |Maximum number of running Tasks in ECS|
|container_port          |Port that your app that is running in the docker|

## Deployment

For deployment, this projects uses GitHub Actions.

![Deployment Process](https://images-0168749535.s3.eu-central-1.amazonaws.com/infrastructure_deployment_process.jpg)

## Roadmap

- [X] Send containers logs to AWS CloudWatch;
- [X] Create budget and incremental alerts;
- [ ] Add a parameter for using a domain or not;
- [ ] Add remote state in DynamoDB;
- [ ] Restrict access to 443 port;
- [ ] Create a blue-green deployment using AWS CodeDeploy;
- [ ] Add tests in AWS CodePipeline;
- [ ] Add Cloudflare integration;
- [ ] Add AWS EFS volume for static shared content;
- [ ] Add RDS Database for users registration/login (Cross feature with [docker app](https://github.com/andreip024/checkawsip));
- [ ] Create a AWS ElastiCache to store the sesion (Cross feature with [docker app](https://github.com/andreip024/checkawsip));
- [ ] Create saves in AWS DynamoDB for stats (Cross feature with [docker app](https://github.com/andreip024/checkawsip));
- [ ] Add AWS SQS to create a queue for requests (Cross feature with [docker app](https://github.com/andreip024/checkawsip));
- [ ] Create Lamda functions thats send weekley stats;


## Changelog

v1.1.0 [18-Apr-2023]
- Create a CloudWach group
- Add ECS Tasks logs to CloudWach group created
- Add ClodeBuild logs to CloudWach group created
- Add budget and incremental alerting
- Update documentation

v1.0.0 [10-Apr-2023] - Release

## License

Distributed under the MIT License. See [LICENSE.md](https://github.com/andreip024/terraform-aws-infrastructure/blob/main/LICENSE.md) for more information.

## Support

This repository is maintained actively, so if you face any issue or you want to propose new features, pelase [open an issue](https://github.com/andreip024/terraform-aws-infrastructure/issues/new).



You can contact/find me also on:  
<a href="https://www.linkedin.com/in/andrei-p%C3%A2rv-53a91315a/" target="_blank">
<img alt="Linkedin" src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white">
<a href="mailto:andreiparv@gmail.com" target="_blank">
<img alt="Gmail" src="https://img.shields.io/badge/Gmail-D14836?style=for-the-badge&logo=gmail&logoColor=white">


---

Liked the work? Give the repository a star!