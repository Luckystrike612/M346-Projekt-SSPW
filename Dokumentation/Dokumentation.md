
# Dokumentation Projekt Serverless-StockPriceWatchdog

 ***Lukas Truniger***
***Klasse: INP2b***
## Einleitung

Dies ist die Dokumentation zu meinem Projekt um einen Stock Price Watchdog zu erstellen und betreiben. 
In der Dokumentation hier wird alles beschrieben die benötigten Befehle und Hilfsmittel aufgelistet
und zu den jeweiligen Codes/Skripts verlinkt.

### Hilfsmittel
#### Cloud9
Cloud9 ist eine IDE welche direkt in der Cloud bereitgestellt wird. Sie wird auf einer EC2 Instanz betrieben
Man kann daher von überall her auf die IDE zugreifen sofern man Zugang zum AWS Account hat.

#### AWS CLI
Die Dienste werden mittel AWS CLI in die Cloud deployed. Cloud9 hat die CLI bereits integriert.

#### MS Visual Studio Code
Das Meiste habe ich aus Bequemlichkeit mit VSC erstellt.

#### Github Desktop

Um die Änderungen bequem zu synchronisieren.

## Installation

### AWS Lambda

#### Was ist Lambda?

Lambda ist ein Datenverarbeitungsservice mit dem man Code ausführen kann ohne einen Server bereitstellen und verwalten zu müssen.

### AWS Layers
#### Was sind AWS Layers?

Layers sind eine Erweiterung für AWS Lambda Funktionen, die zusätzliche Codebibliotheken, Dateien und andere Inhalte bereitstellen können.
Somit kann man einen Layer mehreren Funktionen hinzufügen so das diese sie verwenden können um Inhalte und Code zu teilen. So muss er nicht für jede Funktion dupliziert werden.

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

Nachdem ich die ganze Umgebung erstellt hatte SNS, Lambda, Bucket und die Eventbridge. Habe ich es in der Cloud Konsole getestet. 
Da der Stock Price von Apple sich nicht so rege bewegt wie der einer Kryptowährung habe ich in der Lambda Funktion in der Zeile 82 die current_stockprice Variable durch eine Zahl ersetzt die vom momenentanen Stock Price abweicht. Innerhalb der nächsten Minute bekam ich dann eine Nachricht auf mein Handy und wusste somit das Ganze funktioniert.
Eine bessere Methode zum testen ist das abändern der if Abfrage in der Zeile 90 von > 0.1 zu == 0 so sendet er eine Nachricht wenn sich nichts am Stock Preis ändert. würde natürlich auch funktionieren wenn man es so modifiziert das es gesendet wird wenn die Änderung kleiner ist.

Testfall in Lambda vom 18.12.22
![TestfallinLambda](https://res.cloudinary.com/dx2sgwe9o/image/upload/v1671701056/Projekte/Projekt%20SSPW%20M346/Testfall_f%C3%BCr_Nachricht_ew8zn6.png)
Das Ergebnis dieses Testes war erfolgreich:
![Ergebnis](https://res.cloudinary.com/dx2sgwe9o/image/upload/v1671826006/Projekte/Projekt%20SSPW%20M346/ergebnis_testfall_z1xgqz.png)
Es wird eine völlig falsche Prozentzahl angezeigt was klar ist weil ich die Variable durch eine Zahl ersetzt hatte Der Stockpreis bleibt ja unverändert.

Nun hier noch ein Testfall wenn eben auf 0 abgeändert wird vom 22.12.22:

![testnachrichtdurchmanipulation_code](https://res.cloudinary.com/dx2sgwe9o/image/upload/v1671702246/Projekte/Projekt%20SSPW%20M346/testfall_auf0.0_ge%C3%A4ndert_xsoi1o.png)



Ich habe das Ganze Skript in Betrieb genommen und nach einigen Anpassungen funktioniert nun das Ganze Skript.

Nach weiteren Testfällen auf einer anderen Umgebung hat sich mein Skript nicht richtig ausgeführt... Nur wenn man den Inhalt des Skripts in die Command Line kopiert wird es korrekt ausgeführt.

## Betriebsanweisungen
Um die Funktion in Betrieb zu nehmen sind folgende Schritte notwendig:
1. Die Dateien [Skript](https://github.com/Luckystrike612/M346-Projekt-SSPW/blob/97333a3e35a2dfcd46dc1b7ddc19d61cedf3f3ab/Konfigurationsdateien/Skript), [Lambda_Function](https://github.com/Luckystrike612/M346-Projekt-SSPW/blob/97333a3e35a2dfcd46dc1b7ddc19d61cedf3f3ab/Konfigurationsdateien/Lambda_Function.py) und [requests-layer.zip](https://github.com/Luckystrike612/M346-Projekt-SSPW/blob/97333a3e35a2dfcd46dc1b7ddc19d61cedf3f3ab/Konfigurationsdateien/requests-layer.zip) herunter laden oder via git pullen.
2. Danach diese 3 Dateien in einem seperatem Ordner speichern (aus dem Git Ordner nehmen).
3. das Skript öffnen un die Variablen anpassen nach eigenem Wunsch. Es können und MÜSSEN unter Umständen gewisse Anpassungen getätigt werden. Es muss zb. Eine Rolle mit Lambda Berechtigungen gewäht werden.
4. Das Skript ausführen, indem man das Ganze Skript in die Command Line kopiert! Aufruf über bash funktioniert nicht. wenn nun alles geklappt hat und richtig ausgeführt wurde ist die Funktion erstellt und sie sollten eine Nachricht an die Email Adresse erhalten, welche Sie in dem Skript angegeben haben. Darin ist ein Bestätigungslink, klicken Sie auf diesen. ACHTUNG! man muss dei Rechte für die erwähnten Services besitzen.
5. Nun ist alles fertig und die Benachrichtigung aktiviert wenn sich die Aktie um mehr als 0.1 Prozent Punkte ändert kriegen Sie eine Nachricht.

Bitte beachten: Die Nachricht wird nur Montags- Freitags ausgelöst. 


## Reflexion

Es hat mir echt viel Spass gemacht diese Projekt zu verwirklichen. ich finde das Ganze Thema Cloud Computing aber auch unheimlich spannend weil es einfach sehr viel effizienter und Ressourcenschonender ist als das herkömmliche On Premise System. Vermutlich werden wir in Zukunft nur noch unsere Smartphones für die Bildübertragung nutzen und grössere Rechenleistung aus der Cloud beziehen. Immer potenter werdende Übertragungswege wie 5g und Glasfaser werden dies möglich machen.

Zu Anfang des Projekts schien es erst kaum machbar ich musste erstmal wirkrlich viele Informationen einholen und auch meine Kenntnisse in Python etwas erweitern. Ich hatte lange fast gar nichts vor zu weisen, weil ich mich erstmal informieren musste über die einzelnen Dienste. Ich vertiefte mich in die jeweiligen Dokumentationen der Befehle um heraus zu finden welche Optionen und Parameter ich verwenden muss um das Ziel zu erreichen und auch welche von den Parametern grundsätzlich benötigt werden. 

Abschliessend kann ich sagen das ich unheimlich viel profitiert habe von dem Projekt da ich sehr viel dazu gelernt habe in Python, Bash-Skripts, AWS CLI und den verwendeten AWS Diensten. 

In einem nächsten Projekt in der AWS möchte ich mir vorher noch die Rollen bzw. IAM noch genauer ansehen. Auf meinem privaten AWS Account konnte ich das Skript nämlich erst nicht laufen lassen. Es sollte eigentlich für jeden Dienst den man in die Cloud nimmt auch eigene Rechte vergeben werden um den Überblick wahren zu können. Das Tagging wil ich auch anfangen gezielt einzusetzen.

## Quellen

Sämtliche Quellen für die Skripts wurden aus der [AWS Dokumentation](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/index.html#cli-aws) entnommen. 

Ich habe mir auch vereinzelt Youtube Videos angeschaut um das Projekt zu ralisieren. Es war einfacher gewisse Sachen im Einsatz zu sehen um sie richtig nachvollziehen zu können.

weitere Quellen/Hilfsmittel:
[Markdown Guide](https://www.markdownguide.org/getting-started/)
[Yahoo Finance API Guide](https://algotrading101.com/learn/yahoo-finance-api-guide/)
[boto3 Dokumentation](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html)
