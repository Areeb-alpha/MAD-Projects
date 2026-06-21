import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const _r = Color(0xFFE85D75), _d = Color(0xFF2D2D2D), _g = Color(0xFF4CAF82), _p = Color(0xFF6C63FF);

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});
  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  final _reason = TextEditingController(), _doc = TextEditingController(), _notes = TextEditingController(), _weight = TextEditingController();
  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  Future<void> _addVisit() async {
    if (_reason.text.isEmpty || _uid == null) return;
    await FirebaseFirestore.instance.collection('health').add({
      'reason': _reason.text.trim(), 'doctor': _doc.text.trim().isEmpty ? 'N/A' : _doc.text.trim(),
      'notes': _notes.text.trim().isEmpty ? 'No notes' : _notes.text.trim(), 'weight': _weight.text.trim(),
      'ownerId': _uid, 'createdAt': FieldValue.serverTimestamp(),
    });
    _reason.clear(); _doc.clear(); _notes.clear(); _weight.clear();
    if (mounted) Navigator.pop(context);
  }

  Future<void> _deleteVisit(String id) => FirebaseFirestore.instance.collection('health').doc(id).delete();

  void _showAddDialog() => showDialog(context: context, builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Add Vet Visit', style: TextStyle(fontWeight: FontWeight.bold, color: _d)),
      content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: _reason, decoration: InputDecoration(labelText: 'Reason for Visit', prefixIcon: const Icon(Icons.medical_services_outlined, color: _r),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
        const SizedBox(height: 12),
        TextField(controller: _doc, decoration: InputDecoration(labelText: 'Doctor Name', prefixIcon: const Icon(Icons.person_outline, color: _r),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
        const SizedBox(height: 12),
        TextField(controller: _weight, decoration: InputDecoration(labelText: 'Weight (e.g. 28.5 kg)', prefixIcon: const Icon(Icons.monitor_weight_outlined, color: _r),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
        const SizedBox(height: 12),
        TextField(controller: _notes, decoration: InputDecoration(labelText: 'Notes', prefixIcon: const Icon(Icons.notes, color: _r),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
      ])),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: _r), onPressed: _addVisit, child: const Text('Add', style: TextStyle(color: Colors.white))),
      ]));

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, title: const Text('Health Monitor', style: TextStyle(color: _d, fontWeight: FontWeight.bold)),
          actions: [IconButton(icon: const Icon(Icons.add, color: _r), onPressed: _showAddDialog)]),
      body: _uid == null ? const Center(child: Text('Please log in')) : StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('health').where('ownerId', isEqualTo: _uid).snapshots(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: _r));
            final docs = snap.data?.docs ?? [];
            if (docs.isEmpty) return const Center(child: Text('No health records yet. Tap + to add one!', style: TextStyle(color: Color(0xFF888888))));
            return ListView.builder(padding: const EdgeInsets.all(20), itemCount: docs.length, itemBuilder: (c, i) {
              final d = docs[i];
              return Container(margin: const EdgeInsets.only(bottom: 14), padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 3))]),
                  child: Row(children: [
                    Container(width: 50, height: 50, decoration: BoxDecoration(color: _r.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
                        child: const Icon(Icons.medical_services_outlined, color: _r, size: 24)),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text((d['reason'] ?? '').toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _d)),
                      Text('Dr. ${d['doctor']}', style: const TextStyle(fontSize: 12, color: _p)),
                      if ((d['weight'] ?? '').toString().isNotEmpty) Text('Weight: ${d['weight']}', style: const TextStyle(fontSize: 12, color: _g)),
                      Text((d['notes'] ?? '').toString(), style: const TextStyle(fontSize: 11, color: Color(0xFF888888)), overflow: TextOverflow.ellipsis),
                    ])),
                    IconButton(icon: const Icon(Icons.delete_outline, color: _r), onPressed: () => _deleteVisit(d.id)),
                  ]));
            });
          }),
    );
  }
}