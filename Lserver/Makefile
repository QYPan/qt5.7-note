obj = main.o server.o

server : $(obj)
	g++ -o server $(obj) -g
server.o : server.cpp server.h
	g++ -c -std=c++11 -Wall server.cpp -g
main.o : main.cpp server.h
	g++ -c -std=c++11 -Wall main.cpp -g
.PHONY : clean
clean :
	rm server $(obj)
