import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../../../providers/profile_provider.dart';
import '../../../../data/models/profile/basic_info_model.dart';
import 'package:get/get.dart';

class UploadPhotoFormScreen extends StatefulWidget {
  const UploadPhotoFormScreen({super.key});

  @override
  State<UploadPhotoFormScreen> createState() => _UploadPhotoFormScreenState();
}

class _UploadPhotoFormScreenState extends State<UploadPhotoFormScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<String> _localImagePaths = [];
  bool _isUploading = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExistingPhotos();
    });
  }

  Future<void> _loadExistingPhotos() async {
    final profileProvider = context.read<ProfileProvider>();
    await profileProvider.loadPhotos();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

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
      Get.showSnackbar(
        GetSnackBar(
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
          messageText: Text('Failed to pick image: $e'), backgroundColor: Colors.red),
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
      Get.showSnackbar(
        GetSnackBar(
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
          messageText: Text('$successCount photo(s) uploaded successfully!'), backgroundColor: Colors.green),
      );
      context.pop();
    } else {
      Get.showSnackbar(
        GetSnackBar(
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
          messageText: Text('$successCount uploaded, $failCount failed'), backgroundColor: Colors.orange),
      );
    }
  }

  Future<void> _deletePhoto(String photoId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Photo'),
        content: const Text('Are you sure you want to delete this photo?'),
        actions: [
          TextButton(onPressed: () => ctx.pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => ctx.pop(true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmed == true) {
      final profileProvider = context.read<ProfileProvider>();
      final success = await profileProvider.deletePhoto(photoId);
      if (mounted) {
        Get.showSnackbar(
          GetSnackBar(
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
          messageText: Text(success ? 'Photo deleted' : 'Failed to delete photo'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final existingPhotos = profileProvider.photos;
    final totalPhotos = existingPhotos.length + _localImagePaths.length;
    final maxSlots = totalPhotos < 4 ? 4 : totalPhotos + 2; // Always show at least 4 slots

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title & Subtitle
                  const Text('Upload Your Photo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 8),
                  Text(
                    '${existingPhotos.length + _localImagePaths.length} of 6 photos added',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your privacy is our priority. Photos stay hidden and\nare only revealed with your consent.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54, fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 24),

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
                    itemCount: maxSlots,
                    itemBuilder: (context, index) {
                      // Show existing API photos first
                      if (index < existingPhotos.length) {
                        final photo = existingPhotos[index];
                        return Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  image: NetworkImage(photo.imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // Primary badge
                            if (photo.isPrimary)
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text('Primary', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            // Delete button
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () => _deletePhoto(photo.id),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      // Show locally picked (not yet uploaded) photos
                      final localIndex = index - existingPhotos.length;
                      if (localIndex >= 0 && localIndex < _localImagePaths.length) {
                        return Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  image: FileImage(File(_localImagePaths[localIndex])),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // "New" badge
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text('New', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            // Remove button
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _localImagePaths.removeAt(localIndex);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      // Empty slot
                      return _buildPhotoSlot(context);
                    },
                  ),
                  const SizedBox(height: 24),

                  // Add More Photos Button
                  if (totalPhotos < 6)
                    Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: const Color(0xFFB5B7D7),
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
                          child: const Text('Back', style: TextStyle(color: Color(0xFF9C91B8), fontWeight: FontWeight.bold, fontSize: 16)),
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
                                : Text(
                                    _localImagePaths.isEmpty ? 'Done' : 'Upload',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
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
