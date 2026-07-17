import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../../../providers/profile_provider.dart';

class UploadPhotoFormScreen extends StatefulWidget {
  const UploadPhotoFormScreen({super.key});

  @override
  State<UploadPhotoFormScreen> createState() => _UploadPhotoFormScreenState();
}

class _UploadPhotoFormScreenState extends State<UploadPhotoFormScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<String> _localImagePaths = [];
  bool _isUploading = false;

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _localImagePaths.add(image.path);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _uploadAllPhotos() async {
    if (_localImagePaths.isEmpty) {
      context.pop();
      return;
    }

    setState(() => _isUploading = true);

    final profileProvider = context.read<ProfileProvider>();
    int successCount = 0;
    int failCount = 0;

    for (int i = 0; i < _localImagePaths.length; i++) {
      final imagePath = _localImagePaths[i];
      final isPrimary = i == 0 && profileProvider.photos.isEmpty;

      final success = await profileProvider.uploadPhoto(imagePath, isPrimary: isPrimary);
      
      if (success) {
        successCount++;
      } else {
        failCount++;
      }
    }

    setState(() => _isUploading = false);

    if (!mounted) return;

    if (failCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$successCount photo(s) uploaded successfully!'), backgroundColor: Colors.green),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$successCount uploaded, $failCount failed'), backgroundColor: Colors.orange),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Progress Tracker
            FittedBox(
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStep(context, 'Step 1', isActive: true),
                _buildStepLine(isActive: true),
                _buildStep(context, 'Step 2', isActive: true),
                _buildStepLine(isActive: true),
                _buildStep(context, 'Step 3', isActive: true),
                _buildStepLine(isActive: true),
                _buildStep(context, 'Step 4', isActive: true),
                _buildStepLine(),
                _buildStep(context, 'Step 5'),
              ],
            ),
            ),
            const SizedBox(height: 32),
            
            // Title & Subtitle
            const Text('Upload Your Photo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 8),
            const Text(
              'Your privacy is our priority. Photos stay hidden and\nare only revealed with your consent. Photo\nexchanges are protected from screenshots and\nautomatically expire after one minute.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 32),
            
            // Photo Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                if (index < _localImagePaths.length) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: FileImage(File(_localImagePaths[index])),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
                return _buildPhotoSlot(context);
              },
            ),
            const SizedBox(height: 24),
            
            // Add More Photos Button
            Container(
              width: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFB5B7D7), // Muted purple/blue background
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF8C9EFF).withOpacity(0.5)),
              ),
              child: ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.add, color: Colors.white, size: 20),
                label: const Text('Add More Photos', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 16),
            
            // Bottom Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context.pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEEF0F2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Text('Skip', style: TextStyle(color: Color(0xFF9C91B8), fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8C9EFF), Color(0xFFE5A8B6)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: _isUploading ? null : _uploadAllPhotos,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: _isUploading 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Next', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, String text, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).primaryColor.withOpacity(0.6) : const Color(0xFFF2F4F7),
        shape: BoxShape.circle,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black54,
          fontSize: 10,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildStepLine({bool isActive = false}) {
    return Container(
      width: 20,
      height: 2,
      color: isActive ? const Color(0xFFCD868A) : const Color(0xFFF2F4F7),
    );
  }

  Widget _buildPhotoSlot(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.file_upload_outlined, color: Colors.black87, size: 24),
            SizedBox(height: 8),
            Text('Add Photo', style: TextStyle(color: Colors.black54, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
