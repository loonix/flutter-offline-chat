# Flutter Offline Chat

NOTE: This project is under development, I haven't fully tested this concept. Please feel free to contribute.

Using SocketServer Dart Class to manipulate TCP Sockets.

Its just a simple test to see how far I can get offline mode to go.

PS: I am just tired of being online, that's all :)

## Instructions

Requirements:
* Wifi must be on
* All phones must be on the same network

This is currently using port 4040 for the server (more info on page below)
* https://www.adminsub.net/tcp-udp-port-finder/4040#:~:text=TCP%20port%204040%20uses%20the,bi%2Ddirectionally%20over%20the%20connection.

### How to Connect 2 phones
To connect the phones, at least 1 needs to be the server.

1. On the phone that you want to make the server:
* Server > Press Play

2. On The phone you want to access as client:
* Client > Write the ip address of the server (you can get it from the server phone) > Tap Connect

After this you can just write a message on each phone.

### Run on macos
`flutter run -d macos`