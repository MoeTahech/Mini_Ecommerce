import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final repo = AuthRepository();

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passCtrl, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loading ? null : () async {
                setState(() => loading = true);
                final success = await repo.login(emailCtrl.text, passCtrl.text);
                setState(() => loading = false);
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login success")));
                  // TODO: Navigate to catalog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login failed")));
                }
              },
              child: loading ? const CircularProgressIndicator() : const Text("Login"),
            ),
            TextButton(
              onPressed: () {
                // TODO: navigate to RegisterScreen
              },
              child: const Text("Don’t have an account? Register"),
            )
          ],
        ),
      ),
    );
  }
}
