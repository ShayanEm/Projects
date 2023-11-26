# Server Compilation
g++ -o server imageServer.cpp -lopencv_core -lopencv_highgui -lopencv_imgcodecs -lopencv_imgproc
/server/build
cmake ..
make

# Server Usage
Run the server executable:
./server
The server will start listening for incoming connections and capture images.
