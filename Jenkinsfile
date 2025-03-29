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
        currInfra = '10-vpc,50-acm,70-ecr'
        nextInfra = ''
        prevInfra = ''
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
                    for (infra in currInfra.split(",")) {
                        build job: "${infra}", parameters: [string(name:'ACTION', value: 'Create')], wait: false
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
