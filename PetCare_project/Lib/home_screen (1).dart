import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'my_pets_screen.dart';
import 'feeding_screen.dart';
import 'vaccination_screen.dart';
import 'health_screen.dart';
import 'settings_screen.dart';
import 'about_screen.dart';
import 'login_screen.dart';

const _g = Color(0xFF4CAF82), _d = Color(0xFF2D2D2D);

class HomeScreen extends StatefulWidget {
  final String email;
  const HomeScreen({super.key, required this.email});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _idx = 0;
  final _actions = [[Icons.restaurant_outlined, 'Feeding', const Color(0xFFFF8C42)], [Icons.vaccines_outlined, 'Vaccines', const Color(0xFF6C63FF)],
    [Icons.favorite_outline, 'Health', const Color(0xFFE85D75)], [Icons.calendar_today_outlined, 'Vet Visits', _g]];
  final _qScreens = [const FeedingScreen(), const VaccinationScreen(), const HealthScreen(), const MyPetsScreen()];
  void _go(Widget s) => Navigator.push(context, MaterialPageRoute(builder: (_) => s));

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? widget.email;
    final name = email.contains('@') ? email.split('@')[0] : email;
    final uid = user?.uid;
    return Scaffold(backgroundColor: const Color(0xFFF5F5F0), drawer: _drawer(name, email),
      body: SafeArea(child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Builder(builder: (c) => IconButton(icon: const Icon(Icons.menu, color: _d), onPressed: () => Scaffold.of(c).openDrawer())),
          const Text('PetCare', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _d)),
          IconButton(icon: const Icon(Icons.notifications_outlined, color: _d), onPressed: () => _go(const SettingsScreen())),
        ])),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Container(width: double.infinity, padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [_g, Color(0xFF2E7D5E)]), borderRadius: BorderRadius.circular(20)),
            child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Hello, $name! 👋', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 6),
              const Text('Your pets are waiting\nfor care today!', style: TextStyle(color: Colors.white70, fontSize: 13)), const SizedBox(height: 14),
              GestureDetector(onTap: () => _go(const MyPetsScreen()), child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(20)),
                  child: const Text('View My Pets →', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)))),
            ])), const Icon(Icons.pets, size: 70, color: Colors.white24)]))), const SizedBox(height: 28),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _d))), const SizedBox(height: 14),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_actions.length, (i) => GestureDetector(onTap: () => _go(_qScreens[i]), child: Column(children: [
              Container(width: 62, height: 62, decoration: BoxDecoration(color: (_actions[i][2] as Color).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(18)),
                  child: Icon(_actions[i][0] as IconData, color: _actions[i][2] as Color, size: 28)),
              const SizedBox(height: 8), Text(_actions[i][1] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            ]))))), const SizedBox(height: 28),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text('My Pets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _d))), const SizedBox(height: 14),
        SizedBox(height: 150, child: uid == null ? const Center(child: Text('Sign in to see pets')) : StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('pets').where('ownerId', isEqualTo: uid).snapshots(),
            builder: (c, snap) {
              final docs = snap.data?.docs ?? [];
              return ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [...docs.map((d) => _petCard((d['name'] ?? '').toString(), (d['breed'] ?? '').toString(), (d['age'] ?? '').toString())), _addPetCard()]);
            })), const SizedBox(height: 30),
      ]))),
      bottomNavigationBar: BottomNavigationBar(currentIndex: _idx, selectedItemColor: _g, type: BottomNavigationBarType.fixed,
          onTap: (i) { setState(() => _idx = i); if (i == 1) _go(const FeedingScreen()); if (i == 2) _go(const HealthScreen()); if (i == 3) _go(const SettingsScreen()); },
          items: const [BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'), BottomNavigationBarItem(icon: Icon(Icons.restaurant_outlined), label: 'Feeding'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), label: 'Health'), BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings')]),
    );
  }

  Widget _petCard(String name, String breed, String age) => GestureDetector(onTap: () => _go(const MyPetsScreen()), child: Container(width: 140, margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.pets, color: _g, size: 24), const SizedBox(height: 8),
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(breed, style: const TextStyle(fontSize: 10, color: Color(0xFF999999)), overflow: TextOverflow.ellipsis),
        Text(age, style: const TextStyle(fontSize: 10, color: _g, fontWeight: FontWeight.w600)),
      ])));

  Widget _addPetCard() => GestureDetector(onTap: () => _go(const MyPetsScreen()), child: Container(width: 140, margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: _g, width: 1.5)),
      child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add_circle_outline, color: _g, size: 32), SizedBox(height: 8),
        Text('Add Pet', style: TextStyle(color: _g, fontWeight: FontWeight.w600))])));

  Widget _drawer(String name, String email) => Drawer(child: ListView(padding: EdgeInsets.zero, children: [
    DrawerHeader(decoration: const BoxDecoration(gradient: LinearGradient(colors: [_g, Color(0xFF2E7D5E)])),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
          const CircleAvatar(radius: 30, backgroundColor: Colors.white24, child: Icon(Icons.person, color: Colors.white, size: 32)), const SizedBox(height: 10),
          Text(name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          Text(email, style: const TextStyle(color: Colors.white70, fontSize: 12))])),
    _item(Icons.home_outlined, 'Home', () {}), _item(Icons.pets_outlined, 'My Pets', () => _go(const MyPetsScreen())),
    _item(Icons.restaurant_outlined, 'Feeding Schedule', () => _go(const FeedingScreen())), _item(Icons.vaccines_outlined, 'Vaccinations', () => _go(const VaccinationScreen())),
    _item(Icons.favorite_outline, 'Health Records', () => _go(const HealthScreen())), _item(Icons.settings_outlined, 'Settings', () => _go(const SettingsScreen())),
    const Divider(), _item(Icons.info_outline, 'About', () => _go(const AboutScreen())),
    _item(Icons.logout, 'Logout', () async { await FirebaseAuth.instance.signOut(); if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())); }),
  ]));

  ListTile _item(IconData i, String t, VoidCallback onTap) => ListTile(leading: Icon(i, color: _g), title: Text(t, style: const TextStyle(fontSize: 15, color: _d)),
      onTap: () { Navigator.pop(context); onTap(); });
}