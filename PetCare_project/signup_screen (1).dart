import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

const _g = Color(0xFF4CAF82), _d = Color(0xFF2D2D2D);

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _name = TextEditingController(), _email = TextEditingController();
  final _pass = TextEditingController(), _confirm = TextEditingController();
  bool _hide = true, _loading = false;

  Future<void> _signUp() async {
    if (_name.text.isEmpty || _email.text.isEmpty || _pass.text.isEmpty) return _msg('Please fill all fields');
    if (_pass.text != _confirm.text) return _msg('Passwords do not match!');
    if (_pass.text.length < 6) return _msg('Password must be at least 6 characters');
    setState(() => _loading = true);
    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email.text.trim(), password: _pass.text.trim());
      await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set(
          {'name': _name.text.trim(), 'email': _email.text.trim(), 'createdAt': FieldValue.serverTimestamp()});
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    } on FirebaseAuthException catch (e) {
      _msg(e.code == 'email-already-in-use' ? 'This email is already registered'
          : e.code == 'weak-password' ? 'Password is too weak' : 'Sign up failed: ${e.message}');
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
        const SizedBox(height: 40),
        Container(width: 90, height: 90, decoration: BoxDecoration(color: _g, borderRadius: BorderRadius.circular(24)),
            child: const Icon(Icons.pets, color: Colors.white, size: 45)),
        const SizedBox(height: 16),
        const Text('PetCare', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _d)),
        const SizedBox(height: 30),
        Align(alignment: Alignment.centerLeft, child: const Text('Create Account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _d))),
        const SizedBox(height: 20),
        TextField(controller: _name, decoration: _dec('Full Name', Icons.person_outline)),
        const SizedBox(height: 14),
        TextField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: _dec('Email Address', Icons.email_outlined)),
        const SizedBox(height: 14),
        TextField(controller: _pass, obscureText: _hide, decoration: _dec('Password', Icons.lock_outline,
            suffix: IconButton(icon: Icon(_hide ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                onPressed: () => setState(() => _hide = !_hide)))),
        const SizedBox(height: 14),
        TextField(controller: _confirm, obscureText: _hide, decoration: _dec('Confirm Password', Icons.lock_outline)),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, height: 54, child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _g, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
            onPressed: _loading ? null : _signUp,
            child: _loading ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Create Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)))),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text("Already have an account? ", style: TextStyle(color: Color(0xFF888888))),
          GestureDetector(onTap: () => Navigator.pop(context), child: const Text('Login', style: TextStyle(color: _g, fontWeight: FontWeight.bold))),
        ]),
        const SizedBox(height: 30),
      ])),
    )));
  }
}