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
                docker build -t toxictypo .
                docker run -d --network=testnet --name server toxictypoapp
                touch log/log.txt
                docker run -v $PWD/log:/test/log --name pytest --network=testnet -t toxictest 
                docker container rm -f server pytest
                cd log
                if [ $(grep -c "failures" log.txt) -eq "0" ]; then
                    exit 0
                fi
                exit 1
                '''
        }
    }
    stage('deploy'){
        when{
            branch 'master'
        }
        steps{
            script{
            docker.withRegistry("https://032245641140.dkr.ecr.us-east-2.amazonaws.com", "ecr:us-east-2:awscred") {
                docker.image("toxictypo").push()
            }}

            sshagent (credentials: ['ec2']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no  ubuntu@18.222.202.245 << EOSSH
                    $(aws ecr get-login --no-include-email)
                    docker run -p 80:8080 032245641140.dkr.ecr.us-east-2.amazonaws.com/toxictypo:latest
                    EOSSH
                    '''
            }
        }
    }
}

}