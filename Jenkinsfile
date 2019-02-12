properties([pipelineTriggers([githubPush()])])

node {
    stage ('Checkout'){
        git branch: 'docker', url: 'https://github.com/tugkan84/TryOfCI_CD_NUnit.git'
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
    stage("Push to Docker"){
        //sh 'git push -u origin master'
        sh 'git tag -a tagName -m "Your tag comment"'
        sh 'git merge docker'
        sh 'git commit -am "Merged docker branch to master'
        sh 'git push origin master'
    }
}