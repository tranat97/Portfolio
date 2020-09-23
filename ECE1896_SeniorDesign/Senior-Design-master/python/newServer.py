import socket
import struct
import json
import os
import requests
from os import path
from house import house
from house import room
import numpy as np
import lightControl as LC
import matplotlib.pyplot as plt
#import requests

UDP_IP = "192.168.1.238"
UDP_PORT = 8080

sock = socket.socket(socket.AF_INET,
					  socket.SOCK_DGRAM) #using UDP

sock.bind((UDP_IP, UDP_PORT))
ledOn = True
distanceRoute1 = 0
distanceRoute2 = 0
distanceRoute3 = 0

#create initial setup of house
home = house()
home.add_room(room((1,47,1.73),3.5,3,2,True))
home.add_room(room((4.6,5.5),4.4,3.5,3,True))
home.add_room(room((1.49, 6.9),3.4,2.97,1,True))
home.add_access_point(0,0)
home.add_access_point(6.3,5.3)
home.add_access_point(0,7.6)

current_light = 0
past_light = 0

#if path.exists("PALS.json"): #already set up
#        with open("PALS.json", "r") as inFile:
 #           palsjson = json.load(inFile)
ip = "192.168.1.217"
username= "kzz6qJjwoNobWQzqKFsn4jXCq2PauKQDxukuI09B"

pals = LC.setup()
pals_ip = pals["ip"]
pals_user = pals["username"]
groups = LC.getGroups(pals_ip, pals_user)
x = []
y = []
light2 = False
light3 = False
light1 = False
plot_count = 0
while True:
	plot_count += 1
	data, addr = sock.recvfrom(2048)
	#data = struct.unpack("d",data)[0]
	info = data.split()
	#for phone hotspot
	
	distance = pow(10,(abs(float(info[1]))-14)/25)*0.1
	#distance = pow(10,(119.9 - float(info[5]))/60) - 2
	print("Distance from router ",info[4], " is: ",distance)
	
	if info[4]=="Tars1":
		distanceRoute1 = distance
	elif info[4]=="Tars2":
		distanceRoute2 = distance
	elif info[4]=="Tars3":
		distanceRoute3 = distance


	#use distances for coordinates
	coords = home.get_coordinate(distanceRoute1,distanceRoute2,distanceRoute3)
	x.append(coords[0])
	y.append(coords[1])
	print("x coordinate: " + str(coords[0]))
	print("y coordinate: " + str(coords[1]))
	#get the room & closest room center
	room = home.get_room(coords[0],coords[1])
	closest_room, dist = home.get_closest_room_center(coords[0],coords[1])

	#logic for switching on lights
	#if NOT in room
	# if room is None:
	# 	# if closest_room.light:
	# 	# 	if dist < 1.1*np.amin([closest_room.width, closest_room.length]):
	# 	# 		current_light = closest_room.ID
	# 	# 	else:
	# 	# 		current_light = 0
	# 	# else:
	# 	# 	current_light = 0
	# 	current_light = 0

	# else:
	# 	if room.light:
	# 		current_light = closest_room.ID
	# 	else:
	# 		current_light = 0

	current_light = closest_room.ID
	##SEND HTTP REQUEST HERE
	if distanceRoute1<distanceRoute2 and distanceRoute1<distanceRoute3 and not light2:
		##TURN OFF LIGHTS
		LC.turnOff(str(3), pals_ip, pals_user)
		LC.turnOff(str(1), pals_ip, pals_user)
		LC.turnOn(str(2), pals_ip, pals_user)
		light2 = True
		light3 = False
		light1 = False
	elif distanceRoute2<distanceRoute1 and distanceRoute2<distanceRoute3 and not light3:
		LC.turnOff(str(2), pals_ip, pals_user)
		LC.turnOff(str(1), pals_ip, pals_user)
		LC.turnOn(str(3), pals_ip, pals_user)
		light2 = False
		light3 = True
		light1 = False
	elif distanceRoute3<distanceRoute2 and distanceRoute3<distanceRoute1 and not light1:
		LC.turnOff(str(2), pals_ip, pals_user)
		LC.turnOff(str(3), pals_ip, pals_user)
		LC.turnOn(str(1), pals_ip, pals_user)
		light2 = False
		light3 = False
		light1 = True

	past_light = current_light

	# if distance > 4 and ledOn:
	# 	#url = "http://"+ip+"/api/"+username+"/groups/1/action"
	# 	#body = '{"on":false}'
	# 	#requests.put(url, body)
	# 	ledOn = False
	# 	#print "turn off you bitch"
	# elif distance<=4 and not ledOn:
	# 	#url = "http://"+ip+"/api/"+username+"/groups/1/action"
	# 	#body = '{"on":true}'
	# 	#requests.put(url, body)
	# 	ledOn = True
	# 	#print "turn on bitch"
	# #url = "http://"+ip+"/api/"+username+"/groups/1/action"
	# #body = '{"on":true}'
	# #requests.put(url,body)
	# #print "end"

	## Used to plot coordinates
	if plot_count == 300:
		plt.plot(x, y)
		plt.xlabel('x')
		plt.ylabel('y')
		plt.savefig("coordinate_graph")
		plt.clf()
#print data
