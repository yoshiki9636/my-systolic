import sys
import numpy as np
import pandas as pd

#blksize = int(sys.argv[1])
syssize = int(sys.argv[1])
filename1 = sys.argv[2]
filename2 = sys.argv[3]
outfilename = sys.argv[4]

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
#rest = blksize - block

print(matsize)
print(syssize)
#print(blksize)
print(xi)
print(block)
#print(rest)

#if rest < 0:
	#sys.exit(rest);

# make immdefine
itter_size = int(matsize / syssize)
mem_interval = matsize * itter_size * itter_size
dc = mem_interval - 1
print("#immdefine imm_dma_dc 0x{0:03x}".format(dc))
mem_start = 0
for i in range(2*syssize):
	print("#immdefine imm_mem_start{0} 0x{1:03x}".format(i,mem_start))
	mem_start += mem_interval * 4

max_cntr = matsize - 1
print("#immdefine imm_max_cntr 0x{0:03x}".format(max_cntr))
run_cntr = itter_size * itter_size
print("#immdefine imm_run_cntr 0x{0:03x}".format(run_cntr))

print("#immdefine imm_answer_start 0x{0:03x}".format(mem_start))
mem_start += matsize * matsize * 4
print("#immdefine imm_result_start 0x{0:03x}".format(mem_start))
check_size = matsize * matsize - 1
print("#immdefine imm_check_cntr 0x{0:03x}".format(check_size))

dc_s = itter_size * itter_size
print("#immdefine imm_dma_dc_s 0x{0:03x}".format(dc_s))
dc_s_2 = int(dc_s / 16)
dc_s_2 += 1 if (dc_s_2 == 0) else 0
print("#immdefine imm_dma_dc_s_2 0x{0:03x}".format(dc_s_2))

for i in range(2*syssize):
	print("#immdefine imm_mem_start_s{0} 0x{1:03x}".format(i,mem_start))
	mem_start += dc_s * 4

for i in range(2*syssize):
	print("#immdefine imm_mem_start_s{0}s 0x{1:03x}".format(i,mem_start))
	mem_start += 8 if dc_s_2 == 1 else dc_s_2


# make matrix data
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
	
		#for i in range(rest):
			#f1.write("00000000\n")
		#f1.write("\n")
	
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
	
		#for i in range(rest):
			#f1.write("00000000\n")
		#f1.write("\n")
	
	# mat3

	for l in range(syssize):
		for k in range(syssize):
			for j in range(yi):
				for i in range(xi):
					value = l3[i+xi*l,j+yi*k]
					if (value < 0):
						value += 0x10000
					f1.write("{0:08x}\n".format(value))



