obj = main.o server.o

server : $(obj)
	g++ -o server $(obj) -g
server.o : server.cpp server.h
	g++ -c -Wall server.cpp -g
main.o : main.cpp server.h
	g++ -c -Wall main.cpp -g
.PHONY : clean
clean :
	rm server $(obj)
