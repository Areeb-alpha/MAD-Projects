import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const _o = Color(0xFFFF8C42), _d = Color(0xFF2D2D2D), _g = Color(0xFF4CAF82);

class FeedingScreen extends StatefulWidget {
  const FeedingScreen({super.key});
  @override
  State<FeedingScreen> createState() => _FeedingScreenState();
}

class _FeedingScreenState extends State<FeedingScreen> {
  final _food = TextEditingController(), _time = TextEditingController(), _amount = TextEditingController();
  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  Future<void> _addMeal() async {
    if (_food.text.isEmpty || _uid == null) return;
    await FirebaseFirestore.instance.collection('feeding').add({
      'food': _food.text.trim(), 'time': _time.text.trim().isEmpty ? '12:00 PM' : _time.text.trim(),
      'amount': _amount.text.trim().isEmpty ? '100g' : _amount.text.trim(), 'done': false, 'ownerId': _uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
    _food.clear(); _time.clear(); _amount.clear();
    if (mounted) Navigator.pop(context);
  }

  void _toggleDone(String id, bool current) => FirebaseFirestore.instance.collection('feeding').doc(id).update({'done': !current});
  Future<void> _deleteMeal(String id) => FirebaseFirestore.instance.collection('feeding').doc(id).delete();

  void _showAddDialog() => showDialog(context: context, builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Add Meal', style: TextStyle(fontWeight: FontWeight.bold, color: _d)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: _food, decoration: InputDecoration(labelText: 'Food Name', prefixIcon: const Icon(Icons.restaurant_outlined, color: _o),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
        const SizedBox(height: 12),
        TextField(controller: _time, decoration: InputDecoration(labelText: 'Time (e.g. 8:00 AM)', prefixIcon: const Icon(Icons.access_time, color: _o),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
        const SizedBox(height: 12),
        TextField(controller: _amount, decoration: InputDecoration(labelText: 'Amount (e.g. 200g)', prefixIcon: const Icon(Icons.scale, color: _o),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: _o), onPressed: _addMeal, child: const Text('Add', style: TextStyle(color: Colors.white))),
      ]));

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, title: const Text('Feeding Schedule', style: TextStyle(color: _d, fontWeight: FontWeight.bold)),
          actions: [IconButton(icon: const Icon(Icons.add, color: _o), onPressed: _showAddDialog)]),
      body: _uid == null ? const Center(child: Text('Please log in')) : StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('feeding').where('ownerId', isEqualTo: _uid).snapshots(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: _o));
            final docs = snap.data?.docs ?? [];
            final doneCount = docs.where((d) => d['done'] == true).length;
            if (docs.isEmpty) return const Center(child: Text('No meals scheduled. Tap + to add one!', style: TextStyle(color: Color(0xFF888888))));
            return Column(children: [
              Container(margin: const EdgeInsets.all(20), padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(gradient: const LinearGradient(colors: [_o, Color(0xFFE65100)]), borderRadius: BorderRadius.circular(18)),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('$doneCount of ${docs.length} meals done', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                    Text('${((doneCount / docs.length) * 100).toInt()}%', style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                  ])),
              Expanded(child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 20), itemCount: docs.length, itemBuilder: (c, i) {
                final d = docs[i]; final done = d['done'] == true;
                return Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
                        border: done ? Border.all(color: _g.withValues(alpha: 0.4)) : null,
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 3))]),
                    child: Row(children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text((d['food'] ?? '').toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: done ? _g : _d)),
                        Text('${d['time']} • ${d['amount']}', style: const TextStyle(fontSize: 12, color: Color(0xFF888888))),
                      ])),
                      IconButton(icon: Icon(done ? Icons.check_circle : Icons.circle_outlined, color: done ? _g : const Color(0xFFCCCCCC)),
                          onPressed: () => _toggleDone(d.id, done)),
                      IconButton(icon: const Icon(Icons.delete_outline, color: Color(0xFFE85D75), size: 20), onPressed: () => _deleteMeal(d.id)),
                    ]));
              })),
            ]);
          }),
    );
  }
}