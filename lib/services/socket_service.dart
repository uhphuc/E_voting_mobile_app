import 'package:project/core/constants/api_constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static late IO.Socket socket;
  static String baseUrl = ApiConstants.baseUrl;

  static void initSocket(int userId) {
    socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'userId': userId})
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      print("Connected to server");
    });

    socket.onConnectError((err) {
      print("Connect error: $err");
    });

    socket.onDisconnect((_) {
      print("Disconnected");
    });

    socket.on("test", (data) {
      print("Received: $data");
    });
  }

}