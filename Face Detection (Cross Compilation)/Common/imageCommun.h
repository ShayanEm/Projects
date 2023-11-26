#ifndef IMAGE_COMMUN_H
#define IMAGE_COMMUN_H

//Server
#define OK 0x00000001            // client message to continue
#define QUIT 0x00000000          // clinet message to quit
#define RES1_OK 0x00000003
#define RES2_OK 0x00000007

#define READY 0x00000008		// light on
#define IDOWN 0x00000010		// light off
#define PUSHB 0x00000018		// light on and btn on
//#define PORT 4099

//Client
#define PORT 4099          // The port number for communication
#define DELAY 30           // Delay in milliseconds for image display
#define ESC 1048603        // ESC key value
#define K1 1048625         // Number 1 key value
#define K2 1048626         // Number 2 key value

//#define OK 0x00000001            // client message to continue
//#define QUIT 0x00000000          // clinet message to quit
#define RESO1 0x00000002 
#define RESO2 0x00000006 

//#define READY 0x00000008		// light on
//#define IDOWN 0x00000010		// light off
//#define PUSHB 0x00000018		// light on and btn on

#endif  // IMAGE_COMMUN_H
