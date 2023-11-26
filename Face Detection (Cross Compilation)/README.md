# Image Transfer Project

This project involves a TCP server and client for transferring images over a network. The server captures images from a camera and sends them to the client, which can display the images and perform face detection.

## Requirements

- OpenCV library
- C++ compiler
- Linux environment (if using GPIO and ADC)

## Server

The server captures images from a camera and sends them to the connected client. It also monitors the light and button status for intelligent image transmission.

### Compilation

```bash
g++ -o server imageServer.cpp -lopencv_core -lopencv_highgui -lopencv_imgcodecs -lopencv_imgproc

# Server Usage
Run the server executable:
./server
The server will start listening for incoming connections and capture images

# Client Compilation
The client connects to the server, receives images, and displays them. It can also initiate face detection on received images
Compilation:
g++ -o client imageClient.cpp -lopencv_core -lopencv_highgui -lopencv_imgcodecs -lopencv_imgproc

# Client Usage
Run the client executable:
./client
The client will connect to the server and display received images.

## Face Detection
The client's child process performs face detection on received images using the OpenCV Haar Cascade Classifier. Detected faces are highlighted, and the images are saved.

## Contributing
No contribution can be made.

## License
This project is licensed under the POLYMTL License.

