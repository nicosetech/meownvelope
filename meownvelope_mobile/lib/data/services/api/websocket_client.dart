
import 'package:meownvelope_mobile/data/repositories/envelope_repository.dart';
import 'package:meownvelope_mobile/data/repositories/user_data_repository.dart';
import 'package:meownvelope_mobile/data/services/api/api_tools.dart';
import 'package:meownvelope_mobile/data/services/api/envelope_update_api.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class WebsocketClient {
  static late IO.Socket socket;

  static List<Function(dynamic)> _call_on_update = [];

  static Future<void> initializeWebsocket() async {
    if (!UserDataRepository.isLoggedIn()) {
      return;
    }

    var username = await UserDataRepository.getUsername();
    var password = await UserDataRepository.getPassword();

    socket = IO.io(
      'https://${ApiTools.ip}',
      IO.OptionBuilder().setTransports(['websocket']).setQuery({"username": username, "password": password}).build(),
    );

    socket.onConnect((_) async {
      print('Connected to websocket server');
      EnvelopeUpdateApi.batchRequest((await UserDataRepository.getUsername())!, (await UserDataRepository.getPassword())!);
    });
    socket.on('envelope_update', (data) => EnvelopeRepository.updateSingleEnvelope(data));
    socket.on('envelope_update', (data) => _updateAllListeners(data));
    
  }

  static Future<void> lateJoinRoom(String envelopeId) async {
    print("requesting late join");
    var username = await UserDataRepository.getUsername();
    var password = await UserDataRepository.getPassword();
    socket.emit("lateJoinRoom", {"username":username,"password":password,"envelope_id":envelopeId});
  }

  static Future<void> disconnectWebsocket() async {
    if (socket.connected) {
      socket.disconnect();
      print('Disconnected from websocket server');
    }
  }


  static void addListener(Function(dynamic) func){
    _call_on_update.add(func);
    print("added function to listening");
  }

  static void stopListening(Function(dynamic) func){
    _call_on_update.remove(func);
    print("removed Listener");
  }

  static void _updateAllListeners(data){
    for (Function(dynamic) i in _call_on_update){
      print("calling ${i}");
      i(data);
    }
  }

  static void incomingData(Function(dynamic) callback) {
    socket.on("envelope_update", (data) => callback(data));
  }

}