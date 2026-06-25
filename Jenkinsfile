pipeline {

    agent any

    options {
        timestamps()
        //ansiColor('xterm')
        skipStagesAfterUnstable()
        //timeout(time: 60, unit: 'MINUTES')
    }

    environment {
        GITLEAKS_IMAGE        = 'zricethezav/gitleaks:v8.28.0'
        SONARCLOUD_IMAGE      = 'sonarsource/sonar-scanner-cli:11.5'
        SEMGREP_IMAGE         = 'semgrep/semgrep:1.132.0'
        TRIVY_IMAGE           = 'aquasec/trivy:0.67.2'
        PLAYWRIGHT_IMAGE      = 'mcr.microsoft.com/playwright:v1.61.0-noble'
        //NODE_IMAGE            = 'node:22.19.0-alpine3.22'
        NODE_IMAGE            = 'chrrodri/node-deps:latest'
        AWS_IMAGE             = 'amazon/aws-cli:2.31.0'
        K8S_IMAGE             = 'bitnami/kubectl:latest'


        APP_NAME              = 'quiz-entrevistas'
        APP_VERSION           = "1.0.${env.BUILD_NUMBER}"

        SONAR_TOKEN           = credentials('sonarcloud-token')

        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION    = 'us-east-1'
        AWS_DIST_ID           = 'EY11WN9Y0SH7C'
        AWS_CLOUDFRONT_URL    = 'dr9700dq0dlpo.cloudfront.net'

    }

    stages {
/*         stage('BUILD') {
             stages {
                 stage('Package') {
                    agent {
                        docker {
                            image "${NODE_IMAGE}"
                            args '--entrypoint="" --user root'
                            reuseNode true
                        }
                    }
                    steps {
                        sh 'echo "Running Package Stage"'
                        sh '''
                            export REACT_APP_VERSION=${APP_VERSION}
                            npm run build                            
                        '''    
                    }
                    post {
                        success {
                            archiveArtifacts(
                                artifacts: 'build/**',
                                fingerprint: true
                            )
                        }
                    }
                } 
            }
        } */
        
         stage('DEPLOY') {
            stages {
                stage('Deploy to CloudFront') {
                    agent {
                        docker {
                            image "${AWS_IMAGE}"
                            args '--entrypoint=""'
                            reuseNode true
                        }
                    }
                    steps {
                        withCredentials([
                            string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                            string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                        ]) {
                            sh 'echo "Publish to Cloudfront"' 
                            sh '''
                                export AWS_DEFAULT_REGION=us-east-1

                                aws s3 sync index.html \
                                s3://chrrodri-$APP_NAME \
                                --delete

                                aws cloudfront create-invalidation \
                                    --distribution-id $AWS_DIST_ID \
                                    --paths "/*"

                                echo "Cloudfront URL: https://$AWS_CLOUDFRONT_URL"
                            '''
                        }
                    }
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