pipeline{
    agent{ label '' }
    triggers { pollSCM (' * * * * *' )}
    stages{
        stage('vcs'){
            steps{
                git url: 'https://github.com/sunidangeti07/spring-petclinic.git',
                    branch: 'main'
            }
        }
        stage('build'){
            steps{
                sh 'mvn package'
            }
        }
         stage("build & SonarQube analysis") {
            steps {
              withSonarQubeEnv('SONAR_QUBE_TOKEN') {
                 sh 'mvn verify org.sonarsource.scanner.maven:sonar-maven-plugin:sonar -Dsonar.projectKey=sunidangeti07_spcsai -Dsonar.organization=sunidangeti07'
              } 
            }
        }       
        stage('archive artifacts'){
            steps{
                archiveArtifacts artifacts: '**/target/*.jar',
                            onlyIfSuccessful: true
                junit testResults: '**/surefire-reports/TEST-*.xml'            
            }
        }
        stage('push into s3') {
            steps {
                sh 'aws s3 cp target/workspace/spring-petclinic-3.0.0-SNAPSHOT.jar s3://sai-22'
            }
        }
        stage('deploy with ansible') {
            agent { label 'ansi_1'}
            steps{
                sh 'ansible-playbook -i hosts spcansible.yml'
            }
        }
        satge('deploying with ansible') {
            steps {
                sh 'ansible-playbook -i hosts spc.yml'
            }
        }         

    }
}