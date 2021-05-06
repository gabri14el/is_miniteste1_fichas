#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Mar 19 11:21:53 2021

@author: gabriel
"""

import requests
import json

#fazendo o get
resp  = requests.get('https://my-json-server.typicode.com/typicode/demo/posts')
print(json.loads(resp.text))

resp  = requests.get('https://my-json-server.typicode.com/typicode/demo/posts')
print(json.loads(resp.text))

url = 'https://my-json-server.typicode.com/typicode/demo/posts'
payload = {'id': '7', 'title':'Post do Gabriel'}
headers = {'content-type': 'application/json'}
resp = requests.post(url, data=json.dumps(payload), headers=headers)
print(json.loads(resp.text))

url = 'https://my-json-server.typicode.com/typicode/demo/posts/3'
payload = {'title':'Post do Gabriel'}
headers = {'content-type': 'application/json'}
resp = requests.put(url, data=json.dumps(payload), headers=headers)
print(json.loads(resp.text))

url = 'https://my-json-server.typicode.com/typicode/demo/posts/3'
#payload = {'title':'Post do Gabriel'}
headers = {'content-type': 'application/json'}
resp = requests.delete(url, headers=headers)
print(json.loads(resp.text))

url = 'https://my-json-server.typicode.com/typicode/demo/comments'
payload = {'body':'Esse é o meu primeiro comentário', 'postId':3}
headers = {'content-type': 'application/json'}
resp = requests.post(url, data=json.dumps(payload), headers=headers)
print(json.loads(resp.text))
