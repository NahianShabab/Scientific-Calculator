yacc -d -y -Wcounterexamples -o parser.c parser.y
flex -o scanner.c scanner.l
g++ -c parser.c
g++ -c scanner.c
g++ -o calculator scanner.o parser.o