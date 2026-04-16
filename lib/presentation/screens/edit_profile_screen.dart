import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controllers for each social link [cite: 2026-03-11]
  final TextEditingController _fbController = TextEditingController();
  final TextEditingController _rgController = TextEditingController();
  final TextEditingController _webController = TextEditingController();
  final TextEditingController _twController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedLinks();
  }

  // Load links from local storage or use defaults from Constants
  Future<void> _loadSavedLinks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fbController.text = prefs.getString('fb_link') ?? AppConstants.facebook;
      _rgController.text = prefs.getString('rg_link') ?? AppConstants.researchGate;
      _webController.text = prefs.getString('web_link') ?? AppConstants.drWebsite;
      _twController.text = prefs.getString('tw_link') ?? AppConstants.twitter;
    });
  }

  // Save updated links to local storage
  Future<void> _saveLinks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fb_link', _fbController.text);
    await prefs.setString('rg_link', _rgController.text);
    await prefs.setString('web_link', _webController.text);
    await prefs.setString('tw_link', _twController.text);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile Links Updated Successfully!"),
          backgroundColor: Colors.teal,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Social Profiles"),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Update your professional & social links below:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
            const SizedBox(height: 20),
            
            _buildEditField("Facebook Profile", _fbController, Icons.facebook),
            _buildEditField("ResearchGate", _rgController, Icons.science),
            _buildEditField("Official Website", _webController, Icons.language),
            _buildEditField("Twitter / X", _twController, Icons.share),

            const SizedBox(height: 30),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _saveLinks,
                icon: const Icon(Icons.save),
                label: const Text("Save All Changes", style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[900],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Center(
              child: Text(
                "Note: These links will be used across the app.",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blueGrey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fbController.dispose();
    _rgController.dispose();
    _webController.dispose();
    _twController.dispose();
    super.dispose();
  }
}