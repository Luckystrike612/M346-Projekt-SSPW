import requests
import logging
import time
import boto3
import json
from botocore.exceptions import ClientError
import sys

logger = logging.getLogger()
logger.setLevel(logging.INFO)

sns_client = boto3.client('sns')
s3_client = boto3.client('s3')

TOPIC_ARN = "arn:aws:sns:us-east-1:524282514575:testforsspw"

def send_notification(current_price, last_price, change, action):
    ''' 
        Erstellt eine Nachricht mit angegebenen Informationen und versendet
        diese an ein existierendes SNS-Topic.
    '''
    message = f"Stock price changed from {last_price} to {current_price}: {action} of {change} %"
    subject = "Stock price change"
    try: 
        response = sns_client.publish(
            TopicArn="arn:aws:sns:us-east-1:524282514575:testforsspw",
            Message="Kurs",
            Subject=subject,
        )['MessageId']
    except ClientError as e:
        print(e)

def get_current_stock_price(symbol):
    '''
        TODO: Funktionsbeschreibung
    '''
    url = f'https://query1.finance.yahoo.com/v11/finance/quoteSummary/AAPL'
    payload = {'modules': 'financialData'}
    headers = {'User-agent': 'Mozilla/5.0'}
    response = requests.get(url, params=payload, headers=headers)
    response.raise_for_status()
    data = response.json()
    return float(data['quoteSummary']['result'][0]['financialData']['currentPrice']['raw'])
    
def get_stored_data(symbol):
    '''
        Ermittelt die im S3 Bucket enthaltenen Daten einer Aktie. Der Bucket enthält
        die Datei mit Namen <symbol>.json oder nicht. Beim ersten Aufruf wird die Datei
        noch nicht vorhanden sein.
        Das Format der Datei ist JSON. Dadurch lassen sich die Informationen sehr schnell
        parsen bzw. serialisieren. (siehe json.loads(), bzw. json.dumps())
    '''
    try:
        # Ermitteln des Inhalts der Datei aus dem S3-Bucket als Text
        obj = s3_client.get_object(Bucket='testbucketforsspw', Key=f'{symbol}.json')
        content = obj['Body'].read().decode('utf-8')
        return json.loads(content)
    except ClientError as e:
        print(e)
    return None


def store_data(symbol, data):
    '''
        TODO: Funktionsbeschreibung
    '''
    content = json.dumps(data, sort_keys=True, indent=4)
    response = s3_client.put_object(Body=str.encode(content), Bucket='testbucketforsspw', Key=f'{symbol}.json')
    return response

def lambda_handler(event, context):
    symbol = 'aapl'
    current_price = get_current_stock_price(symbol)
    data = get_stored_data(symbol)
    if not data:
        data = {}
        data['last-price'] = current_price
        store_data(symbol, data)
        return

    last_price = float(data['last-price'])
    delta = current_price - last_price
    change = (delta / last_price) * 100
    
    if delta > 0:
        action = "increase"
    else:
        action = "decrease"

    if abs(change) > 0.01:
        send_notification(current_price, last_price, change, action)
        data['last-price'] = current_price
        store_data(symbol, data)
    
    print(f'last price: {last_price}')
    print(f'current price: {current_price}')
    print(f'delta: {delta}')
    print(f'change {change} %')
    print(f'action {action}')
    
        
    # TODO: Speichern des aktuellen Werts
    # TODO: Benachrichtigung falls notwendig
    
    return { 'current-price': current_price, 'last-price': last_price }
