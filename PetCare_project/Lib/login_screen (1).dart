import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup_screen.dart';
import 'home_screen.dart';

const _g = Color(0xFF4CAF82), _d = Color(0xFF2D2D2D);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController(), _pass = TextEditingController();
  bool _hide = true, _loading = false;

  Future<void> _login() async {
    if (_email.text.isEmpty || _pass.text.isEmpty) return _msg('Enter email and password');
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email.text.trim(), password: _pass.text.trim());
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen(email: _email.text.trim())));
    } on FirebaseAuthException catch (e) {
      _msg(e.code == 'user-not-found' ? 'No account found. Please sign up first.'
          : e.code == 'wrong-password' || e.code == 'invalid-credential' ? 'Incorrect email or password'
          : 'Login failed: ${e.message}');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _msg(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m), backgroundColor: Colors.red));

  InputDecoration _dec(String label, IconData icon, {Widget? suffix}) => InputDecoration(
      labelText: label, prefixIcon: Icon(icon, color: _g), suffixIcon: suffix, filled: true, fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none));

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color(0xFFF5F5F0), body: SafeArea(child: SingleChildScrollView(
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 28), child: Column(children: [
        const SizedBox(height: 60),
        Container(width: 110, height: 110, decoration: BoxDecoration(color: _g, borderRadius: BorderRadius.circular(30)),
            child: const Icon(Icons.pets, color: Colors.white, size: 55)),
        const SizedBox(height: 20),
        const Text('PetCare', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: _d)),
        const Text("Your pet's health companion", style: TextStyle(fontSize: 14, color: Color(0xFF888888))),
        const SizedBox(height: 40),
        Align(alignment: Alignment.centerLeft, child: const Text('Welcome Back!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _d))),
        const SizedBox(height: 20),
        TextField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: _dec('Email Address', Icons.email_outlined)),
        const SizedBox(height: 16),
        TextField(controller: _pass, obscureText: _hide, decoration: _dec('Password', Icons.lock_outline,
            suffix: IconButton(icon: Icon(_hide ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                onPressed: () => setState(() => _hide = !_hide)))),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, height: 54, child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _g, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
            onPressed: _loading ? null : _login,
            child: _loading ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)))),
        const SizedBox(height: 24),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text("Don't have an account? ", style: TextStyle(color: Color(0xFF888888))),
          GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen())),
              child: const Text('Create Account', style: TextStyle(color: _g, fontWeight: FontWeight.bold))),
        ]),
        const SizedBox(height: 40),
      ])),
    )));
  }
}