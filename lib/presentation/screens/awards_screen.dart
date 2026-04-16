import 'package:flutter/material.dart';

class AwardsScreen extends StatelessWidget {
  const AwardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data extracted from Dr. Nirmal's CV 
    final List<Map<String, String>> awards = [
      {
        "title": "Best Young Surgeon Award",
        "organization": "Society of Surgeon of Nepal",
        "year": "2005",
        "description": "Vth annual meeting award for excellence in surgery."
      },
      {
        "title": "Saudavar Fellowship",
        "organization": "Memorial Sloan Kettering Cancer Center (MSKCC), USA",
        "year": "2006",
        "description": "Prestigious fellowship in surgical oncology[cite: 106]."
      },
      {
        "title": "International Development Educational Grant",
        "organization": "ASCO Foundation",
        "year": "2005",
        "description": "Awarded by American Society of Clinical Oncology[cite: 104]."
      },
      {
        "title": "Scholarship for Master Degree",
        "organization": "Ministry of Education, PR of China",
        "year": "1998",
        "description": "Full scholarship for higher surgical studies[cite: 102]."
      },
      {
        "title": "ICRETT Grant",
        "organization": "International Union Against Cancer (UICC)",
        "year": "2003",
        "description": "International technology transfer grant[cite: 104]."
      },
      {
        "title": "Government of Nepal Scholarship",
        "organization": "Ministry of Education, Nepal",
        "year": "1992",
        "description": "Scholarship award for studying MBBS in China[cite: 100]."
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Honors & Awards"),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: awards.length,
          itemBuilder: (context, index) {
            final award = awards[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFFFD700), // Gold Color
                  child: Icon(Icons.emoji_events, color: Colors.white),
                ),
                title: Text(
                  award["title"]!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      award["organization"]!,
                      style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 5),
                    Text(award["description"]!),
                  ],
                ),
                trailing: Text(
                  award["year"]!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}