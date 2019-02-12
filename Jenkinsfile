properties([pipelineTriggers([githubPush()])])
def imageName = 'try_ci_cd'
def buildNumber = env.BUILD_NUMBER.toString()
node {
    stage ('Checkout'){
        git branch: 'master', url: 'https://github.com/tugkan84/TryOfCI_CD_NUnit.git'
    }
     stage("Build"){
        sh 'dotnet build'
    }
    stage("Test"){
        sh 'dotnet test ./TryOfCI_CD_NUnit.Test/TryOfCI_CD_NUnit.Test.csproj'
    }
    // stage("Docker"){
    //     echo "Hello"
    //     //docker build --rm -f "Dockerfile" -t tryofci_cd_nunit:latest .
    // }

    stage("Docker Build") {
            sh 'docker build --rm -f "Dockerfile" -t try_ci_cd .'
        // dir("./src") {
        // }
        sh "docker tag ${imageName}:latest ${imageName}:${buildNumber}"
    }
    stage("Docker Push"){
        withCredentials([string(credentialsId: '63579a04-67b2-4b24-a646-6b2b330829be', variable: 'GITLAB_TOKEN')]) {
            sh "docker login -u birkanazimech -p tugkan5441"
            sh "docker push ${imageName}:latest"
            sh "docker push ${imageName}:${buildNumber}"
        }
    }
   
}