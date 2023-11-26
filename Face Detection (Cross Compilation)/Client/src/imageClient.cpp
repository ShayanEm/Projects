/**
 * @file imageClient.cpp
 * @brief Client-side C++ program to receive image transfer
 * @author Shayan Eram
 */
#include <iostream>
#include <arpa/inet.h>
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>
#include <opencv2/opencv.hpp>
#include <time.h>
#include <string>
#include <sstream>

#include <vector> //not needed

#include "../commun/imageCommun.h"

using namespace std;
using namespace cv;

/**
 * @brief Patch to fix to_string().
 */
namespace patch
{
    template <typename T> std::string to_string(const T& n)
    {
        std:: ostringstream stm;
        stm << n;
        return stm.str();
    }
}

/**
 * @brief Function to receive image from the server.
 *
 * This function receives image data from the server and decodes it using OpenCV.
 *
 * @param valread Reference to the variable storing the number of bytes read.
 * @param client_fd The client socket file descriptor.
 * @param vectorSize Reference to the variable storing the size of the image vector.
 * @return The decoded image as a Mat object.
 */
Mat recivImage(int& valread, int& client_fd, int& vectorSize)
{
    valread = read(client_fd, &vectorSize, sizeof(vectorSize));
    //cout << "Image Size is: " << vectorSize << endl;
    vector<uchar> imageCode(vectorSize);
    size_t bytesRead = 0;
    
    while (bytesRead < vectorSize) {
        ssize_t result = read(client_fd, imageCode.data() + bytesRead, imageCode.size() - bytesRead);
        
        if (result < 0) {
            cout << "Result error" << endl;
            break;
        } 
        else {
            bytesRead += result;
        }
    }
    
    Mat image = imdecode(Mat(imageCode), IMREAD_UNCHANGED);
    
    if (image.empty()) {
        cout << "Failed to decode the image." << endl;
        //return -1;
    }

    return image;
}

/**
 * @brief Function to connect to the server.
 *
 * This function creates a socket, sets up the server address, and connects to the server.
 *
 * @param client_fd Reference to the client socket file descriptor.
 * @param serverAddr Reference to the server address structure.
 * @param status Reference to the status variable.
 * @return 0 on success, -1 on failure.
 */
int clientConnect(int& client_fd,struct sockaddr_in& serverAddr, int& status)
{
    // Create a socket
    if ((client_fd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        perror("socket failed");
        return -1;
    }

    serverAddr.sin_family = AF_INET;
    serverAddr.sin_port = htons(PORT);

    // Convert IPv4 and IPv6 addresses from text to binary form
    if (inet_pton(AF_INET, "192.168.7.2", &serverAddr.sin_addr) <= 0) {
        perror("Invalid address/ Address not supported");
        return -1;
    }

    // Connect to the server
    if ((status = connect(client_fd, (struct sockaddr*)&serverAddr, sizeof(serverAddr))) < 0) {
        perror("connection failed");
        return -1;
    }
}

/**
 * @brief Function to handle keypress events.
 *
 * This function handles keypress events, sets appropriate messages, and sends them to the server.
 *
 * @param waitK Reference to the variable storing the pressed key.
 * @param messages Reference to the variable storing messages.
 * @param client_fd The client socket file descriptor.
 * @return 0 if the keypress indicates quitting, 1 otherwise.
 */
int keyPress(int& waitK, int& messages, int& client_fd)
{
    if (waitK == ESC) {
            // Set messages to Quit and send to server
            messages = QUIT;    // Force messages to 0x0
            
            send(client_fd, &messages, sizeof(messages), 0);
            close(client_fd);
            cout << "Closing connection" << endl;
            return 0;
        } 
        else if(waitK == K1){
            // set messages to res1 and ok
            messages = RESO1;
            messages |= OK;
        }
        else if(waitK == K2){
            // set messages to res2 and ok
            messages = RESO2;
            messages |= OK;
        }
        else {
            // set messages to OK
            messages = OK;
        }
    
    // Send to server
    send(client_fd, &messages, sizeof(messages), 0);
    cout << "messages sent after key : " << messages << endl;
}

/**
 * @brief Function to receive images and display them.
 *
 * This function receives image data from the server, processes it, and displays the images.
 *
 * @param client_fd The client socket file descriptor.
 * @param messages Reference to the variable storing messages.
 * @param vectorSize Reference to the variable storing the size of the image vector.
 * @param messagesRecived Reference to the variable storing the received messages.
 * @param imageID Reference to the variable storing the image ID.
 */
void recvImage(int& client_fd,int& messages,int& vectorSize, int& messagesRecived, int& imageID)
{
    recv(client_fd, &messages, sizeof(messages),0);
    cout << "messages recived: " << messages << endl;
    messagesRecived = messages;
    
    if(messagesRecived == IDOWN){
        cout << "No image to show" << endl;
    }
    else if(messagesRecived == READY){
        Mat image = recivImage(valread, client_fd, vectorSize);
        imshow("Image",image);
    }
    else if(messagesRecived == PUSHB){
        
        Mat image = recivImage(valread, client_fd, vectorSize);
        imageID++;

        pid_t pid = fork();
        
        if(pid == -1){
            perror("fork");
            return -1;
        }
        else if(pid > 0){
            cout << "Parent process"<<endl;
            imshow("Image",image);
        }
        else{
            cout<<"Child process"<<endl;
            
            // Face detection
            CascadeClassifier face_cascade;
            face_cascade.load("haarcascade_frontalface_default.xml");

            // Convert the image to grayscale for face detection
            Mat gray;
            cvtColor(image, gray, COLOR_BGR2GRAY);

            // Detect faces
            vector<Rect> faces;
            face_cascade.detectMultiScale(gray, faces, 1.3, 5);

            // Draw rectangles around the detected faces
            for (int i=0; i<faces.size();i++) {
                rectangle(image, faces[i], Scalar(255, 0, 0), 2);
            }
            // Save image with number
            imwrite("Image"+patch::to_string(imageID)+".png", image);
            exit(0);
        }
    }
}

/**
 * @brief Main function for the client.
 *
 * This function initializes variables, connects to the server, and handles image reception and key events.
 */
int main(int argc, char const* argv[]) {
    
    // Initisalization des variables
    uint32_t messages = 0x00000000;
    int status, valread, client_fd;
    struct sockaddr_in serverAddr;
    int vectorSize;
    // Recive the light and btn messages
    int messagesRecived;
    int imageID = 0;

    // Connect to server
    clientConnect(client_fd, serverAddr, status);
    cout << "Connected to server" << endl;
    
    // Receive image while connected
    while (true) {

        // Recive image from server
        recvImage(client_fd, messages, vectorSize, messagesRecived, imageID);
        
        //Key detect
        int waitK = waitKey(DELAY);
        //cout << "Key pressed is: " << waitK << endl;
        
        // Read the key
        keyPress(waitK, messages, client_fd);
        
    }
    // Closing the connected socket
    return 0;
}