#!/usr/bin/env groovy
pipeline {
    agent none

    environment {
        tag = VersionNumber(versionNumberString: '${BUILD_TIMESTAMP}');
        // job environment variables
        BUILD_ENV = "${build_stream}"
            // this is a result of a backwards-incompatible change from JENKINS-24380
            BUILD_ID = "${VersionNumber(projectStartDate: '1970-01-01', versionNumberString: '${BUILD_DATE_FORMATTED, \"yyyy-MM-dd_H-m-s\"}')}"
    }

    parameters {
        booleanParam(name: 'deploy',
                     defaultValue: false,
                     description: 'Whether or not to deploy this new build to the environment selected below.')
        string(name: 'branch',
               defaultValue: 'main',
               description: 'The source branch to compile.')
        choice(name: 'env',
               choices: ['mob_qa','mob_pro','beta_qa','stage.qa','api.qa','api.pro'],
               description: 'If deploying, which ansible environment to deploy to.  Determines deployment target')
        choice(name: 'dog_env',
               choices: ['qa','pro'],
               description: 'If deploying, which dog environment to deploy to.  Determines which dog_trainer this build will connect to')
        string(name: 'target',
               defaultValue: '',
               description: 'The target host/group.')
        string(name: 'flags',
               defaultValue: '--tags upgrade',
               description: 'ansible flags')
        choice(name: 'erlang_version',
               choices: ['24.3.4.2'],
               description: 'The erlang_version dog_agent_ex will be built with')
    }

    stages {
        stage('Matrix Build') {
            matrix {
                agent {
                    docker { 
                        image "${DOCKER_IMAGE}"
                            args '--user="root"'
                    }
                }
                axes {
                    axis {
                        name 'DOCKER_IMAGE'
                            values 'relaypro/elixir-14-4-erlang-24-focal:master-latest', 'relaypro/elixir-14-4-erlang-24-xenial:master-latest'
                    }
                }

                stages {
                    stage ('Checkout') {
                        steps {
                            checkout([$class: 'GitSCM', branches: [[name: '${branch}']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'admin', url: 'https://github.com/relaypro-open/dog_agent_ex.git']]]) 
                        }
                    }
                    stage('Build') {
                        steps{

                            sh """#!/bin/bash -x
                                echo "PWD: ${PWD}"

                                cd $WORKSPACE
                                rm -rf _build

                                # elixir expects utf8.
                                export ELIXIR_VERSION="v1.14.4"
                                export LANG=C.UTF-8

                                set -xe \
                                && ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/\${ELIXIR_VERSION}.tar.gz" \
                                && ELIXIR_DOWNLOAD_SHA256="07d66cf147acadc21bd1679f486efd6f8d64a73856ecc83c71b5e903081b45d2" \
                                && curl -fSL -o elixir-src.tar.gz \$ELIXIR_DOWNLOAD_URL \
                                && echo "\$ELIXIR_DOWNLOAD_SHA256  elixir-src.tar.gz" | sha256sum -c - \
                                && mkdir -p /usr/local/src/elixir \
                                && tar -xzC /usr/local/src/elixir --strip-components=1 -f elixir-src.tar.gz \
                                && rm elixir-src.tar.gz \
                                && cd /usr/local/src/elixir \
                                && make install clean \
                                && find /usr/local/src/elixir/ -type f -not -regex "/usr/local/src/elixir/lib/*/lib.*" -exec rm -rf {} + \
                                && find /usr/local/src/elixir/ -type d -depth -empty -delete

                                echo "PWD: ${PWD}"
                                cd $WORKSPACE

                                echo "env: \$env"
                                echo "dog_env: \$dog_env"

                                if [[ \$env == *qa ]]; then
                                    build_env="qa"
                                        elif [[ \$env == *pro ]]; then
                                        build_env="pro"
                                        elif [[ \$env == *dev ]]; then
                                        build_env="dev"
                                        fi

                                        if [[ \$DOCKER_IMAGE == 'relaypro/elixir-14-4-erlang-24-xenial:master-latest' ]]; then
                                            build_suffix='ubuntu'
                                                elif [[ \$DOCKER_IMAGE == 'relaypro/elixir-14-4-erlang-24-focal:master-latest' ]]; then    
                                                build_suffix='ubuntu-20-04'
                                                fi

                                                #ls /opt/kerl/lib
                                                #. /opt/kerl/lib/\$erla//ng_version/activate
                                                which erl

                                                echo "build_env: \$build_env"

                                                apt-get update && apt-get install -y libcap-dev locales iptables ipset lsb-release jq curl make

                                                mix local.hex --force && mix local.rebar --force

                                                mkdir /etc/dog_ex

                                                echo "PWD: ${PWD}"
                                                cp config/runtime.${dog_env}.exs config/runtime.exs

                                                mix deps.get \
                                                && mix deps.clean --all --build \
                                                && mix compile \
                                                && MIX_ENV=${dog_env} mix release
                                                find .
                                                mv -f _build/qa/dog-0.1.0.tar.gz \$dog_env-\$BUILD_ID.\$build_suffix.tar.gz
                                                chown -R jenkins:jenkins $WORKSPACE
                                                """

                        }

                        post {
                            success {
                                archiveArtifacts allowEmptyArchive: false, artifacts: '*.tar.gz', caseSensitive: true, defaultExcludes: true, fingerprint: false
                            }


                        }
                    }

                    stage('Upload artifact to S3') {
                        steps {
                            withAWS(credentials: 'aws-iam-user/product-jenkins-artifact-uploads') {
                                s3Upload bucket:'product-builds', path: 'dog_ex/', includePathPattern: '*.tar.gz'
                            }

                        }
                    }

                    stage('Deploy') {
                        when {
                            expression { params.deploy == true }
                        }
                        steps {
                            build job: '/playbyplay/pbp-common-deploy', parameters: [
                                string(name: 'deployEnv', value: "${params.env}"),
                                string(name: 'app', value: 'dog'),
                                string(name: 'target', value: "${params.hosts}"),
                                string(name: 'ansibleFlags', value: '')
                            ]
                        }
                    }
                }
            }
        }
    }
    post {
        changed {
            emailext(
                    to: 'dgulino@relaypro.com',
                    body: '${DEFAULT_CONTENT}', 
                    mimeType: 'text/html',
                    subject: '${DEFAULT_SUBJECT}',
                    replyTo: '$DEFAULT_REPLYTO'    
                    )
        }
        cleanup{
            deleteDir()
        }
    }
}
