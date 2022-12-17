#!/bin/bash

lambda_f_name="SPWdog"
aws lambda delete-function --function-name ${lambda_f_name}
Lambda_Arn=`aws lambda create-function --function-name SPWdog --zip-file fileb://Lambda_Function.zip --handler index.handler --runtime python3.9 --role arn:aws:iam::524282514575:role/LabRole --layers ${layer_arn} --query FunctionArn | tr -d '"'`