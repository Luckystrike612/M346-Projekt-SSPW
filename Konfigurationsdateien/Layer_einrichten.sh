#!/bin/bash
  
layer_name="requests-layer"
aws lambda delete-layer-version --layer-name ${layer_name} --version-number 1
layer_arn=`aws lambda publish-layer-version --layer-name ${layer_name} --zip-file fileb://requests-layer.zip --query LayerVersionArn | tr -d '"'`
echo $layer_arn
