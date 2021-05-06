#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Mar 19 12:18:00 2021

@author: gabriel
"""

import requests
import json

'''
Html:
    <html>
<head>
<title>Personal INFO</title>
</head>
<body>
<form method="post" action="./process.php">
First Name:<input type="text" size="12" maxlength="12" name="Fname"><br />
Last Name:<input type="text" size="12" maxlength="36" name="Lname"><br />
<input type="submit" name="enviar" value="Send">
</form>
</body>
</html>


Tem que ir no navegador (F12) em "network" para ver o post
'''

url = 'http://localhost/aula3/process.php'
payload = {'Fname': 'Gabriel', 'Lname':'Carneiro'}
headers = {'content-type': 'application/x-www-form-urlencoded'}
resp = requests.post(url, data=json.dumps(payload), headers=headers)
print(json.loads(resp.text))