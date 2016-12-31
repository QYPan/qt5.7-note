#include "server.h"

Server::Server()
{
	server_address.sin_family = AF_INET;
	server_address.sin_addr.s_addr = htonl(INADDR_ANY);
	server_address.sin_port = htons(9734);
	server_len = sizeof(server_address);
	seg_char = '#';
}

Server::~Server(){
}

bool Server::init(){
	server_sockfd = socket(AF_INET, SOCK_STREAM, 0);
	if(server_sockfd == -1){
		perror("socket");
		return false;
	}
	if(bind(server_sockfd, (struct sockaddr *)&server_address, server_len) == -1){
		perror("bind");
		return false;
	}
	if(listen(server_sockfd, 5) == -1){
		perror("listen");
		return false;
	}
	FD_ZERO(&readfds);
	FD_SET(server_sockfd, &readfds);
	max_fd = server_sockfd;
	printf("listen successed!\n");
	return true;
}

void Server::judgeFd(int fd){
	if(fd == server_sockfd){ // 新连接
		client_len = sizeof(client_address);
		client_sockfd = accept(server_sockfd,
				(struct sockaddr *)&client_address, (socklen_t *)&client_len);
		FD_SET(client_sockfd, &readfds);
		if(client_sockfd > max_fd) max_fd = client_sockfd;
	}else{ // 肯定是客户请求
		int nread;
		ioctl(fd, FIONREAD, &nread); // 检查套接字缓存有无数据可读
		if(nread == 0){
			close(fd);
			FD_CLR(fd, &readfds);
		}else{
			char data[2000];
			read(fd, data, sizeof(data));
			handle(fd, data, strlen(data));
		}
	}
}

bool Server::loop(){
	while(true){
		fd_set testfds = readfds; // select 调用会改变 readfds，故需用中间变量
		printf("server waiting\n");

		int activity = select(max_fd+1, &testfds, (fd_set *)0,
				              (fd_set *)0, (struct timeval *)0);
		if(activity < 1){
			perror("server");
			return false;
		}

		for(int fd = 0; fd <= max_fd; fd++){
			if(FD_ISSET(fd, &testfds)){
				judgeFd(fd);
			}
		}
	}
}

// 获取字符串 data 以 seg_char 为分隔符的第 k 段，k 为 0，1，2
void Server::splitData(const char *data, int n, int k, char *sub){
	if(data == NULL)
		return;
	int count = 0;
	int beg = 0;
	for(int i = 0; i < n; i++){
		if(data[i] == seg_char || i == n-1){
			if(count == k){
				strncpy(sub, data+beg, i-beg);
				sub[i-beg] = '\0';
				return;
			}else{
				beg = i + 1;
				count++;
				if(count == 2)
					break;
			}
		}
	}
	if(beg == n) strcpy(sub, "");
	else strcpy(sub, data+beg);
}

void Server::handle(int fd, const char *data, int n){
	char name[100];
	char message[2000];
	MessageType mark;
	char tmp_mark[2];
	splitData(data, n, 0, name);
	splitData(data, n, 1, tmp_mark);
	splitData(data, n, 2, message);
	mark = static_cast<MessageType>(tmp_mark[0]-'0');
	if(mark == LOGIN){
		tryLogin(fd, name);
	}
}

void Server::tryLogin(int fd, const char *name){
	//string str_name(name);
	cout << name << endl;
	//cout << fd << endl;
}
