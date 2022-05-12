# SMB_Rotate

A stealthy, fast and easy tool to spray Active Directory credentials and bypass AD credential spraying controls.

This tool sprays active directory credentials on different computers, for each attempt it changes computers and it is possible to group the attempts by groups in a specified time interval, and thus evade controls.
### Requirements

```
rpcclient
```

### Installation

Install SMB_Rotate

```
git clone https://github.com/Bytenull00/SMB_Rotate.git
```

## Usage 

```
./smb_rotate.sh <IP_FILE> <DOMAIN> <USER_FILE> <PASSWORD> <NUMBER OF ATTEMPTS BEFORE SLEEP> <SLEEP SECONDS>

IP_FILE = File with IP addresses of the computers to spray the credentials.
DOMAIN = Active Directory Domain.
USER_FILE = File with domain users.
PASSWORD = Password to spray for each user of the USER_FILE file.
NUMBER OF ATTEMPTS BEFORE SLEEP = Number of attempts before sleeping.
SLEEP SECONDS = Seconds to sleep between each interval number of attempts.
```

## Demo


### Credits 

* Gustavo Segundo - ByteNull%00
