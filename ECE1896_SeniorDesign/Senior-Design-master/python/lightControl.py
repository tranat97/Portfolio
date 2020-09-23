import requests
import json
import os
from os import path
import time


def getGroups(ip, username):
    url = "http://"+ip+"/api/"+username+"/groups/"
    response = requests.get(url)
    groups = json.loads(response.text)
    print(groups)
    return groups

def turnOn(roomID, ip, username):
    url = "http://"+ip+"/api/"+username+"/groups/"+str(roomID)+"/action"
    body = '{"on":true}'
    requests.put(url, body)

def turnOff(roomID, ip, username):
    url = "http://"+ip+"/api/"+username+"/groups/"+str(roomID)+"/action"
    body = '{"on":false}'
    requests.put(url, body)

def setBrightness(roomID, ip, username, bri):
    if bri > 254:
        bri = 254
    elif bri < 0:
        bri = 0
    url = "http://"+ip+"/api/"+username+"/groups/"+roomID+"/action"
    body = '{"bri":'+str(bri)+'}'
    requests.put(url, body)

def setup():
    if path.exists("PALS.json"): #already set up
        with open("PALS.json", "r") as inFile:
            palsjson = json.load(inFile)
            ip = palsjson["ip"]
            username= palsjson["username"]
    else: 
    # Discover hue bridge and get its id and internal ip
        url = "https://discovery.meethue.com"
        response = requests.get(url)
        response = json.loads(response)
        ip = response["internalipaddress"]

        # set up a username
        url = "http://"+ip+"/api/"
        body = '{"devicetype":"PALS"}'

        while True:
            response = requests.post(url, body)
            response = (response.text).translate({ord(i): None for i in '[]'})
            palsjson = json.loads(response)
            if "error" in palsjson:
                print("Please press the link button your Philips Hue Bridge")
                input("Then Press ENTER to continue:")
            elif "success" in palsjson:
                username = palsjson["success"]["username"]
                print(username)
                break
    
        palsjson = {
            "ip": ip,
            "username": username
        }
        with open("PALS.json", "w") as outFile:
            json.dumps(palsjson, outFile)
    
    return palsjson


# pals = setup()
# ip = pals["ip"]
# username = pals["username"]

# setBrightness("3", ip, username, 2)