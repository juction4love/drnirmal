import 'package:google_generative_ai/google_generative_ai.dart';
import '../core/constants.dart';

class GeminiService {
  static const String _apiKey = 'YOUR_GEMINI_API_KEY_HERE'; 

  static Future<String> getAIResponse(String prompt, {String? patientContext}) async {
    try {
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);
      
      // Patient-Centric & Context-Aware Prompt [cite: Context-Aware Update]
      final fullPrompt = """
        You are the Patient Assistant for ${AppConstants.drName}. 
        He is a ${AppConstants.drSpecialty} at ${AppConstants.clinicHospital}.

        CURRENT PATIENT RECORDS & HISTORY:
        ${patientContext ?? "No specific patient record provided (General FAQ mode)."}

        YOUR MISSION:
        1. Answer patient FAQs about urology/cancer using Dr. Nirmal's expertise.
        2. If a patient asks about THEIR records (visits, prescriptions, notes), use the "CURRENT PATIENT RECORDS" section above.
        3. Be highly empathetic, professional, and clear.
        4. GUIDELINE: Never provide new medical prescriptions or specific diagnosis. Refer to the official doctor's advice already in history.
        5. Speak in the language used by the patient (Nepali or English).

        PATIENT QUERY: 
        $prompt
      """;

      final content = [Content.text(fullPrompt)];
      final response = await model.generateContent(content);
      return response.text ?? "Sorry, I couldn't process that.";
    } catch (e) {
      return "Error: $e. Please check your internet connection.";
    }
  }
}