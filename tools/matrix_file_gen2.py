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


param_size = 2 + 2*syssize*3 + 2 + syssize*syssize*3*2 + 3

itter_size = int(matsize / syssize)
mem_interval = matsize * itter_size * itter_size
print(itter_size)
print(mem_interval)
print(param_size)

dc = mem_interval - 1
#print("#immdefine imm_dma_dc 0x{0:03x}".format(dc))
io_start = 0
io_interval = 0x1000

mem_start = param_size * 4
write_cntr = syssize * 2
read_cntr = syssize * syssize

# make matrix data
with open(outfilename, "w") as f1:

	f1.write("{0:08x}\n".format(write_cntr)) # paramter : write cntr
	f1.write("{0:08x}\n".format(read_cntr)) # paramter : read cntr
	
	for i in range(2*syssize):
		f1.write("{0:08x}\n".format(io_start)) # 1st paramter : io start address
		io_start += io_interval
		#f1.write("#immdefine imm_mem_start{0} 0x{1:03x}".format(i,mem_start))
		f1.write("{0:08x}\n".format(mem_start)) # 2nd paramter : memory start address
		mem_start += mem_interval * 4
		f1.write("{0:08x}\n".format(dc)) # 3rd paramter : dma counter : size - 1
	
	max_cntr = matsize - 1
	f1.write("{0:08x}\n".format(max_cntr)) # 1st paramter : max cntr
	run_cntr = itter_size * itter_size
	f1.write("{0:08x}\n".format(run_cntr)) # 2nd paramter : run cntr
	
	dc_s = itter_size * itter_size
	#f1.write("#immdefine imm_dma_dc_s 0x{0:03x}".format(dc_s))
	dc_s_2 = int(dc_s / 16)
	dc_s_2 += 1 if (dc_s_2 == 0) else 0
	#f1.write("#immdefine imm_dma_dc_s_2 0x{0:03x}".format(dc_s_2))
	
	io_start = 0x80000
	io_interval = 0x800
	
	for i in range(syssize*syssize):
		f1.write("{0:08x}\n".format(io_start)) # 1st paramter : io start address
		f1.write("{0:08x}\n".format(mem_start)) # 2nd paramter : memory start address
		f1.write("{0:08x}\n".format(dc_s)) # 3rd paramter : dma counter : size - 1
		mem_start += dc_s * 4
		io_start += io_interval
	
	io_start = 0x80400
	io_interval = 0x800
	
	for i in range(syssize*syssize):
		f1.write("{0:08x}\n".format(io_start)) # 1st paramter : io start address
		f1.write("{0:08x}\n".format(mem_start)) # 2nd paramter : memory start address
		f1.write("{0:08x}\n".format(dc_s_2)) # 3rd paramter : dma counter : size - 1
		mem_start += 8 if dc_s_2 == 1 else dc_s_2
		io_start += io_interval
	
	mem_start += 3 * 4
	
	f1.write("{0:08x}\n".format(mem_start)) # check paramter : test data memory start address
	#f1.write("#immdefine imm_answer_start 0x{0:03x}".format(mem_start))
	mem_start += matsize * matsize * 4
	f1.write("{0:08x}\n".format(mem_start)) # check paramter : memory start address
	#f1.write("#immdefine imm_result_start 0x{0:03x}".format(mem_start))
	check_size = matsize * matsize - 1
	f1.write("{0:08x}\n\n".format(check_size)) # check paramter : check size
	#f1.write("#immdefine imm_check_cntr 0x{0:03x}".format(check_size))
	
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



