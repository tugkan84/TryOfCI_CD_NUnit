properties([pipelineTriggers([githubPush()])])
def imageName = 'try_ci_cd'
def buildNumber = env.BUILD_NUMBER.toString()
node {
    try{
    stage ('Checkout'){
        git branch: 'master', url: 'https://github.com/tugkan84/TryOfCI_CD_NUnit.git'
    }
     stage("Build"){
        sh 'dotnet build'
    }
    stage("Test"){
        sh 'dotnet test ./TryOfCI_CD_NUnit.Test/TryOfCI_CD_NUnit.Test.csproj'
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
        //sh "echo ${err}"
        httpRequest httpMode: 'POST', ignoreSslErrors: true, requestBody: """{
    "text": "I am a test message http://slack.com",
    "attachments": [
        {
            "text": "And here’s an attachment! = ${e.getMessage()} ; Stack Trace = ${e.getStackTrace().join('\n')}"
        }
                    ]
        }""", responseHandle: 'NONE', url: 'https://hooks.slack.com/services/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'
        throw e
    }
}