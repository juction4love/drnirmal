import 'package:flutter/material.dart';
import '../../data/models/publication_model.dart';

class PublicationsScreen extends StatefulWidget {
  const PublicationsScreen({super.key});

  @override
  State<PublicationsScreen> createState() => _PublicationsScreenState();
}

class _PublicationsScreenState extends State<PublicationsScreen> {
  // Dr. Nirmal's Full Publication List from CV [cite: 110-184]
  final List<Publication> _allPublications = [
    Publication(
      id: 1,
      authors: "Lamichhane N, Shen KW, et al.",
      title: "Sentinel node biopsy in breast cancer patients initial experience",
      journal: "China Oncology 2000;10(6): 481-84",
      year: "2000",
    ),
    Publication(
      id: 4,
      authors: "Lamichhane N, Shen KW, et al.",
      title: "Sentinel lymph node biopsy in breast cancer patients after overnight migration of radiolabelled sulphur colloid",
      journal: "Postgrad Med J. 2004; 80 (947): 546-50",
      year: "2004",
    ),
    Publication(
      id: 7,
      authors: "Lamichhane N, Nepal U, et al.",
      title: "Orthotropic neobladder urinary diversion for carcinoma of urinary bladder",
      journal: "J Nepal Health Res Counc. 2012 Sep;10(22): 201-3",
      year: "2012",
    ),
    Publication(
      id: 8,
      authors: "Lamichhane N, Dowrick AS, et al.",
      title: "Salvage robot-assisted radical prostatectomy (SRARP) for radiation resistant prostate cancer",
      journal: "Nepalese Journal of Cancer. 2016; 1: 21-28",
      year: "2016",
    ),
    Publication(
      id: 25,
      authors: "Shrestha G, Neupane P, Lamichhane N, et al.",
      title: "Cancer Incidence in Nepal: A Three-Year Trend Analysis 2013-2015",
      journal: "Asian Pacific Journal of Cancer Care, 5(3), 145-150",
      year: "2020",
    ),
    // Note: You can populate all 31 items here based on the source [cite: 110-184]
  ];

  List<Publication> _filteredList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredList = _allPublications;
  }

  void _runFilter(String enteredKeyword) {
    List<Publication> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allPublications;
    } else {
      results = _allPublications
          .where((pub) =>
              pub.title.toLowerCase().contains(enteredKeyword.toLowerCase()) ||
              pub.journal.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _filteredList = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Research & Publications"),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                labelText: 'Search Publications',
                suffixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          
          // Publications List
          Expanded(
            child: ListView.builder(
              itemCount: _filteredList.length,
              itemBuilder: (context, index) {
                final pub = _filteredList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    title: Text(
                      pub.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(pub.authors, style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 5),
                        Text(
                          pub.journal,
                          style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.blueGrey),
                        ),
                      ],
                    ),
                    trailing: CircleAvatar(
                      backgroundColor: Colors.blueGrey[100],
                      child: Text(pub.year, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}