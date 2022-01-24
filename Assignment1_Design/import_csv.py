

import os
file = open('import_csv.sql', 'w')

def query(name:str):
    n = ''
    for i in name:
        if(i.upper()==i):n+='_'
        n+=i.lower()
    n += '.csv'
    with open(n, 'r+') as f:
        args = f.readline()[:-1]


    lines = [
        f'COPY {name}({args})\n',
        f'FROM \'{os.getcwd()}/{n}\'\n',
        'DELIMITER \',\' \n',
        'CSV HEADER;\n\n'
    ]

    return ''.join(lines)

r = open('create_table.sql', 'r+')
for l in r.readlines():
    line = l.replace('\n', '').replace(' (', '').replace('(','').split(' ')
    if(line[0] == 'CREATE'):
        file.write(query(line[-1]))

