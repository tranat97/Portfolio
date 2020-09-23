from house import house
from house import room
import sys

if __name__ == "__main__":
    test_house = house()

    while True:
        print("1. Add room")
        print("2. Get room from coordinate")
        print("3. Get closest room center from coordinate")
        print("4. List all rooms")
        print("5. exit")
        choice = int(input())

        if choice == 1:
            x = int(input("enter top left x "))
            y = int(input("enter top left y "))
            tl = (x,y)

            x = int(input("enter top right x "))
            y = int(input("enter top right y "))
            tr = (x,y)

            x = int(input("enter bottom left x "))
            y = int(input("enter bottom left y "))
            bl = (x,y)

            x = int(input("enter bottom right x "))
            y = int(input("enter bottom right y "))
            br = (x,y)

            name = input("enter the name of the room ")

            test_house.add_room(room(tl,tr,bl,br,name))
            

        elif choice == 2:
            x = int(input("enter x "))
            y = int(input("enter y "))
            room = test_house.get_room(x,y)
            if room is not None:
                print(room.name)
            else:
                print("not in any rooms")

        elif choice == 3:
            x = int(input("enter x "))
            y = int(input("enter y "))
            room = test_house.get_closest_room_center(x,y)
            if room is not None:
                print(room.name)
            else:
                print("no rooms")
        
        elif choice == 4:
            test_house.list_rooms()

        elif choice ==5:
            test_house.save_house()
            sys.exit()

        else:
            print("enter a valid num")





