from house import house
from house import room
import unittest
import matplotlib.pyplot as plt

class TestHouseMethods(unittest.TestCase):

    # need to get this working, might switch to pytest
    # def setUpModule():
    #     test_house = house()

    def test_add_room(self):
        test_house = house()
        test_house.add_room(room((1,1),2,2,1))

        self.assertEqual(len(test_house.rooms), 1)

    def test_add_rooms(self):
        test_house = house()
        test_house.add_room(room((1,1),2,2,1))
        test_house.add_room(room((3.5,3.5),1,1,2))
        self.assertEqual(len(test_house.rooms), 2)

    def test_in_room(self):
        test_house = house()
        test_house.add_room(room((1,1),2,2,1))
        test_house.add_room(room((3.5,3.5),1,1,2))
        self.assertEqual(test_house.get_room(1,1).ID, 1)

    def test_closest_center(self):
        test_house = house()
        test_house.add_room(room((1,1),2,2,1))
        test_house.add_room(room((3.5,3.5),1,1,2))
        test_house.save_house()
        self.assertEqual(test_house.get_closest_room_center(3,3)[0].ID, 2)

    def test_room_center(self):
        test_room = room((2.5,2.5),5,5,1)
        self.assertEqual(test_room.center, (2.5, 2.5))


    def test_add_wifi(self):
        test_house = house()
        test_house.add_access_point(1,1)
        self.assertEqual(len(test_house.access_points), 1)

    def test_add_wifis(self):
        test_house = house()
        test_house.add_access_point(1,1)
        test_house.add_access_point(2,2)
        test_house.add_access_point(3,3)
        self.assertEqual(len(test_house.access_points), 3)

    def test_max_wifis(self):
        test_house = house()
        test_house.add_access_point(1,1)
        test_house.add_access_point(2,2)
        test_house.add_access_point(3,3)
        with self.assertRaises(Exception):
            test_house.add_access_point(4,4)

    def test_coordinate_calc(self):
        test_house = house()
        test_house.add_access_point(0,0)
        test_house.add_access_point(16,0)
        test_house.add_access_point(8,16)
        result = test_house.get_coordinate(10,10,10)

        plt.plot(result[0], result[1], 'bo')
        plt.plot(test_house.access_points[0].x, test_house.access_points[0].y, 'ro')
        plt.plot(test_house.access_points[1].x, test_house.access_points[1].y, 'ro')
        plt.plot(test_house.access_points[2].x, test_house.access_points[2].y, 'ro')
        plt.xlabel('x')
        plt.ylabel('y')
        plt.savefig("location_test")
        plt.clf()
        test_house.save_house('load_test.txt')
        house_2 = house.load_house('load_test.txt')
        self.assertEqual(result[0], 8)
        self.assertEqual(result[1], 6)
if __name__ == "__main__":
    unittest.main()
