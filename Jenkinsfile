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

             httpRequest authentication: 'try_cicdsonarkey', httpMode: 'POST', consoleLogResponseBody: true, url: 'https://sonarcloud.io/api/ce/activity?onlyCurrents=true&componentId=AWjv5epGO1eEjtclXbJB'
    //      withCredentials([string(credentialsId: 'try_cicdsonarkey', variable: 'try')]) {   
    // // //     def auth = httpRequest "https://sonarcloud.io/api/authentication?validate=$try"
    // //         sh 'curl --data "validate=$try" https://sonarcloud.io/api/authentication'
    //         sh  'curl -u $try: https://sonarcloud.io/api/user_tokens/search'
    //     }
    //        def response = httpRequest "https://sonarcloud.io/api/ce/activity?onlyCurrents=true&componentId=AWjv5epGO1eEjtclXbJB"
          
    //          sh 'echo $response'
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