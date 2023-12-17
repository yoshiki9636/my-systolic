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
for j in range(6):
	for i in range(6):
		k = l3[i,j]
		k = k + 0x1000 if k<0 else k
		print("{0:04x}".format(k))

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
					value = l1[j+l*xi,i]
					if (value < 0):
						value += 0x10000
					f1.write("{0:08x}\n".format(value))
				f1.write("\n")
	
		for i in range(rest):
			f1.write("00000000\n")
		f1.write("\n")
	
	# mat2
	for l in range(syssize):
		for k in range(xi):
			for j in range(xi):
				for i in range(matsize):
					value = l2[i,k+l*xi]
					if (value < 0):
						value += 0x10000
					f1.write("{0:08x}\n".format(value))
				f1.write("\n")
	
		for i in range(rest):
			f1.write("00000000\n")
		f1.write("\n")
	
	# mat3

	for l in range(syssize):
		for k in range(syssize):
			for j in range(yi):
				for i in range(xi):
					value = l3[i+xi*l,j+yi*k]
					if (value < 0):
						value += 0x10000
					f1.write("{0:08x}\n".format(value))



