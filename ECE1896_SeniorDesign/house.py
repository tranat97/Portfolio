import math
import json
import numpy as np

class house:
    def __init__(self):
        self.rooms = []
        self.access_points = []

    def add_room(self, new_room):
        self.rooms.append(new_room)

    def get_room(self, x, y):
        for room in self.rooms:
            if x > room.center[0]-room.width/2 and x < room.center[0]+room.width/2 and y > room.center[1]-room.length/2 and y < room.center[1]+room.length/2:
                return room
        return None

    def get_closest_room_center(self, x, y):
        min = float("inf")
        index = 0
        min_index = None
        for room in self.rooms:
            center = room.center
            distance = math.sqrt((x-center[0])**2 + (y-center[1])**2)
            if distance < min:
                min = distance
                min_index = index
            index += 1
        if min_index == None:
            return None
        return self.rooms[min_index], min

    def list_rooms(self):
        for room in self.rooms:
            print(room.ID + ":")
            print("center" + str(room.center))
            print("height" + str(room.height))
            print("width" + str(room.width))
            print()

    def save_house(self, filepath="home.txt"):
        f = open(filepath, "w")
        for room in self.rooms:
            f.write(str(room.ID)+":"+str(room.center)+","+str(room.width)+","+str(room.length)+","+str(room.light)+"\n")
        for ap in self.access_points:
            f.write(str(ap.x)+','+str(ap.y)+'\n')
        f.close()

    @staticmethod
    def load_house(filepath="home.txt"):
        home = house()
        with open(filepath, 'r') as f:
            lines = f.readlines()
            for line in lines:
                house_traits = line.split(':')
                if len(house_traits) == 2:
                    data = house_traits[1].split(',')
                    home.add_room(room(data[0], data[1], data[2], house_traits[0], data[3]))
                else:
                    ap = house_traits[0].split(',')
                    home.add_access_point(ap[0], ap[1][0:len(ap[1])-1])
        return home


    def add_access_point(self, x, y):
        if len(self.access_points) == 3:
            raise Exception("Only 3 access points supported")
        self.access_points.append(access_point(x,y))


    def get_coordinate(self, dist1, dist2, dist3):
        x1 = self.access_points[0].x
        x2 = self.access_points[1].x
        x3 = self.access_points[2].x
        y1 = self.access_points[0].y
        y2 = self.access_points[1].y
        y3 = self.access_points[2].y

        x41 = 2*(x2-x1)
        x42 = 2*(y2-y1)
        x43 = (x1**2 - x2**2) + (y1**2-y2**2) - (dist1**2-dist2**2)
        y41 = 2*(x3-x1)
        y42 = 2*(y3-y1)
        y43 = (x1**2 - x3**2) + (y1**2-y3**2) - (dist1**2-dist3**2)

        arr1 = np.array([[x41,x42,x43],[y41,y42,y43],[1,1,1]])
        arr2 = np.array([0,0,1])
        result = np.linalg.solve(arr1, arr2)
        return result/result[2]

class room:
    def __init__(self, center, length, width, ID, light=False):
        self.center = center
        self.length = length
        self.width = width
        self.light = light
        self.ID = ID

class access_point:
    def __init__(self, x, y):
        self.x = x
        self.y = y
