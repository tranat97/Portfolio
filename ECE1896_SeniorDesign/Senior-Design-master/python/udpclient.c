// Skeleton udp-client code for senior design
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <string.h>
#include <fcntl.h>
#include <wiringPi.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>

#define PORT     8080
#define MAXLINE  2048

void termination_handler(int sig){
    printf("Program Terminated");
    exit(1);
}

// Driver code
int main() {
    int sockfd;
    char *buffer;
    size_t len = MAXLINE;
    size_t read = 0;
    double data = 1;
    struct sockaddr_in servaddr;
    FILE *fp; //file pointer

    //signal handler
    signal(SIGTERM,termination_handler);

    // Creating socket file descriptor
    if ( (sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0 ) {
        perror("socket creation failed");
        exit(EXIT_FAILURE);
    }

    memset(&servaddr, 0, sizeof(servaddr));

    // Filling server information
    servaddr.sin_family = AF_INET;
    servaddr.sin_port = htons(PORT);
    servaddr.sin_addr.s_addr = inet_addr("192.168.1.238"); //using INADDR_ANY for now
                                           //will change this to the actual address in the future
    //int n, len;
    buffer = (char *)malloc(len*sizeof(char));
    //char *command = "sudo iw dev wlan0 scan | egrep \"signal:|SSID:\" | sed -e \"s/\\t signal: //\" -e \"s/\\t SSID: //\" | awk '{ORS = (NR % 2 == 0)? \"\\n\" : \" \"; print}' | grep Tars > test.txt";

    while(1){
        //command to create signal strength file
        system("sudo iw dev wlan0 scan | egrep \"signal:|SSID:\" | sed -e \"s/\\t signal: //\" -e \"s/\\t SSID: //\" | awk '{ORS = (NR % 2 == 0)? \"\\n\" : \" \"; print}' | grep Tars > test.txt");
	    //system("sudo nmcli device wifi list | grep Tars > test.txt");
        //system("sudo nmcli device wifi list --rescan yes| grep Tars > test.txt");
        //open file
	fp = fopen("test.txt","r");
	//get file info
	//fseek(fp,0,SEEK_END);
	//feek(fp,0,SEEK_SET);
	//start reading the file
	//fread(buffer,file_size,1,fp);
	//keep reading the file until the end
	while(read = getline(&buffer,&len,fp) != -1){
	    sendto(sockfd, buffer, MAXLINE,
		MSG_CONFIRM, (const struct sockaddr *) &servaddr,
		    sizeof(servaddr));
	    printf("%s",buffer);
	}
	//send info in file to the server

        //keep sending the location data to the sever
        //sendto(sockfd, &data, sizeof(data),
        //    MSG_CONFIRM, (const struct sockaddr *) &servaddr,
        //        sizeof(servaddr));

	//close file
	fclose(fp);
	//printf("Data sent.\n");
	//system("sudo nmcli device wifi rescan");
        //let program sleep and send the data again
        usleep(200);
        //data+=1.1;
    }
    close(sockfd);
    free(buffer);
    return 0;
}
