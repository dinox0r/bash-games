colors = ['black', 'red', 'green', 'yellow', 'blue', 'magenta', 'cyan', 'white']; 
index = 0
for x in [ "{0}_FONT_{1}_BACK='\E[{2};{3}m'".format(colors[i].upper(), colors[j].upper(), i + 30, j + 40) for i in xrange(0, 8) for j in xrange(0, 8) ]: 
    print x.ljust(38) + "#" + str(index) 
    index += 1
