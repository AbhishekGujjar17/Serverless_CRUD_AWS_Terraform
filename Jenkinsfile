pipeline {

    // parameters {
    //     booleanParam(name: 'autoApprove', defaultValue: true, description: 'Automatically run apply after generating plan?')
    // } 
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

   agent  any
    stages {
        stage('checkout') {
            steps {
                 script{
                        dir("terraform")
                        {
                            git "https://github.com/AbhishekGujjar17/Serverless_CRUD_AWS_Terraform.git"
                        }
                    }
                }
            }

        stage('Plan') {
            steps {
                sh 'pwd;cd terraform/ ; terraform init -input=false'
                sh "pwd;cd terraform/ ; terraform plan -out=tfplan -input=false"
                sh 'pwd;cd terraform/ ; terraform show -no-color tfplan > tfplan.txt'
            }
        }

         stage('Apply') {
            steps {
                sh "pwd;cd terraform/ ; terraform apply -input=false tfplan"
            }
        }
    //     stage('Approval') {
    //        when {
    //            not {
    //                equals expected: true, actual: params.autoApprove
    //            }
    //        }

    //        steps {
    //            script {
    //                 def plan = readFile 'terraform/tfplan.txt'
    //                 input message: "Do you want to apply the plan?",
    //                 parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
    //            }
    //        }
    //    }

    }

  }