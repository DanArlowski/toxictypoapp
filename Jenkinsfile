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
                    cd src/test
                    rm -f log/log.txt
                    touch log/log.txt
                    
                    docker build -t toxictest .
                    docker run -d --network=testnet --name server toxictypo

                    echo "testing e2e1"
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
                    echo 'deploy'
                }
                   
            }//steps
        }//deploy
    }//steps

}