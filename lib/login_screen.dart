import 'package:flutter/material.dart';
import 'package:zenify_chat/services/auth_service.dart';
import 'package:zenify_chat/zenify_chat_entry.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> handleLogin() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please fill all fields")),
      );
      return;
    }

    final client = await AuthService.login(username, password);

    if (client != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ZenifyChatEntry()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Login failed")),
      );
    }
  }

  Future<void> handleSignUp() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please fill all fields")),
      );
      return;
    }

    final success = await AuthService.register(username, password);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Registered! You can now log in.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Registration failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Zenify Chat - Login")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleLogin,
              child: const Text("Login"),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: handleSignUp,
              child: const Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
