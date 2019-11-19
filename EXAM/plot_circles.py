import matplotlib.pyplot as plt
import numpy as np
import csv

with open('text(3).txt','r') as f:
    data = f.read()
data = data.split('\n')
data.pop()
data.pop()
x = [raw.split(',')[0] for raw in data]
y = [raw.split(',')[1] for raw in data]

with open('circ.txt','r') as f:
    data1 = f.read()
data1 = data1.split('\n')
data1.pop()
data1.pop()
p = [raw.split(',')[0] for raw in data1]
q = [raw.split(',')[1] for raw in data1]

z=[x,y,p,q]
z=list(map(list, zip(*z)))
head=["X","Y","theta","radius"]

with open('cir.csv', 'w') as writeFile:
    writer = csv.writer(writeFile)
    writer.writerow(head)
    writer.writerows(z)
writeFile.close()

plt.plot(x, y, 'b*')
plt.show()
