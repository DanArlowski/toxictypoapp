pipeline{
    agent any
    tools{
        jdk "JDK8"
        maven "maven"
    }
stages{
    stage('build'){
        steps{
            withMaven(
            maven: 'maven', mavenSettingsConfig: 'mavensetting') {
                sh 'mvn verify'
            }
        }
       
    }
    stage('test'){
        steps{ 
                sh '''
                cd src/test
                rm -f log/log.txt
                touch log/log.txt
                
                docker build -t toxictest .
                docker run -d --network=testnet --name server toxictypo
                    ''' 
            parallel{
                a:{
                    sh '''
                    echo "testing e2e1"
                    docker run -v $PWD/log:/test/log --env TESTFILE=e2e1 --name pytest1 --network=testnet -t toxictest 
                    '''            
                }
                b:{
                    sh '''
                    echo "testing e2e2"
                    docker run -v $PWD/log:/test/log --env TESTFILE=e2e2 --name pytest2 --network=testnet -t toxictest 
                    '''
                }
                c:{
                    sh '''
                    echo "testing e2e3"
                    docker run -v $PWD/log:/test/log --env TESTFILE=e2e3 --name pytest3 --network=testnet -t toxictest 
                    '''
                }
                d:{
                    sh '''
                    echo "testing e2e4"
                    docker run -v $PWD/log:/test/log --env TESTFILE=e2e4 --name pytest4 --network=testnet -t toxictest 
                    '''
                }
                sh '''
                               cd log
                if [ $(grep -c "failures" log.txt) -eq "0" ] && [curl server:8080]; then
                    docker container rm -f server pytest
                    exit 0
                fi
                docker container rm -f server pytest
                exit 1
                '''
 
            }
        }
    }
    stage('deploy'){
        when{
            branch 'master'
        }
        steps{
            script{
            docker.withRegistry("https://032245641140.dkr.ecr.us-east-2.amazonaws.com", "ecr:us-east-2:awscred") {
                docker.image("toxictypo:latest").push()
            }}
                withCredentials([file(credentialsId: '688e9c5e-9d3f-4dbf-9251-ab35669c4935', variable: 'FILE')]) {
                    sh '''
                    ssh -i $FILE ubuntu@18.222.202.245 << EOF
                    docker container rm -f srv
                    $(aws ecr get-login --no-include-email)
                    docker run -d --name srv -p 80:8080 032245641140.dkr.ecr.us-east-2.amazonaws.com/toxictypo:latest
                    '''
               }   
        }
    }
}

}