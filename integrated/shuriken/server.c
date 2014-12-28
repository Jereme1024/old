#include <sys/types.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <stdio.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>

#define MAX_SIZE 512

int main(int argc, char *argv[])
{
    char buffer[MAX_SIZE];
	int sockfd;
	struct sockaddr_in serv_addr;

	sockfd = socket(AF_INET, SOCK_STREAM, 0);
	serv_addr.sin_family = AF_INET;
	serv_addr.sin_port = htons(1339);
	serv_addr.sin_addr.s_addr = INADDR_ANY;

	//bind socket
	if   ( bind(sockfd, (struct sockaddr*)&serv_addr, sizeof(serv_addr)) == -1 ){
	    printf("bind error!\n");
        exit(1);
    }
    //listen
	if   ( listen(sockfd, 5) ==-1 ){
	    printf("listen error!\n");
        exit(1);
    }
	printf("after listening..\n");
	
	struct sockaddr_in client_addr[2];
	int nLen = sizeof(client_addr);
	int clientfd[2];
	
	int i;
	for(i=0;i<2;i++){
		printf("Accepting...\n");
		clientfd[i] = accept(sockfd, (struct sockaddr*)&client_addr[i], &nLen);
		
		if(clientfd[i]==-1){
			printf("Accept connection error!\n");
			return -1;
		}
	}
	
    //0=> controller  1=> game
	while( recv(clientfd[0], buffer, MAX_SIZE, 0) != -1 ){//receive message
        if(strlen(buffer)>3){
			printf("Receive: %s\n",buffer);

			if(strcmp(buffer,"exitprog")==0){
				break;
			}else{
				printf("Send: %s\n",buffer);
				send(clientfd[1], buffer, MAX_SIZE, 0);//Send message
			}
		}

    }

	close(sockfd);
	for(i=0;i<2;i++){
		close(clientfd[i]);
	}

	return 0;
}
