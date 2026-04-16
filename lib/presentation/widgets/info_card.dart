import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final List<String> items;
  const InfoCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: items.map((item) => Row(
            children: [
              const Icon(Icons.check_circle, size: 18, color: Colors.blueGrey),
              const SizedBox(width: 8),
              Expanded(child: Text(item)),
            ],
          )).toList(),
        ),
      ),
    );
  }
}