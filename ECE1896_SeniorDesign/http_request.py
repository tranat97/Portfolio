import requests
import json

bridgeIP = "192.168.1.217"
username = "XxnN7sLNGackdWvLjjIrq64f5cM99Hf1VhFubtPk" #username

    
        

url = "http://192.168.1.217/api/"+username+"/groups/1/action"
body = "{'on':false}"
response = requests.put(url, body)
#response = requests.get(url)
print(response.json()) 