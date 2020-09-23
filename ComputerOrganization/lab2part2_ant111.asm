.data

x: .half 15
y: .half 6
z: .half 0

.text
lh $t0, x
lh $t1, y
sub $t2, $t0, $t1 
sh $t2,z
lh $t2, 4($at)
sh $t2, x
sh $t2, y


