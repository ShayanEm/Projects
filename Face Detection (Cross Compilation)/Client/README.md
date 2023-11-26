# Client Compilation
g++ -o client imageClient.cpp -lopencv_core -lopencv_highgui -lopencv_imgcodecs -lopencv_imgproc
/client/build
cmake ..
make

# Client Usage
Run the client executable:
./client
The client will connect to the server and display received images.
