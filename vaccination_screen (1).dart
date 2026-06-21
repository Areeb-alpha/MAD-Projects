import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const _p = Color(0xFF6C63FF), _d = Color(0xFF2D2D2D), _r = Color(0xFFE85D75);

class VaccinationScreen extends StatefulWidget {
  const VaccinationScreen({super.key});
  @override
  State<VaccinationScreen> createState() => _VaccinationScreenState();
}

class _VaccinationScreenState extends State<VaccinationScreen> {
  final _name = TextEditingController(), _date = TextEditingController(), _due = TextEditingController(), _doc = TextEditingController();
  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  Future<void> _addVaccine() async {
    if (_name.text.isEmpty || _uid == null) return;
    await FirebaseFirestore.instance.collection('vaccines').add({
      'name': _name.text.trim(), 'date': _date.text.trim().isEmpty ? 'N/A' : _date.text.trim(),
      'due': _due.text.trim().isEmpty ? 'N/A' : _due.text.trim(), 'doctor': _doc.text.trim().isEmpty ? 'N/A' : _doc.text.trim(),
      'status': 'Up to Date', 'ownerId': _uid, 'createdAt': FieldValue.serverTimestamp(),
    });
    _name.clear(); _date.clear(); _due.clear(); _doc.clear();
    if (mounted) Navigator.pop(context);
  }

  Future<void> _deleteVaccine(String id) => FirebaseFirestore.instance.collection('vaccines').doc(id).delete();

  void _showAddDialog() => showDialog(context: context, builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Add Vaccine Record', style: TextStyle(fontWeight: FontWeight.bold, color: _d)),
      content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: _name, decoration: InputDecoration(labelText: 'Vaccine Name', prefixIcon: const Icon(Icons.vaccines_outlined, color: _p),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
        const SizedBox(height: 12),
        TextField(controller: _date, decoration: InputDecoration(labelText: 'Date Given', prefixIcon: const Icon(Icons.calendar_today, color: _p),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
        const SizedBox(height: 12),
        TextField(controller: _due, decoration: InputDecoration(labelText: 'Next Due Date', prefixIcon: const Icon(Icons.event_repeat, color: _p),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
        const SizedBox(height: 12),
        TextField(controller: _doc, decoration: InputDecoration(labelText: 'Veterinarian', prefixIcon: const Icon(Icons.person_outline, color: _p),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
      ])),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: _p), onPressed: _addVaccine, child: const Text('Add', style: TextStyle(color: Colors.white))),
      ]));

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, title: const Text('Vaccinations', style: TextStyle(color: _d, fontWeight: FontWeight.bold)),
          actions: [IconButton(icon: const Icon(Icons.add, color: _p), onPressed: _showAddDialog)]),
      body: _uid == null ? const Center(child: Text('Please log in')) : StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('vaccines').where('ownerId', isEqualTo: _uid).snapshots(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: _p));
            final docs = snap.data?.docs ?? [];
            if (docs.isEmpty) return const Center(child: Text('No vaccine records yet. Tap + to add one!', style: TextStyle(color: Color(0xFF888888))));
            return ListView.builder(padding: const EdgeInsets.all(20), itemCount: docs.length, itemBuilder: (c, i) {
              final d = docs[i];
              return Container(margin: const EdgeInsets.only(bottom: 14), padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 3))]),
                  child: Row(children: [
                    Container(width: 50, height: 50, decoration: BoxDecoration(color: _p.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
                        child: const Icon(Icons.vaccines_outlined, color: _p, size: 24)),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text((d['name'] ?? '').toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _d)),
                      Text('Given: ${d['date']}', style: const TextStyle(fontSize: 11, color: Color(0xFF888888))),
                      Text('Due: ${d['due']}', style: const TextStyle(fontSize: 11, color: _p)),
                      Text('Vet: ${d['doctor']}', style: const TextStyle(fontSize: 11, color: Color(0xFF888888))),
                    ])),
                    IconButton(icon: const Icon(Icons.delete_outline, color: _r), onPressed: () => _deleteVaccine(d.id)),
                  ]));
            });
          }),
    );
  }
}