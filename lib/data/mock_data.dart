import 'models/publication_model.dart';
import 'models/experience_model.dart';
import 'models/award_model.dart';

final List<Publication> nirmalPublications = [
  Publication(id: 1, authors: "Lamichhane N, et al.", title: "Sentinel node biopsy in breast cancer", journal: "China Oncology", year: "2000"),
  // अरू ३० वटा यहाँ थप्दै जानुहोस् [cite: 110-184]
];

final List<Experience> nirmalExperiences = [
  Experience(role: "Chairman", hospital: "BPKMCH", period: "2020 - Present", details: "Board leadership."),
  Experience(role: "Senior Consultant", hospital: "BPKMCH", period: "2020 - Present", details: "Urological surgery."),
];

final List<Award> nirmalAwards = [
  Award(title: "Best Young Surgeon", organization: "SSN", year: "2005", description: "Vth Annual Meeting."),
];