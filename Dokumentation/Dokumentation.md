
# Dokumentation Projekt Serverless-StockPriceWatchdog

 ***Lukas Truniger***
***Klasse: INP2b***
## Einleitung

Dies ist die Dokumentation zu meinem projekt um einen Stock Price Watchdog zu erstellen und betreiben. 
In der Dokumentation hier wird alles beschrieben die benötigten Befehle und Hilfsmittel aufgelistet
und zu den jeweiligen Codes verlinkt.

### Hilfsmittel
#### Cloud9
Cloud9 ist eine IDE welche direkt in der Cloud bereitgestellt wird. Sie wird auf einer EC2 Instanz betrieben
Man kann daher von überall her auf die IDE zugreifen sofern man Zugang zum AWS Account hat.

#### AWS CLI
Die Dienste werden mittel AWS CLI in die Cloud deployed. Cloud9 hat die CLI bereits integriert.

#### MS Visual Studio Code
Das Meite habe ich aus Bequemlichkeit mit VSC erstellt.

#### Github Desktop

Um die Änderungen bequem zu synchronisieren.

## Installation

### AWS Lambda

#### Was ist Lambda?

Lambda ist ein Datenverarbeitungsservice mit dem man Code ausführen kann ohne einen Server bereitstellen und verwalten zu müssen.

#### Benötigte CLI Befehle Lambda

>`aws lambda create-function --function-name SPWdog --runtime python3.9 --role arn:aws:iam::524282514575:role/LabRole`

### EventBridge
#### Was ist Event Bridge?

Event Bridge ist ein Service um Applikationen und Instanzen innerhalb der Cloud über gewisse Ereignisse zu steuern.

### AWS S3 Bucket

#### Was ist AWS S3 Bucket?

Ein Online-Speicherdienst von AWS um Daten in der Cloud zu speichern und zu verwalten. Die Daten werden in Buckets gespeichert also virtuellen Speicherbhältern die über eine URL aufrufbar sind.


### AWS SNS (Simple Notification Service)

#### Was ist AWS SNS?
SNS ist ein vollständig verwalteter Dienst mit dem man zuverlässig und schnell Millionen von Nachrichten versenden kann.

## Test

Nachdem ich die ganze Umgebung erstellt hatte SNS, Lambda, Bucket und die Evenbridge. Habe ich es in der Cloud Konsole getestet. 
Da der Stock Price von Apple sich nicht so rege bewegt wie der einer Kryptowährung habe ich in der Lambda Funktion in der Zeile 82 current_stockprice durch eine Zahl ersetzt die vom momenentanen Stock Price abweicht. Innerhalb der nächsten Minute bekam ich dann eine Nachricht auf mein Handy und wusste somit das Ganze funktioniert.

## Betriebsanweisungen
Um Die Funktionsweise nachzustellen müssen Sie die


## Reflexion



