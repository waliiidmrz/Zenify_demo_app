import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zenify_chat/matrix/matrix_client_service.dart';
import 'package:zenify_trip/landing_screen.dart';
import 'package:zenify_trip/navigation_screen.dart';
import 'package:zenify_trip/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LoadingApp()); // minimal app until init is complete

  _initializeApp();
}

Future<void> _initializeApp() async {
  final _secureStorage = FlutterSecureStorage();
  final token = await _secureStorage.read(key: "access_token");
  final userId = await _secureStorage.read(key: "user_id");
  final deviceId = await _secureStorage.read(key: "device_id");
  final homeserver = await _secureStorage.read(key: "homeserver");

  bool hasSession =
      token != null && userId != null && deviceId != null && homeserver != null;

  if (hasSession) {
    final matrix = MatrixClientService(); // singleton
    final success = await matrix.init();
    hasSession = success; // set to false if init failed
  }

  runApp(MyApp(hasSession: hasSession));
}

class MyApp extends StatelessWidget {
  final bool hasSession;
  const MyApp({super.key, required this.hasSession});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/landing': (_) => const LandingScreen(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Zenify Chat',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: hasSession ? const MainNavigationScreen() : const LoginScreen(),
    );
  }
}

class LoadingApp extends StatelessWidget {
  const LoadingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
