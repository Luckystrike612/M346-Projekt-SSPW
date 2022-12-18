#!/bin/bash

#Hier wird der Name des Layers definiert. Kann man stehen lassen.
layer_name="requests-layer"

#Hier der Name für die Funktion.
lambda_f_name="SPWdog"

#Der Name für die Regel von EventBridge
rule_name="SSPWEvent"

#Hier wird das Thema definiert für SNS.
topic_name="SSPWSNS"

#Hier Bitte die Email Adresse angeben auf welcher die Funktion die Nachrichten schicken soll.
email_adresse="lukas_truniger@outlook.com" 

#Der Name für den Bucket welcher den preis speichert. Er muss einzigartig sein und wird nicht öffentlich sein daher reicht eine wilde Kombination.
#Falls ein Bucket mit diesem Namen bereits besteht wird er gelöscht also Vorsicht!
s3bucket_name="testttcsgdssfsd"


#Die nächste Zeile erstellt den SNS Topic für die Benachrichtigung
topic_arn=`aws sns create-topic --name ${topic_name} --query TopicArn | tr -d '"'`


# Zieldatei
file=Lambda_Function.py

# Zu ersetzender Satz
old_string="Hier Muss die ARN des Topics stehen"

# Neuer Satz
new_string="${topic_arn}"

# Satz ersetzen
sed -i "s/$old_string/$new_string/g" "$file"




# Zieldatei
file=Lambda_Function.py

# Zu ersetzender Satz
old_string="Hier muss der Name des S3 Buckets stehen"

# Neuer Satz
new_string="${s3bucket_name}"

# Satz ersetzen
sed -i "s/$old_string/$new_string/g" "$file"



#Damit die Funktion hochgeladen werden kann muss sie vorher gezippt werden.
zip Lambda_Function.zip Lambda_Function.py





#Mit Diesem Befehl wird der Lambda layer erstellt.
aws lambda delete-layer-version --layer-name ${layer_name} --version-number 1
layer_arn=`aws lambda publish-layer-version --layer-name ${layer_name} --zip-file fileb://requests-layer.zip --query LayerVersionArn | tr -d '"'`



#Diese Erstellt die Lambda Funktion und lädt den Code hoch.
aws lambda delete-function --function-name ${lambda_f_name}
Lambda_Arn=`aws lambda create-function --function-name ${lambda_f_name} --zip-file fileb://Lambda_Function.zip --handler Lambda_Function.lambda_handler --runtime python3.9 --role arn:aws:iam::524282514575:role/LabRole --layers ${layer_arn} --query FunctionArn | tr -d '"'`


#Hier wird die EventBridge Regel erstellt. Es wird definiert wie oft bzw. wann die Funktion bzw. das was an diese Regel angehängt ist ausgeführt werden soll.
Rule_Arn=`aws events put-rule --schedule-expression "cron(0/1 * ? * MON-FRI *)" --name ${rule_name} --query RuleArn | tr -d '"'`

#Der Regel wird hier die Berechtigung erteilt die Lambda Funktion auszuführen
aws lambda add-permission --function-name ${lambda_f_name} --statement-id  ${rule_name} --action 'lambda:InvokeFunction' --principal events.amazonaws.com --source-arn ${Rule_Arn}

#Nun wird die Regel der Funktion zugeordnet.
aws events put-targets --rule ${rule_name} --targets "Id"="66","Arn"="${Lambda_Arn}"



#Mit dem Subscribe wird nun abnonniert und die Meldungen an die genannten Email Adressen versendet.
aws sns subscribe --topic-arn ${topic_arn} --protocol email --notification-endpoint ${email_adresse}


aws s3 rb s3://${s3bucket_name} --force
aws s3 mb s3://${s3bucket_name} --region us-east-1
