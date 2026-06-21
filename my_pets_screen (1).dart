import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const _g = Color(0xFF4CAF82), _d = Color(0xFF2D2D2D);

class MyPetsScreen extends StatefulWidget {
  const MyPetsScreen({super.key});
  @override
  State<MyPetsScreen> createState() => _MyPetsScreenState();
}

class _MyPetsScreenState extends State<MyPetsScreen> {
  final _name = TextEditingController(), _breed = TextEditingController(), _age = TextEditingController();
  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  Future<void> _addPet() async {
    if (_name.text.isEmpty || _uid == null) return;
    await FirebaseFirestore.instance.collection('pets').add({
      'name': _name.text.trim(), 'breed': _breed.text.trim().isEmpty ? 'Unknown' : _breed.text.trim(),
      'age': _age.text.trim().isEmpty ? 'N/A' : _age.text.trim(), 'ownerId': _uid, 'createdAt': FieldValue.serverTimestamp(),
    });
    _name.clear(); _breed.clear(); _age.clear();
    if (mounted) Navigator.pop(context);
  }

  void _showAddDialog() => showDialog(context: context, builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Add New Pet', style: TextStyle(fontWeight: FontWeight.bold, color: _d)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: _name, decoration: InputDecoration(labelText: 'Pet Name', prefixIcon: const Icon(Icons.pets, color: _g),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
        const SizedBox(height: 12),
        TextField(controller: _breed, decoration: InputDecoration(labelText: 'Breed', prefixIcon: const Icon(Icons.category_outlined, color: _g),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
        const SizedBox(height: 12),
        TextField(controller: _age, decoration: InputDecoration(labelText: 'Age (e.g. 2 yrs)', prefixIcon: const Icon(Icons.cake_outlined, color: _g),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: _g), onPressed: _addPet, child: const Text('Add', style: TextStyle(color: Colors.white))),
      ]));

  Future<void> _deletePet(String id) => FirebaseFirestore.instance.collection('pets').doc(id).delete();

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, title: const Text('My Pets', style: TextStyle(color: _d, fontWeight: FontWeight.bold))),
      body: _uid == null ? const Center(child: Text('Please log in')) : StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('pets').where('ownerId', isEqualTo: _uid).snapshots(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: _g));
            final docs = snap.data?.docs ?? [];
            if (docs.isEmpty) return const Center(child: Text('No pets yet. Tap + to add one!', style: TextStyle(color: Color(0xFF888888))));
            return ListView.builder(padding: const EdgeInsets.all(20), itemCount: docs.length, itemBuilder: (c, i) {
              final d = docs[i];
              return Container(margin: const EdgeInsets.only(bottom: 14), padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 3))]),
                  child: Row(children: [
                    Container(width: 55, height: 55, decoration: BoxDecoration(color: _g.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(15)),
                        child: const Icon(Icons.pets, color: _g, size: 26)),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text((d['name'] ?? '').toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _d)),
                      Text('${d['breed']} • ${d['age']}', style: const TextStyle(fontSize: 12, color: Color(0xFF888888))),
                    ])),
                    IconButton(icon: const Icon(Icons.delete_outline, color: Color(0xFFE85D75)), onPressed: () => _deletePet(d.id)),
                  ]));
            });
          }),
      floatingActionButton: FloatingActionButton.extended(onPressed: _showAddDialog, backgroundColor: _g,
          icon: const Icon(Icons.add, color: Colors.white), label: const Text('Add Pet', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
    );
  }
}