import sys

if len(sys.argv) < 2:
    print('argumentos faltando')

else:
    with open(sys.argv[1]) as fp:
        lista = []
        for cnt, line in enumerate(fp):
            tokens = line.split(';')
            lista.append(tokens)
            
        
        for row in lista:
            
    
            click("1620298079908.png")
            type(row[0])
            click("1620298094938.png")
            type(row[1])
            click("1620298110412.png")
            type(row[2])
            click("1620298124748.png")