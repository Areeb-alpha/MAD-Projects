import 'package:flutter/material.dart';

const _g = Color(0xFF4CAF82), _d = Color(0xFF2D2D2D);

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Widget _card(Widget child) => Container(margin: const EdgeInsets.only(top: 16), padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), width: double.infinity, child: child);

  Widget _feature(IconData icon, String label, Color color) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(children: [
    Container(padding: const EdgeInsets.all(7), decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: color, size: 16)),
    const SizedBox(width: 12), Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF555555))),
  ]));

  Widget _info(String label, String value) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [
    Text('$label: ', style: const TextStyle(fontSize: 13, color: Color(0xFF888888), fontWeight: FontWeight.w500)),
    Expanded(child: Text(value, style: const TextStyle(fontSize: 13, color: _d, fontWeight: FontWeight.bold))),
  ]));

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, title: const Text('About', style: TextStyle(color: _d, fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
        Container(width: 90, height: 90, decoration: BoxDecoration(color: _g, borderRadius: BorderRadius.circular(24)),
            child: const Icon(Icons.pets, color: Colors.white, size: 45)),
        const SizedBox(height: 14),
        const Text('PetCare', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: _d)),
        const Text("Your Pet's Health Companion", style: TextStyle(fontSize: 13, color: Color(0xFF888888))),
        const SizedBox(height: 8),
        Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5), decoration: BoxDecoration(color: _g.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
            child: const Text('Version 1.0.0 (Firebase)', style: TextStyle(color: _g, fontWeight: FontWeight.w600, fontSize: 12))),
        _card(const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('About PetCare', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _d)), SizedBox(height: 8),
          Text('PetCare helps pet owners manage feeding schedules, vaccination records, and health monitoring, with real-time cloud sync via Firebase.',
              style: TextStyle(fontSize: 13, color: Color(0xFF666666), height: 1.5)),
        ])),
        _card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Key Features', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _d)), const SizedBox(height: 12),
          _feature(Icons.pets, 'Pet Profile Management', _g), _feature(Icons.restaurant_outlined, 'Feeding Schedule Tracker', const Color(0xFFFF8C42)),
          _feature(Icons.vaccines_outlined, 'Vaccination Records', const Color(0xFF6C63FF)), _feature(Icons.favorite_outline, 'Health Monitoring', const Color(0xFFE85D75)),
          _feature(Icons.cloud_outlined, 'Firebase Cloud Sync', _g),
        ])),
        _card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Developer Info', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _d)), const SizedBox(height: 10),
          _info('Developer', 'Ghulam Hussain Jadoon'), _info('University', 'Iqra University'),
          _info('Course', 'CSC481 - Mobile App Dev'), _info('Stack', 'Flutter, Dart, Firebase'),
        ])),
        const SizedBox(height: 20),
      ]))),
    );
  }
}