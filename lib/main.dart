import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matrix/matrix.dart'; // Make sure this import is added
import 'package:zenify_trip/navigation_screen.dart';
import 'package:zenify_trip/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final _secureStorage = FlutterSecureStorage();
  String? token = await _secureStorage.read(key: "access_token");
  String? userId = await _secureStorage.read(key: "user_id");
  String? deviceId = await _secureStorage.read(key: "device_id");
  String? homeserver = await _secureStorage.read(key: "homeserver");

  Client? client;
  if (token != null &&
      userId != null &&
      deviceId != null &&
      homeserver != null) {
    client = Client(
        'zenify_${userId}_${deviceId}_${DateTime.now().millisecondsSinceEpoch}');
    client.homeserver = Uri.parse(homeserver);
    await client.init(
      newToken: token,
      newDeviceID: deviceId,
      newDeviceName: 'Zenify Device',
      newUserID: userId,
      newHomeserver: Uri.parse(homeserver),
      waitForFirstSync: true,
    );
  }

  runApp(MyApp(matrixClient: client));
}

class MyApp extends StatelessWidget {
  final Client? matrixClient;
  const MyApp({super.key, required this.matrixClient});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zenify Chat',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: matrixClient != null ? MainNavigationScreen() : LoginScreen(),
    );
  }
}
