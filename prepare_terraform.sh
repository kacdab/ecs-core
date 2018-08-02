#!/bin/bash
  
REGION=eu-central-1
BUCKET_NAME=wh-infra-stage
LOCKS_TABLE=wh-locks-stage

aws dynamodb create-table \
    --region $REGION \
    --table-name ${LOCKS_TABLE} \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1

aws s3api create-bucket \
    --region $REGION \
    --create-bucket-configuration LocationConstraint=eu-central-1 \
    --bucket ${BUCKET_NAME}

aws s3api put-bucket-versioning \
    --region $REGION \
    --bucket ${BUCKET_NAME} \
    --versioning-configuration Status=Enabled
