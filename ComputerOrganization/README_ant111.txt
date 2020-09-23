Full Name: Andrew Tran
username: ant111

I call a method "createTriangles" in a set of nested loops. 
The loops go through every number in the triangle and sets them as the apex of a subtriangle.
It also determines which row that number would be in the triangle.
The row number determines how many numbers are skipped to get to the next row 
   (3 numbers are skipped after any number on the 3rd row to get to the 4th row).
The createTriangles method finds the sum of every subtriangle possible given a specific apex number (using another set of nested loops). 
Every time a sum is calculated it checks whether that sum is the new min.

This algorithm passed all given test cases. It also passed test cases of all -1, 1, or 0.
I tried running the euler_150 test, but after 5-10 minutes it did not finish.