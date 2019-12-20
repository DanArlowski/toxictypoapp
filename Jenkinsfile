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
                    docker run -v $PWD/log:/test/log --env TESTFILE=e2e --name pytest --network=testnet -t toxictest 

                    cd log
                    if [ $(grep -c "failures" log.txt) -eq "0" ] && [curl server:8080]; then
                        exit 0
                    fi
                    exit 1
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