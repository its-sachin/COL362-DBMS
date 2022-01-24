def create():
    f = open('2019CS10722.sql','r+')
    out = open('time.sql','w')
    for l in f.readlines():
        out.write(l)
        if(l[0]=='-'):out.write('EXPLAIN ANALYZE\n')

def plot():
    f = open('time.txt','r+')
    times = []
    for l in f.readlines():
        line = l.strip().split(':')
        if(line[0] == 'Execution Time'):
            times.append(float(line[1][:-3]))

    from matplotlib import pyplot as plt
    plt.figure(figsize=(12, 8))
    plt.xlabel('Query #')
    plt.ylabel('Time (ms)')
    plt.xticks([i for i in range(1,21)])
    plt.grid(b = True, color ='grey', linestyle ='-.', linewidth = 0.5, alpha = 0.2)
    ax = plt.bar([i for i in range(1,21)],times)

    rects = ax.patches

    for rect, label in zip(rects, times):
        height = rect.get_height()
        plt.text(
            rect.get_x() + rect.get_width() / 2, height, label, ha="center", va="bottom"
        )
        
    plt.title('Query vs Time Bas Graph')
    plt.show()

plot()