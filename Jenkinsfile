pipeline {
    agent {
        label 'ssh'  
    }
    parameters {
        string(name: 'REF', defaultValue: '\${ghprbActualCommit}', description: 'Commit to build')
    }
    stages {
        stage('Webpacker Install') {
            steps {
                sh '/usr/local/bin/docker-compose run --rm web_jenkins2 bin/rails webpacker:install'
            }
        }
        stage('Build') {
            steps {
                sh '/usr/local/bin/docker-compose stop'
                sh '/usr/local/bin/docker-compose up -d'
                sh '/usr/local/bin/docker-compose exec -T --user "$(id -u):$(id -g)" web_jenkins2 bin/rails db:create'
                sh '/usr/local/bin/docker-compose exec -T --user "$(id -u):$(id -g)" web_jenkins2 bin/rails db:migrate'
                timeout(120) {
                    waitUntil {
                        script {
                            try {
                                def response = httpRequest 'http://0.0.0.0:3030'
                                return (response.status == 200)
                            }
                            catch (exception) {
                                return false
                            }
                        }
                    }
                }
            }
        }
        stage('test') {
            steps {
                sh '/usr/local/bin/docker-compose exec -T --user "$(id -u):$(id -g)" web_jenkins2 bin/rails test:models'
            }   
        } 
        // stage('Stop server') {
        //     steps {
        //         sh '/usr/local/bin/docker-compose stop'
        //     }
        // }
    }
}