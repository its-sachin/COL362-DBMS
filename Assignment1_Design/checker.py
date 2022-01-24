class Table:
    def __init__(self, name) -> None:
        file = ''
        for i in name:
            if(i.upper()==i):file+='_'
            file+=i.lower()
        file += '.csv'
        file = open(file,'r+')
        table = []
        for line in file.readlines():
            l = line.strip('\n').split(',')
            table.append(l)
    
r = open('create_table.sql', 'r+')
tables = {}
for l in r.readlines():
    line = l.replace('\n', '').replace(' (', '').replace('(','').split(' ')
    if(line[0] == 'CREATE'):
        name = line[-1]
        tables[name] = Table(name)

print(tables)
