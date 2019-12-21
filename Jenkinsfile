def version
pipeline{
    agent any
    tools{
        jdk "JAVA"
        maven "maven"
    }
    post{
        always{
            sh ' docker rm -f  server pytest '
        }
    }
    stages{
        stage("init parameters"){
            steps{
                script{
                    version=GIT_COMMIT.substring(0,6)
                }//script
            }//steps
        }//init parameters

        stage('build'){
            steps{
                withMaven(
                maven: 'maven', mavenSettingsConfig: 'mavensetting') {
                    sh "mvn versions:set -DnewVersion=${version}"
                    sh 'mvn  verify '
                }//maven
            }//steps
        }//build

        stage('test'){
            steps{ 
                  dir {
                      sh '''  
                    cd src/test/            
                    docker build -t toxictest .
                    docker run -d --network=testnet --name server toxictypo

                    echo "testing e2e"
                    docker run --name pytest --network=testnet -t toxictest 
                    '''
                    }
            }//steps
        }//test

        stage('deploy'){
            when{
                branch 'master'
            }//when
            steps{
                script{
                        echo 'pushing Artifact to artifactory...'
                        withMaven(
                            maven: 'maven', mavenSettingsConfig: 'mavensetting') {
                                sh 'mvn deploy -Dmaven.install.skip=true'
                        }//maven

                        echo 'pushing to container registry...'
                        docker.withRegistry('https://gcr.io', 'gcr:toxictypoapp') {
                            sh "docker tag toxictypo gcr.io/toxictypoapp/toxictypo:${version}"
                            docker.image("gcr.io/toxictypoapp/toxictypo:"+version).push()
                    }
                }//script   
            }//steps
        }//deploy

    }//stages

}//pipeline