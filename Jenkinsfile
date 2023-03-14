pipeline {
    agent { label'sai_1' } 
    triggers { pollSCM('* * * * *') }
    stages {
        stage('vcs') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/sunidangeti07/spring-petclinic.git'
            }
        }
        stage ('Artifactory Configuration') {
            steps {
                rtServer (
                    id: "ARTIFACTORY_SERVER", 
                    url: "https://dangetisai.jfrog.io/artifactory",
                    credentialsId: "JFROG_TOKEN"
                )

                rtMavenResolver (
                    id: 'MAVEN_RESOLVER',
                    serverId: 'artifactory-server-id',
                    releaseRepo: libs-release,
                    snapshotRepo: libs-snapshot
                )  
                 
                rtMavenDeployer (
                    id: 'MAVEN_DEPLOYER',
                    serverId: 'ARTIFACTORY_SERVER',
                    releaseRepo: libs-release,
                    snapshotRepo: libs-snapshot
                )
            }
        }
        stage('package') {
            tools {
                jdk 'JDK_17'
            }
            steps {
                rtMavenRun (
                    tool: 'MAVEN_TOKEN',
                    pom: 'pom.xml',
                    goals: 'clean install',
                    deployerId: "MAVEN_DEPLOYER"
                    
                )
                rtPublishBuildInfo (
                    serverId: "ARTIFACTORY_SERVER"
                )
                //sh "mvn ${params.MAVEN_GOAL}"
            }
        }
        stage('post build') {
            steps {
                archiveArtifacts artifacts: '**/target/spring-petclinic-3.0.0-SNAPSHOT.jar',
                                 onlyIfSuccessful: true
                junit testResults: '**/surefire-reports/TEST-*.xml'
            }
        }
    }
}       