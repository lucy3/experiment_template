"""
Converts stimuli to a javascript dictionary
"""

def main(): 
    d = {}
    with open('long_short_words-materials.txt', 'r') as inputfile: 
        current = None
        meta = None
        context = None
        order = None
        for line in inputfile:
            if line.startswith('#'):
                contents = line.split()
                current = contents[1] + ' ' + contents[2]
                if contents[1] == 'LongShort':
                    ID = int(contents[2])
                    meta = contents[3].split('_')
                    context = meta[0]
                    order = meta[1]
                else: # filler
                    ID = int(contents[2])
                if current not in d:
                    d[current] = {}
            elif line.startswith('1.'):
                contents = line.strip().split('  ')
                if current.startswith('LongShort'):
                    if order == 'shortfirst':
                        d[current]['  choice1'] = contents[0].strip().replace('1. ', '')
                        d[current]['  choice2'] = contents[-1].strip().replace('2. ', '')
                else: # filler
                    d[current]['  choice1'] = contents[0].strip().replace('1. ', '')
                    d[current]['  choice2'] = contents[-1].strip().replace('2. ', '')
            elif line.startswith('?'):
                question = line.strip().split('?')[1].strip() + '?'
                if current.startswith('LongShort'):
                    if context == 'supp':
                        d[current]['  supportiveQ'] = question
                    else:
                        d[current]['  neutralQ'] = question
                else: # filler
                    d[current]['  comp_q'] = question
            elif line.strip() != '':
                if current.startswith('LongShort'):
                    if context == 'supp':
                        d[current]['  supportive'] = line.strip()
                    else:
                        d[current]['  neutral'] = line.strip()
                else: # filler
                    d[current]['  context'] = line.strip()
    for key in sorted(d.keys()): 
        print "\"" + key + "\"", ":", "{"
        for k in d[key]:
            print k, ':', "\"" + d[key][k] + "\","
        print "},"



if __name__ == '__main__':
    main()