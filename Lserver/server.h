#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <netinet/in.h>
#include <sys/time.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <map>
#include <iostream>
using namespace std;

class Server{
public:
	Server();
	~Server();
	bool init();
	bool loop();
	enum MessageType {LOGIN, ADD_ONE, ADD_ALL, TRANSPOND,
	                  ADD_SUCCESSED, LOGIN_FAILURE, LOGIN_SUCCESSED,
	                  OFFLINE, TRANSPOND_SUCCESSED};
	struct DataStruct {
		DataStruct()
			: name("")
			, message("")
		{}
		string name;
		string message;
		MessageType mark;
	};
private:
	void handle(int fd, const DataStruct &data);
	void splitData(const string &str, int k, string &sub);
	void judgeFd(int fd);
	void tryLogin(int fd, const string &name);
	void tryAddAll(int fd, const string &name);
	void tryTranspond(const string &name, const string &message);
	void readData(int fd, DataStruct &data);
	void writeData(int fd, const DataStruct &data);
	void addToMap(int fd, const string &name);
	string removeFromMap(int fd);
	void disconnect(int fd);
	struct sockaddr_in server_address;
	struct sockaddr_in client_address;
	fd_set readfds;
	map<string, int> nameMapFd; // 映射用户名与套接字描述符
	map<int, string> fdMapName; // 映射用户名与套接字描述符
	int server_sockfd;
	int client_sockfd;
	int server_len;
	int client_len;
	int max_fd; // 当前最大套接字描述符
	char seg_char; // 数据分隔符
};
