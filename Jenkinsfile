pipeline {
    agent {
        label 'Agent-expense'
    }
    options {
        timeout(time: 30, unit: 'MINUTES')
        disableConcurrentBuilds()
        ansiColor('xterm')
    }
    environment {
        startInfra = '10-vpc,50-acm,70-ecr'
        endInfra = '70-ecr,80-cdn,60-alb,30-bastion,40-eks'
        awsRegion = 'us-east-1'
        awsCreds = 'aws-creds'
    }
    parameters {
        choice(name: 'ACTION', choices: ['Create', 'Destroy'], description: 'Select action to create or destroy INFRA')
    }
    stages {
        stage("Create Infra") {
            when {
                expression { params.ACTION == 'Create' }
            }
            steps {
                script {
                    for (infra in startInfra.split(",")) {
                        build job: "${infra}", parameters: [string(name:'ACTION', value: 'Create')], wait: false
                    }
                }
            }
        }
        stage("Destroy Infra") {
            when {
                expression { params.ACTION == 'Destroy' }
            }
            steps {
                script {
                    for (infra in endInfra.split(",")) {
                        build job: "${infra}", parameters: [string(name:'ACTION', value: 'Destroy')], wait: false
                    }
                }
            }
        }
    }
    post {
        always {
            deleteDir()
        }
    }
}
