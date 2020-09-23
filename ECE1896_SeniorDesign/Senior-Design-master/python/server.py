import socket
import struct
import json
import os
import requests
from os import path
#import requests

UDP_IP = "192.168.1.238"
UDP_PORT = 8080

sock = socket.socket(socket.AF_INET,
					  socket.SOCK_DGRAM) #using UDP

sock.bind((UDP_IP, UDP_PORT))
ledOn = True;


#if path.exists("PALS.json"): #already set up
#        with open("PALS.json", "r") as inFile:
 #           palsjson = json.load(inFile)
ip = "192.168.1.217"
username= "kzz6qJjwoNobWQzqKFsn4jXCq2PauKQDxukuI09B"

while True:
	data, addr = sock.recvfrom(2048)
	#data = struct.unpack("d",data)[0]
	info = data.split()
	#print info[0],info[1],info[2],info[3]
	#print info[8]
	#distance = pow(10,(119.9 - float(info[8]))/60)
	#print "Distance from router ",info[0],info[1],info[2],info[3], " is: ",distance
	
	#for phone hotspot
	if info[0] == "*":
		distance = pow(10,(119.9 - float(info[6]))/60) - 2
		print "Distance from router ",info[1], " is: ",distance

		if distance > 4 and ledOn:
			 #url = "http://"+ip+"/api/"+username+"/groups/1/action"
			 #body = '{"on":false}'
			 #requests.put(url, body)
			 ledOn = False;
			 print "turn off you bitch"
		elif distance <=4 and not ledOn:
			 #url = "http://"+ip+"/api/"+username+"/groups/1/action"
			 #body = '{"on":true}'
			 #requests.put(url, body)
			 ledOn = True;
			 print "turn on you bitch"
	else:
		distance = pow(10,(119.9 - float(info[5]))/60) - 2
		print "Distance from router ",info[0], " is: ",distance
	
		if distance > 4 and ledOn:
			#url = "http://"+ip+"/api/"+username+"/groups/1/action"
			#body = '{"on":false}'
			#requests.put(url, body)
			ledOn = False;
			print "turn off you bitch"
		elif distance<=4 and not ledOn:
			#url = "http://"+ip+"/api/"+username+"/groups/1/action"
			#body = '{"on":true}'
			#requests.put(url, body)
			ledOn = True;
			print "turn on bitch"
		#url = "http://"+ip+"/api/"+username+"/groups/1/action"
		#body = '{"on":true}'
		#requests.put(url,body)
	#print data
