import numpy as np

l1 = np.matrix([[1, 2, -3, 4], [5, -6, 7, -8], [9, -11, -10, 12], [14, -15, -12, 0]])
l2 = np.matrix([[4, 0, 9, -8], [-3, -8, -2, 0], [2, 3, -2, 5], [-7, 6, 2, -3]])

l3 = l1 * l2

print(l1)
print(l2)
print(l3)