
# Serverless CRUD with AWS and Terraform
![Untitled Diagram drawio](https://user-images.githubusercontent.com/70919722/221738912-f8775698-5618-4146-8dd9-1d2291becbec.png)

This repository contains all the information you will need to create serverless RestApi's with AWS.
I have divided this repository into 3 sections



## Sections

- Serverless CRUD with AWS.
- Serverless CRUD on AWS with Terraform.
- CI/CD pipeline for the Terraform code.


### 1 Serverless CRUD with AWS.

- Step 1: Create a DynamoDB table

First, create a DynamoDB table that will store the data for your REST API. You can do this by navigating to the DynamoDB console, clicking "Create table", and specifying a table name and primary key. For example, I have created a table name users-table-demo.

After successfull creation, should look like this:

![Screenshot 2023-02-28 003937](https://user-images.githubusercontent.com/70919722/221753411-c0b2928a-5763-4281-8a4b-edd5a8aaf471.png)


- Step 2: Create an IAM Role

Next, create an IAM role that will be used by your Lambda function to interact with the DynamoDB table. You can do this by navigating to the IAM console, clicking "Roles", and then "Create role". Select "AWS service" as the trusted entity, and then choose "Lambda" as the service that will use this role. Next, attach a policy that grants your Lambda function access to the DynamoDB table and CloudWatch Logs, so that your Lambda function logs can go to cloudwatch. You can create a custom policy or use an existing policy. For example, I have used CloudWatchFullAccess and DynamoDBFullAccess.

After successfull creation, should look like this:


![Screenshot 2023-02-28 004527-role](https://user-images.githubusercontent.com/70919722/221753489-b08a1259-a981-4cca-946b-9be26abfa6f0.png)

- Step 3: Create a Lambda function

Now, create a Lambda function that will serve as the backend for your REST API. You can do this by navigating to the Lambda console, clicking "Create function", and choosing "Author from scratch". Choose a name for your function, select the runtime you want to use (e.g., python3.8), and then choose the IAM role you created in the previous step. In the function code editor, write the code that will interact with the DynamoDB table.


```All the lambda code is provided in this repo in function folder.```

- Step 4: Create an API Gateway API

Next, create an API Gateway API that will expose your Lambda function as a REST API. You can do this by navigating to the API Gateway console, clicking "Create API", and then choosing "REST API". Select "New API", choose a name for your API, and then create a resource and method that will invoke your Lambda function. For example, you can create a resource called "/users" and a method called "GET" that will retrieve items from your DynamoDB table.


![Screenshot 2023-02-28 004851-api](https://user-images.githubusercontent.com/70919722/221753573-f1aeba77-a2cf-4b88-b979-b52750400a91.png) 

- Step 5: Deploy your API

Finally, deploy your API by navigating to the API Gateway console, selecting your API, and then clicking "Actions" and "Deploy API". Choose a deployment stage (e.g., "prod") and then click "Deploy". Your API is now live and accessible via its endpoint URL.

![Screenshot 2023-02-28 005027-deploy](https://user-images.githubusercontent.com/70919722/221753664-7b80a7e7-4c22-44e9-91b9-3977e0b081ed.png)

### 2 Serverless CRUD on AWS with Terraform.

Whatever, we have done above to create a RestApi in AWS can be built using Terraform. 

```Terraform is an open-source infrastructure as code (IaC) tool that allows you to define and manage your infrastructure as code using a high-level configuration language. With Terraform, you can define your infrastructure in a declarative way, which means you describe what you want your infrastructure to look like, and Terraform will figure out how to create and manage it.```

```You can find all the terraform code in this repo.```

#### Run Locally

Initialize the terraform code, it will allow terraform to download the required providers:

```
terraform init
```

In order to see what resources, will terraform create in your AWS account:

```
terraform plan
```

After viewing the plan, to create all the resources in your AWS account:

```
terraform apply
```

### 3 CI/CD pipeline for the Terraform code with Jenkins.
#### What is a CI/CD pipeline?

CI/CD, which stands for Continuous Integration and Continuous Deployment/Delivery, is a set of software development practices that aims to increase the speed and efficiency of software delivery by automating the process of building, testing, and deploying code changes.

#### Why do we need a CI/CD?

In this tutorial, if you're utilizing Terraform to build AWS resources, it's likely that you want your code to reside in GitHub. However, accomplishing this requires deploying the resources in AWS using Terraform commands, and then separately pushing the Terraform code to GitHub using Git commands.

Fortunately, it's possible to streamline this process with the power of CI/CD. By creating a Jenkins pipeline, you can trigger a build as soon as code is pushed to GitHub. Jenkins will then run the Terraform commands for you, and upon successful completion of the build, all of your resources will be created in AWS. With a single push, you can create resources in both GitHub and AWS.

#### How to create CI/CD with jenkins for terraform code?

- Deploy an EC2 instance (Ubuntu) on AWS.
- Follow this link to install jenkins on your ubuntu server. https://www.trainwithshubham.com/blog/install-jenkins-on-aws
- Open port 8080 on your EC2 instance, that is where jenkins will open.
- Generate secret access key and access key id of your iam user in AWS and go to jenkins->configure->manage credentials. Create two new variables there and paste them there.
- Now , navigate to jenkins->create new item -> pipeline.
- ``You can find the jenkins pipeline code in this repo.``
- Select, SCM as git and paste the code provided.

This will create a built for your github code.

```In order to make it continuous, such that when you push to github and it build automatically you need to use WebHooks.```

- Go to the setting of your repo and in lefthand corner there is an opention of Webhooks.
- Select it, and in payload url paste this http://EC2PUBLICIP:8080/github-webhook/ , where EC2PUBLICIP is the public ip of your EC2 instance.
- In the secret field, you need to paste your jenkins secret, in order to create jenkins secret go to jenkins->click on your profile->create secret.

```Jenkins part can be tricky, if you have never used it before, i would recommend learning basics jenkins before implementing this.```



## Questions?

For any query email me at agujjar@mun.ca



