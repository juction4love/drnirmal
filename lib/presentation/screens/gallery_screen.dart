import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/admin_logic.dart'; // अघि बनाएको पिन चेक लजिक

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<String> _imagePaths = [];
  final ImagePicker _picker = ImagePicker();
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadImages();
    _checkAdmin();
  }

  Future<void> _checkAdmin() async {
    final status = await AdminLogic.isAdmin();
    setState(() => _isAdmin = status);
  }

  Future<void> _loadImages() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _imagePaths = prefs.getStringList('gallery_images') ?? [];
    });
  }

  Future<void> _addImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final prefs = await SharedPreferences.getInstance();
      _imagePaths.add(image.path);
      await prefs.setStringList('gallery_images', _imagePaths);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Professional Gallery")),
      floatingActionButton: _isAdmin 
        ? FloatingActionButton(
            onPressed: _addImage,
            backgroundColor: Colors.blueGrey[900],
            child: const Icon(Icons.add_a_photo, color: Colors.white),
          )
        : null,
      body: _imagePaths.isEmpty
          ? const Center(child: Text("No professional photos added yet."))
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _imagePaths.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(File(_imagePaths[index]), fit: BoxFit.cover),
                );
              },
            ),
    );
  }
}