import numpy as np

l1 = np.matrix([[1, 2, 3, 4], [5, 6, 7, 8], [9, 0xa, 0xb, 0xc], [0xd, 0xe, 0xf, 0]])
l2 = np.matrix([[4, 3, 2, 7], [0, 8, 3, 6], [9, 2, 2, 2], [8, 0, 5, 3]])

l3 = l1 * l2

print(l1)
print(l2)
print(l3)
