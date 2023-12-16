import sys
import numpy as np
import pandas as pd

blksize = int(sys.argv[1])
syssize = int(sys.argv[2])
filename1 = sys.argv[3]
filename2 = sys.argv[4]
outfilename = sys.argv[5]

df1 = pd.read_csv(filename1, header=None)
df2 = pd.read_csv(filename2, header=None)

#print(df1)
#print(df2)

l1 = np.matrix(df1.values)
l2 = np.matrix(df2.values)

l3 = l1 * l2

print(l1)
print(l2)
print(l3)

matsize = l1.shape[0]
xi = int(l1.shape[0] / syssize)
yi = int(l1.shape[1] / syssize)
block = yi * matsize * xi
rest = blksize - block

print(matsize)
print(syssize)
print(blksize)
print(xi)
print(block)
print(rest)

if rest < 0:
	sys.exit(rest);


with open(outfilename, "w") as f1:
	# mat1
	for l in range(syssize):
		for k in range(xi):
			for j in range(xi):
				for i in range(matsize):
					f1.write("{0:08x}\n".format(l1[j+l*xi,i]))
				#f1.write("\n")
	
		for i in range(rest):
			f1.write("00000000\n")
		#f1.write("\n")
	
	# mat2
	for l in range(syssize):
		for k in range(xi):
			for j in range(xi):
				for i in range(matsize):
					f1.write("{0:08x}\n".format(l2[i,k+l*xi]))
				#f1.write("\n")
	
		for i in range(rest):
			f1.write("00000000\n")
		#f1.write("\n")
	
	# mat3

	for l in range(yi):
		for k in range(xi):
			for j in range(syssize):
				for i in range(syssize):
					f1.write("{0:08x}\n".format(l3[i+syssize*l,j+syssize*k]))



