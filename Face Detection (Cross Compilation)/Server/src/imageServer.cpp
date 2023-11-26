/**
 * @file imageServer.cpp
 * @brief Server side C++ program
 * @author Shayan Eram
 *
 * This code is a TCP server that accepts image data from clients and sends compressed images over the network.
 */
#include "imageCapture.cpp"	// Including video capture code
#include <iostream>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>
#include <fstream>
#include <string>

#include "../commun/imageCommun.h"

using namespace std;

/**
 * @brief Function to capture image and send it to the client.
 *
 * This function captures an image from the webcam using OpenCV and sends it to the client.
 *
 * @param new_socket The socket for communication with the client.
 * @param capture The OpenCV VideoCapture object for capturing images.
 */
void captureSendImage(int new_socket, VideoCapture& capture)
{
	vector<uchar> encode(1);
	 		
	if(!capture.isOpened()) {
		cout << "Failed to connect to the camera." << endl;
	}

	Mat frame;
	if(!capture.read(frame)) {	
		cout<< "Capture frame failed"<<endl;
		//return -1;
	}
	imencode(".JPEG",frame,encode);
	int imageSize = encode.size();
	//cout<<"Encoding done"<<endl;
	
	//Send vector size
	send(new_socket, &imageSize, sizeof(imageSize), 0);
	//printf("ImageSize message sent\n");
	
	//Send compressed JPEG image
	send(new_socket,encode.data(),encode.size(),0);
	//printf("Image sent\n");
}

/**
 * @brief Function to read the value of the light sensor.
 *
 * This function reads the value of the light sensor and returns true if the light is on, false if it's off.
 *
 * @return True if the light is on, false if it's off.
 */
bool readADC()
{
	std::string lightPath = "/sys/class/saradc/ch0";
	std::string lightValue;

	ifstream lightFile;
	lightFile.open(lightPath.c_str());

	if(lightFile.fail()){
		cout << "Failed to open lightFile";
		exit(-1);
	}

	lightFile >> lightValue;
	cout << lightValue << endl;

	lightFile.close();
	
	//inverse logique
	if (stoi(lightValue) < 1000)
		return true;
	else
		return false;
}

/**
 * @brief Function to read the input value of the button.
 *
 * This function reads the input value of the button and returns true if the button is on, false if it's off.
 *
 * @return True if the button is on, false if it's off.
 */
bool readGPIO()
{
	std::string btnPath = "/sys/class/gpio/gpio228/value";
	std::string btnValue;
	ifstream btnFile;

	btnFile.open(btnPath.c_str());
	if(btnFile.fail()){
		cout << "failed to open btnFile" << endl;
		exit(-1);
	}

	btnFile >> btnValue;
	btnFile.close();

	// inverse logique
	if(stoi(btnValue) == 0)
		return true;
	else
		return false;
}

/**
 * @brief Establishes a connection with the server.
 *
 * This function creates a socket, binds it to a specified port, and configures it for listening.
 *
 * @param server_fd The socket file descriptor.
 * @param address The server address structure.
 * @param opt The socket options.
 */
int serverConnect(int& server_fd, struct sockaddr_in& address, int& opt)
{
	// Creating socket
	if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
		perror("socket failed");
		exit(EXIT_FAILURE);
	}

	// Attaching socket to the port PORT
	if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT, &opt, sizeof(opt))) {
		perror("setsockopt");
		exit(EXIT_FAILURE);
	}

	// Configure the server address
	address.sin_family = AF_INET;
	address.sin_addr.s_addr = INADDR_ANY;
	address.sin_port = htons(PORT);
	
	// Bind the socket to the specified port
	if (bind(server_fd, (struct sockaddr*)&address, sizeof(address)) < 0) {
		perror("bind failed");
		exit(EXIT_FAILURE);
	}
}

/**
 * @brief Accepts incoming connections from clients.
 *
 * This function listens for incoming connections and accepts them, establishing communication with the client.
 *
 * @param server_fd The server socket file descriptor.
 * @param new_socket The client socket file descriptor.
 * @param address The server address structure.
 * @param addrlen The size of the server address structure.
 * @param connect_OK A flag indicating if the connection is successful.
 */
void serverAccept(int& server_fd, int& new_socket, struct sockaddr_in& address, socklen_t& addrlen, bool& connect_OK)
{
	// Start listening for incoming connections
	if (listen(server_fd, 3) < 0) {
		perror("listen");
		exit(EXIT_FAILURE);
	}
	
	// Accept incoming connections
	if ((new_socket= accept(server_fd, (struct sockaddr*)&address,&addrlen))< 0) {
		perror("accept");
		exit(EXIT_FAILURE);
	}
	cout<<"Accepted Client Connection:"<<endl;
	connect_OK = true;
}

/**
 * @brief Sends a message to the client based on light and button status.
 *
 * This function sends messages to the client based on the status of the light and button.
 *
 * @param messages The message to be sent.
 * @param new_socket The client socket file descriptor.
 * @param light The status of the light.
 * @param btn The status of the button.
 */
void sendMessage(uint32_t& messages, int& new_socket, bool& light, bool& btn, bool& btnUsed)
{
	//send light and btn messages
	if (light == false){
		messages = IDOWN;
		send(new_socket, &messages, sizeof(messages), 0);
		cout << "Messages sent: light false: "<< messages << endl;
		btnUsed = false;
	}
	else if(light == true && btn == false){
		messages = READY;
		send(new_socket, &messages, sizeof(messages), 0);
		cout << "Messages sent: light true but btn false: " << messages << endl;
		btnUsed = false;
		captureSendImage(new_socket, capture);
	}
	else if(light == true && btn == true && btnUsed == false){
		messages = PUSHB;
		send(new_socket, &messages, sizeof(messages), 0);
		cout << "Messages sent: light true and btn true: " << messages << endl;
		btnUsed = true,
		captureSendImage(new_socket, capture);
	}
	else if(light == true && btn == true && btnUsed == true){
		messages = READY;
		send(new_socket, &messages, sizeof(messages), 0);
		cout << "Messages sent: light true but btn forced false: " << messages << endl;
		btnUsed = true;
		captureSendImage(new_socket, capture);
	}
}

/**
 * @brief Reads messages from the client.
 *
 * This function reads messages from the client, including OK, Quit, and resolution messages.
 *
 * @param messages The variable to store the received messages.
 * @param new_socket The client socket file descriptor.
 * @param connect_OK A flag indicating if the connection is successful.
 * @param index The index used for selecting image resolution.
 */
void readClient(uint32_t& messages, int& new_socket, bool& connect_OK, int& index, int& testRes)
{
	// Read messages from the client for OK or Quit and resolutions
	valread = read(new_socket,&messages,sizeof(messages));
	//cout << messages << endl;
	
	// Select resolution
	if(messages == RES1_OK){
		index = 1;
		connect_OK = true; // ok to continue
		
		if(index != testRes){
			capture.set(CV_CAP_PROP_FRAME_WIDTH, image[index].resX);
			capture.set(CV_CAP_PROP_FRAME_HEIGHT, image[index].resY);
			testRes = 1;
			cout << "Res 1 set"<<endl;
		}
		
	}
	else if(messages == RES2_OK){
		index = 4;
		connect_OK = true; // ok to continue

		if(index != testRes){
			capture.set(CV_CAP_PROP_FRAME_WIDTH, image[index].resX);
			capture.set(CV_CAP_PROP_FRAME_HEIGHT, image[index].resY);
			testRes = 4;
			cout<<"Res 2 rest"<<endl;
		}
		
	}
	else if(messages == OK){
		connect_OK = true; // ok to continue
	}
	else{
		connect_OK = false; //quit to quit
	} 
}

/**
 * @brief Main function for the server.
 *
 * This function initializes variables, establishes a connection with the client, and handles image capture and communication.
 */
int main(int argc, char const* argv[])
{
	// Initialize variables
	uint32_t messages = 0x00000000;
	int server_fd, new_socket;
	ssize_t valread;
	struct sockaddr_in address;
	int opt = 1;
	socklen_t addrlen = sizeof(address);
	int imageSize = 3326;
	bool connect_OK = true;
	int index = 0;				// Index used for selecting image resolution
	bool light = false;
	bool btn = false;
	int testRes =0;
	bool btnUsed = false;

	// Connect to client
	serverConnect(server_fd, address, opt);
	cout<<"Socket Bound to port :"<< PORT<<endl;
	
	while(true)
	{
		// Accept client
		serverAccept(server_fd, new_socket, address, addrlen, connect_OK);
		
		// Prepare the image Capture
		VideoCapture capture(0);
		capture.set(CV_CAP_PROP_FRAME_WIDTH, image[index].resX);
        capture.set(CV_CAP_PROP_FRAME_HEIGHT, image[index].resY);
		

		while(connect_OK)
		{
			// Light and btn check
			light = readADC();
			btn = readGPIO();
			cout << "Light is : " << light << endl;
			cout << "btn is : " << btn << endl;

			// Send messages to client
			sendMessage(messages, new_socket, light, btn);
			
			// Read messages from client
			readClient(messages, new_socket, connect_OK, index, testRes);
		}
	
		//close connection
		close(new_socket);
		cout<<"Session with client finished"<<endl;
	}
	// closing the listening socket
	close(server_fd);
	return 0;
}
