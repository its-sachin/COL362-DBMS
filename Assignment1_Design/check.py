f1 = open('out.txt','r+')
f2 = open('out1.txt','r+')

# vals = {i:[0,0] for i in range(1950,2022)}
# for line in f1.readlines():
#     l = line.split('|')
#     try:
#         for i in range(len(l)):l[i]=int(l[i].strip())
#         if(vals[l[0]][1] < l[2]):vals[l[0]] = l[1:]
#     except:pass
# for i in vals:print(i,vals[i])

# winner = {}; i = 0
# for line in f1.readlines():
#     l = line.strip().split('\n')[0]
#     try:
#         winner[int(l)] = i
#     except:pass
#     i+=1

# for line in f2.readlines():
#     l = line.split('|')
#     try:
#         for i in range(len(l)):l[i]=int(l[i].strip())
#         v =l[0]
#     except:continue
#     if(winner.get(v)!=None):print(v,winner[v])


# count = {}
# for line in f1.readlines():
#     l = line.split('|')
#     try:
#         for i in range(len(l)):l[i]=int(l[i].strip())
#         key = f'{l[0]}_{l[1]}'
#         if(count.get(key)==None):count[key]=1
#         else:count[key]+=1
#     except:pass

# for line in f2.readlines():
#     l = line.split('|')
#     try:
#         for i in range(len(l)):l[i]=int(l[i].strip())
#         key = f'{l[0]}_{l[1]}'
#     except:continue
#     if(count.get(key)==None or count[key] != l[2]):print(key,count[key],l[2])

# f1 = open('outsql.txt','r+')
# f2 = open('outpy.txt','r+')

# l1 = []
# for l in f1.readlines():
#     line = l.strip().split('|')
#     for i in range(len(line)):line[i]=line[i].strip()
#     l1.append(line)

# l2 = []
# for l in f2.readlines():
#     line = l.strip().split('|')
#     for i in range(len(line)):line[i]=line[i].strip()
#     l2.append(line)

# for i in range(min(len(l1),len(l2))):
#     if(l1[i]!=l2[i]):print(i,l1[i],l2[i]);break


l1 = f1.readlines()
l2 = f2.readlines()

if(len(l1)!=len(l2)):print('LEN UNEQUAL')
for i in range(min(len(l1),len(l2))):
    if(l1[i]!=l2[i]):
        print('NOT EQUAL AT:',i)
        print(l1[i])
        print(l2[i])
    else:print('EQUAL AT',i)