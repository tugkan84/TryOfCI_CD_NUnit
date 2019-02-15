properties([pipelineTriggers([githubPush()])])
def imageName = 'try_ci_cd'
def buildNumber = env.BUILD_NUMBER.toString()
node {
    try{
    stage ('Checkout'){
        git branch: 'master', url: 'https://github.com/tugkan84/TryOfCI_CD_NUnit.git'
    }

    stage("Sonar Begin"){
        withCredentials([string(credentialsId: 'try_cicdsonarkey', variable: 'try')]) {
        sh 'dotnet sonarscanner begin /k:"try_cicdsonarkey" /d:sonar.organization="tugkan84-github" /d:sonar.host.url="https://sonarcloud.io" /d:sonar.login="$try"'
        ///d:sonar.exclusions="/wwwroot/lib/** eklersek lib içindekileri ignore eder
        }
    }

     stage("Build"){
        sh 'dotnet build'
    }
    stage("Test"){
        sh 'dotnet test ./TryOfCI_CD_NUnit.Test/TryOfCI_CD_NUnit.Test.csproj /p:CollectCoverage=true /p:CoverletOutputFormat=opencover /p:CoverletOutput=../../.sonarqube/coverage/api.opencover.xml'
    }

      stage("Sonar End"){
          withCredentials([string(credentialsId: 'try_cicdsonarkey', variable: 'try')]) {
        sh 'dotnet sonarscanner end /d:sonar.login="$try"'
          }
    }

    stage("Sonar Analiz"){
        def props = utils.getProperties("target/sonar/report-task.txt")
        echo "properties=${props}"
        def sonarServerUrl=props.getProperty('serverUrl')
        def ceTaskUrl= props.getProperty('ceTaskUrl')
        def ceTask
        def URL url = new URL(ceTaskUrl)
          timeout(time: 1, unit: 'MINUTES') {
            waitUntil {
              ceTask = utils.jsonParse(url)
              echo ceTask.toString()
              return "SUCCESS".equals(ceTask["task"]["status"])
            }
          }
          url = new URL(sonarServerUrl + "/api/qualitygates/project_status?analysisId=" + ceTask["task"]["analysisId"] )
          def qualitygate =  utils.jsonParse(url)
          echo qualitygate.toString()
          if ("ERROR".equals(qualitygate["projectStatus"]["status"])) {
            error  "Quality Gate failure"
          }

    }

    stage("Docker Build") {
            sh 'docker build --rm -f "Dockerfile" -t birkanazimech/try_ci_cd .'

        sh "docker tag birkanazimech/${imageName}:latest birkanazimech/${imageName}:${buildNumber}"
    }
    stage("Docker Push"){
        withCredentials([usernamePassword(credentialsId: '63579a04-67b2-4b24-a646-6b2b330829be', passwordVariable: 'my_dockerhubpass', usernameVariable: 'my_dockerhubuser')]) {
    
            sh "docker login -u birkanazimech -p $my_dockerhubpass"
            sh "docker push birkanazimech/${imageName}:latest"
            sh "docker push birkanazimech/${imageName}:${buildNumber}"
         }
    }
    stage("Clear Docker Image"){
            sh "docker image rm birkanazimech/${imageName}:${buildNumber}"
    }

    stage("Docker Prune"){
        sh 'docker image prune -f'
    }
   }
    catch(e){
        def logUrl = "${env.BUILD_URL}/consoleText"

        httpRequest httpMode: 'POST', ignoreSslErrors: true, requestBody: """{
    "text": "I am a test message http://slack.com",
    "attachments": [
        {
            "text": "And here’s an attachment! = ${e} ; Stack Trace = ${logUrl}"
        }
                    ]
        }""", responseHandle: 'NONE', url: 'https://hooks.slack.com/services/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'
        throw e
    }
}