
// Model to represent Dr. Nirmal's Research Publications
class Publication {
  final int id;
  final String authors;
  final String title;
  final String journal;
  final String year;
  final String? url; // Optional DOI or link

  Publication({
    required this.id,
    required this.authors,
    required this.title,
    required this.journal,
    required this.year,
    this.url,
  });

  // Factory method to create an object from JSON (useful if you later use an API)
  factory Publication.fromJson(Map<String, dynamic> json) {
    return Publication(
      id: json['id'] as int,
      authors: json['authors'] as String,
      title: json['title'] as String,
      journal: json['journal'] as String,
      year: json['year'] as String,
      url: json['url'] as String?,
    );
  }

  // Helper method to get formatted publication string
  String get fullCitation => "$authors. $title. $journal. $year.";
}