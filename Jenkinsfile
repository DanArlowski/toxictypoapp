pipeline{
    agent any
    tools{
        jdk "JAVA"
        maven "maven"
    }
    post{
        always{
            sh 'docker rm -f  server pytest '
        }
    }
    stages{
        stage('build'){
            steps{
                withMaven(
                maven: 'maven', mavenSettingsConfig: 'mavensetting') {
                    sh 'mvn  verify'
                }//maven
            }//steps
        
        }//build
        stage('test'){
            steps{ 
                    sh '''              
                    docker build -t toxictest .
                    docker run -d --network=testnet --name server toxictypo

                    echo "testing e2e"
                    docker run --name pytest --network=testnet -t toxictest 
                    '''
            }//steps
        }//test
        stage('deploy'){
            when{
                branch 'master'
            }//when
            steps{
                script{
                    docker.withRegistry('https://gcr.io', 'gcr:toxictypoapp') {
                        sh 'docker tag toxictypo gcr.io/toxictypoapp/toxictypo'
                        docker.image("gcr.io/toxictypoapp/toxictypo").push()
                    }
                }//script   
            }//steps
        }//deploy
    }//steps

}