import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api_client.dart';
import '../data/auth_repository.dart';
import 'login_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  late final ApiClient api;
  late final AuthRepository repo;

  @override
  void initState() {
    super.initState();
    api = ApiClient("http://localhost:8080"); // replace with your backend URL
    repo = AuthRepository(api);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: size.width * 0.65,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Email
                  TextFormField(
                    controller: emailCtrl,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email, color: Colors.blue[700]),
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Email is required";
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return "Enter a valid email";
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password
                  TextFormField(
                    controller: passCtrl,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Colors.blue[700]),
                      labelText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.blue[700],
                        ),
                        onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Password is required";
                      if (value.length < 8) return "Password must be at least 8 characters";
                      if (!RegExp(r'[A-Za-z]').hasMatch(value)) return "Password must contain at least one letter";
                      if (!RegExp(r'[0-9]').hasMatch(value)) return "Password must contain at least one number";
                      if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) return "Password must contain at least one symbol";
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password
                  TextFormField(
                    controller: confirmPassCtrl,
                    obscureText: !_confirmPasswordVisible,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline, color: Colors.blue[700]),
                      labelText: "Confirm Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.blue[700],
                        ),
                        onPressed: () => setState(() => _confirmPasswordVisible = !_confirmPasswordVisible),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Please confirm password";
                      if (value != passCtrl.text) return "Passwords do not match";
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  // Register button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: loading
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;

                              setState(() => loading = true);
                              try {
                                final token = await repo.register(emailCtrl.text.trim(), passCtrl.text);

                                if (token != null && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Registration successful")),
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("User already exists")),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Registration error: $e")),
                                );
                              } finally {
                                if (mounted) setState(() => loading = false);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Register", style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Go to Login
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: Text("Already have an account? Login", style: TextStyle(color: Colors.blue[700])),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
