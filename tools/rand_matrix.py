import sys
import random

matrixsize = int(sys.argv[1])
r = int(sys.argv[2])

for j in range(matrixsize):
	for i in range(matrixsize):
		if i == matrixsize - 1:
			print(random.randrange(-r,r))
		else:
			print(random.randrange(-r,r),end=", ")
		


