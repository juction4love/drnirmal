import 'package:flutter/material.dart';
import '../../core/gemini_service.dart';
import '../../core/services/appointment_service.dart';
import '../../core/services/patient_service.dart';
import '../../data/models/appointment_model.dart';
import '../../data/models/patient_model.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  final List<Map<String, String>> _messages = [
    {
      "role": "bot",
      "message": "नमस्ते! म डा. निर्मलको एआई सहायक हुँ। उहाँको क्यान्सर उपचार, युलोजी बिरामी सेवाहरू, वा क्लिनिक समयबारे केही सोध्न चाहनुहुन्छ? (Hello! I'm Dr. Nirmal's AI assistant. Ask about cancer treatment, urology, or clinic hours.)"
    }
  ];

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty || _isLoading) return;
    
    String userMsg = _controller.text;
    _controller.clear();

    setState(() {
      _messages.add({"role": "user", "message": userMsg});
      _isLoading = true;
    });
    
    _scrollToBottom();

    // Context-Aware Injection: Fetching patient history first [cite: 2026-03-30]
    final patientRecord = await PatientService.fetchById("PATIENT_001");
    final appointments = await AppointmentService.fetchAll();
    
    final context = _formatContext(patientRecord, appointments);

    final botResponse = await GeminiService.getAIResponse(userMsg, patientContext: context);

    if (mounted) {
      setState(() {
        _messages.add({"role": "bot", "message": botResponse});
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  String _formatContext(PatientRecord? record, List<Appointment> apps) {
    if (record == null && apps.isEmpty) return "No medical records found for this patient.";

    String context = "PATIENT PROFILE: Name: ${record?.name}, Age: ${record?.age}, Gender: ${record?.gender}\n\n";
    
    context += "APPOINTMENT HISTORY:\n";
    for (var a in apps) {
      context += "- Date: ${a.dateTime}, Reason: ${a.reason}, Status: ${a.status.name.toUpperCase()}\n";
    }

    if (record != null) {
      context += "\nFOLLOW-UP NOTES (LATEST FIRST):\n";
      for (var f in record.followUpNotes.reversed) {
        context += "- $f\n";
      }
      context += "\nPRESCRIPTIONS (LATEST FIRST):\n";
      for (var p in record.prescriptions.reversed) {
        context += "- $p\n";
      }
    }
    
    return context;
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent, 
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: _messages.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _messages.length && _isLoading) return _buildLoadingBubble();

              bool isBot = _messages[index]["role"] == "bot";
              return _buildChatBubble(isBot, _messages[index]["message"]!);
            },
          ),
        ),
        _buildInputArea(),
      ],
    );
  }

  Widget _buildChatBubble(bool isBot, String message) {
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isBot ? const Color(0xFFF3F4FB) : const Color(0xFF003d80),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isBot ? 0 : 20),
            bottomRight: Radius.circular(isBot ? 20 : 0),
          ),
          boxShadow: isBot ? [] : [
            BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))
          ],
        ),
        child: Text(
          message,
          style: TextStyle(color: isBot ? Colors.black87 : Colors.white, fontSize: 15, height: 1.4),
        ),
      ),
    );
  }

  Widget _buildLoadingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Color(0xFFF3F4FB),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              enabled: !_isLoading,
              decoration: InputDecoration(
                hintText: "Ask about your visits or medical history...",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: const Color(0xFF003d80),
            shape: const CircleBorder(),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _isLoading ? null : _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}