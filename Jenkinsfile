Jenkins-pipeline
pipeline {
    agent any 
    environment {
        PATH = "/opt/maven/bin:$PATH"
    }

    stages {
        stage('git checkout') {
            steps {
                echo "git repository clone..."
                git url: "https://github.com/KanhaiyaITGIT/Google-Project.git", branch: "main"
                echo "git cloned successfully"
            }
        }
        stage('code build') {
            steps {
                echo "Building code"
                sh "mvn clean package -Dmaven.test.skip=true"
                echo "code built successfully"
            }
        }
        stage('code test') {
            steps {
                echo "testing code"
                sh "mvn test"
                echo "code tested successfully"
            }
        }
        stage('test report generating') {
            steps {
                echo "report generating"
                sh "mvn surefire-report:report"
                echo "report generated"
            }
        }
        stage('sonarqube analysis') {
            environment {
                sonarHome = tool 'sonar-scanner-server'
            }
            steps {
                echo "SonarQube analysis starting.."
                withSonarQubeEnv('sonar-server') {
                    withCredentialsId([string(credentialsId: 'sonar-credentials', variable: 'SONAR_TOKEN')]) {
                        sh "${sonarHome}/bin/sonar-scanner -Dsonar.login=$SONAR_TOKEN"
                    }
                }
                echo "SonarQube analysis completed"
            }
        }
        stage('Quality-Gates') {
            steps {
                echo "Quality Gates checking"
                timeout(time: 4, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: false
                }
                echo "Quality Gates analysis completed"
            }
        }
        stage("Jar Publish") {
            steps {
                script {
                    echo '<--------------- Jar Publish Started --------------->'
                    def server = Artifactory.server('jfrog-server')
                    def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}"
                    def uploadSpec = """{
                        "files": [
                            {
                                "pattern": "target/*.war"
                                "target": "google-libs-release-local",
                                "flat": "false",
                                "props": "${properties}",
                                "exclusions": [ "*.sha1", "*.md5" ]
                            }
                        ]
                    }"""
                    def buildInfo = server.upload(uploadSpec)
                    buildInfo.env.collect()
                    server.publishBuildInfo(buildInfo)
                    echo '<--------------- Jar Publish Ended --------------->'
                }
            }
        }

    }

    post {
        success {
            echo "Pipeline successfully checked"
        }
        failure {
            echo "Pipeline failed, check the logs...."
        }
    }
}
