#!/usr/bin/env bash

# more bash-friendly output for jq
JQ="jq --raw-output --exit-status"

configure_aws_cli(){
	aws --version
	aws configure set default.region us-west-2
	aws configure set default.output json
}

push_ecr_image(){
	eval $(aws ecr get-login --region us-west-2)
    docker push $AWS_ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com/hello-service:$CIRCLE_BUILD_NUM
}

create_deploy_data(){
    cp Dockerrun.aws.json.template Dockerrun.aws.json
    sed -i'' -e "s;%TAG%;$CIRCLE_BUILD_NUM;g" Dockerrun.aws.json
    sed -i'' -e "s;%AWS_ACCOUNT_ID%;$AWS_ACCOUNT_ID;g" Dockerrun.aws.json

    mkdir .ebextensions
    cp 00_set_timezone.config .ebextensions/00_set_timezone.config

    zip $CIRCLE_BUILD_NUM-eb-docker-package.zip .ebextensions/00_set_timezone.config Dockerrun.aws.json

    aws s3 cp $CIRCLE_BUILD_NUM-eb-docker-package.zip s3://docker-eb-deployment/hello-service/$CIRCLE_BUILD_NUM-eb-docker-package.zip

}

deploy_eb(){
    # Create new Elastic Beanstalk version
    aws elasticbeanstalk create-application-version --application-name docker-app \
      --version-label hello-service-$CIRCLE_BUILD_NUM --source-bundle S3Bucket=docker-eb-deployment,S3Key=hello-service/$CIRCLE_BUILD_NUM-eb-docker-package.zip

    # Update Elastic Beanstalk environment to new version
#    aws elasticbeanstalk update-environment --environment-name easy-microservice-taxcalculator-env \
#       --version-label easy-microservice-taxcalculator-$CIRCLE_BUILD_NUM

}
configure_aws_cli
push_ecr_image
create_deploy_data
deploy_eb