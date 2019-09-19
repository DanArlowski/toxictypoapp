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
                docker build -t toxictest .
                docker run -d --network=testnet --name server toxictypoapp
                docker run --network=testnet -it toxictest > log.txt
                docker container rm -f server
                code=$(grep -i "failures" log.txt)
                if [ $code -ne 0 ]; then
                    exit 1
                fi
                '''
        }
    }
    stage('deploy'){
        when{
            branch 'master'
        }
        steps{
            script{
            docker.withRegistry("https://032245641140.dkr.ecr.us-east-2.amazonaws.com", "ecr:us-east-2:AKIAQPAP5N62NTJEEA6P") {
                docker.image("toxictest").push()
            }}
        }
    }


}

}