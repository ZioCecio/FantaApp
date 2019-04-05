import 'dart:convert';

import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';

class SocketAction {
  static int idUser;
  static SocketIO webSocket;

  static void inizialize(int id) {
    idUser = id;
    webSocket =
        SocketIOManager().createSocketIO('http://192.168.1.20:3000', '/');
    webSocket.init();
    webSocket.connect();
  }

  static void subscribe(String event, Function callback) =>
      webSocket.subscribe(event, callback);

  static void sendMessage(String event, String message) =>
      webSocket.sendMessage(event, message);

  static void changePage(var player) =>
      webSocket.sendMessage('changePage', json.encode(player));

  static void doOffer(String valueOfOffer, int idPlayer) {
    final offer = {
      'player': idPlayer,
      'user': idUser,
      'offer': int.parse(valueOfOffer)
    };

    webSocket.sendMessage('doOffer', json.encode(offer));
  }
}
