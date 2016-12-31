#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <errno.h>
#include <netinet/in.h>
#include <sys/time.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

class Server{
public:
	Server();
	~Server();
	bool init();
	bool loop();
	enum MessageType {LOGIN, ADD_ONE, ADD_ALL, TRANSPOND,
	                  ADD_SUCCESSED, LOGIN_FAILURE, LOGIN_SUCCESSED,
	                  OFFLINE, TRANSPOND_SUCCESSED};
private:
	void handle(const char *data, int n);
	void splitData(const char *data, int n, int k, char *sub);
	struct sockaddr_in server_address;
	struct sockaddr_in client_address;
	fd_set readfds;
	int server_sockfd;
	int client_sockfd;
	int server_len;
	int client_len;
	int max_fd; // 当前最大套接字描述符
	char seg_char; // 数据分隔符
};
