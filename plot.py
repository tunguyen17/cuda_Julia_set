import numpy as np
import matplotlib.pyplot as plt
import matplotlib.cm as cm
import sys



f = open("test.txt", 'r')
data_str = f.read().split(" ")[:-1]

# Manipulate data
data = np.array(data_str)
data = data.astype(int)

dim = int(sys.argv[1]) if len(sys.argv) > 1 else 1000
data = data.reshape(dim, dim)

# plt.gray()
plt.imshow(data)
plt.savefig('test.png', dpi=1000)

print("Plot exported", dim, " x ", dim);
# plt.show()
