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
                 touch log/log.txt

                docker build -t toxictest .
                docker run -d --network=testnet --name server toxictypo
               
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

                withCredentials([file(credentialsId: '688e9c5e-9d3f-4dbf-9251-ab35669c4935', variable: 'FILE')]) {
      
    
                    sh '''
                
                    ssh -i $FILE ubuntu@18.222.202.245 << EOSSH
                    docker container rm -f srv
                    $(aws ecr get-login --no-include-email)
                    docker run -d --name srv -p 80:8080 032245641140.dkr.ecr.us-east-2.amazonaws.com/toxictypo:latest
                    EOSSH
                    '''
               }   
        }
    }
}

}