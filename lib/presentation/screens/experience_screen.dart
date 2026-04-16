import 'package:flutter/material.dart';

class ExperienceScreen extends StatelessWidget {
  const ExperienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Services provided to patients
    final List<Map<String, String>> services = [
      {
        "title": "Urological Cancer Surgery",
        "description": "Expert surgical treatment for kidney, prostate, and bladder cancers using advanced techniques.",
        "icon": "oncology"
      },
      {
        "title": "Prostate Care",
        "description": "Comprehensive screening and treatment for prostate enlargement and cancer.",
        "icon": "prostate"
      },
      {
        "title": "Bladder Reconstruction",
        "description": "Specialized surgeries including Studer Pouch Neobladder reconstruction.",
        "icon": "surgery"
      },
      {
        "title": "Kidney Health",
        "description": "Management of kidney tumors and complex renal surgeries.",
        "icon": "kidney"
      },
      {
        "title": "Pelvic Floor Surgery",
        "description": "Handling complex pelvic malignancies and reconstructive procedures.",
        "icon": "pelvic"
      },
      {
        "title": "Cancer Screening",
        "description": "Early detection services for all urological malignancies.",
        "icon": "screening"
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF003d80).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.medication_liquid_sharp, color: Color(0xFF003d80)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service["title"]!,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF003d80)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        service["description"]!,
                        style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}