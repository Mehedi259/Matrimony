import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../widgets/common/gradient_button.dart';
import '../widgets/onboarding/step_progress_indicator.dart';
import '../../../../providers/profile_provider.dart';

class UploadPhotosScreen extends StatefulWidget {
  const UploadPhotosScreen({super.key});

  @override
  State<UploadPhotosScreen> createState() => _UploadPhotosScreenState();
}

class _UploadPhotosScreenState extends State<UploadPhotosScreen> {
  final ImagePicker _picker = ImagePicker();
  List<String> _localImagePaths = [];
  bool _isUploading = false;

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _uploadAllPhotos() async {
    if (_localImagePaths.isEmpty) {
      // No new photos to upload, just continue
      context.push('/subscription-plans');
      return;
    }

    setState(() => _isUploading = true);

    final profileProvider = context.read<ProfileProvider>();
    int successCount = 0;
    int failCount = 0;

    for (int i = 0; i < _localImagePaths.length; i++) {
      final imagePath = _localImagePaths[i];
      final isPrimary = i == 0 && profileProvider.photos.isEmpty; // First photo as primary if no photos exist

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
        SnackBar(
          content: Text('$successCount photo(s) uploaded successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      context.push('/subscription-plans');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$successCount uploaded, $failCount failed'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _removeLocalImage(int index) {
    setState(() {
      _localImagePaths.removeAt(index);
    });
  }

  Future<void> _deleteUploadedPhoto(String photoId) async {
    final profileProvider = context.read<ProfileProvider>();
    final success = await profileProvider.deletePhoto(photoId);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Photo deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(profileProvider.errorMessage ?? 'Failed to delete photo'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final uploadedPhotos = profileProvider.photos;
    final totalPhotos = uploadedPhotos.length + _localImagePaths.length;
    final canAddMore = totalPhotos < 6;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
              
          const Text(
            'Upload Your Photos',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your privacy is our priority. Photos stay hidden and are only revealed with your consent. Photo exchanges are protected from screenshots and automatically expire after one minute.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
          ),
          const SizedBox(height: 8),
          Text(
            'Photos: $totalPhotos/6',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
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
            itemCount: 6,
            itemBuilder: (context, index) {
              // Show uploaded photos first
              if (index < uploadedPhotos.length) {
                final photo = uploadedPhotos[index];
                return _buildUploadedPhotoCard(photo.imageUrl, photo.id, photo.isPrimary);
              }
              
              // Show local photos being uploaded
              final localIndex = index - uploadedPhotos.length;
              if (localIndex < _localImagePaths.length) {
                return _buildLocalPhotoCard(_localImagePaths[localIndex], localIndex);
              }
              
              // Show empty placeholder
              return _buildPhotoPlaceholder(canAddMore);
            },
          ),
          const SizedBox(height: 32),
          
          if (canAddMore)
            Container(
              width: 200,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFB4BCE4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton.icon(
                onPressed: _isUploading ? null : _pickImage,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Add More Photos',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          const SizedBox(height: 48),
          
          const Divider(),
          const SizedBox(height: 24),
          
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: _isUploading ? null : () => context.push('/subscription-plans'),
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GradientButton(
                  text: _isUploading ? 'Uploading...' : 'Next',
                  onPressed: _isUploading ? null : _uploadAllPhotos,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadedPhotoCard(String imageUrl, String photoId, bool isPrimary) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isPrimary ? Theme.of(context).primaryColor : Colors.grey[300]!,
              width: isPrimary ? 3 : 2,
            ),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (isPrimary)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Primary',
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => _deleteUploadedPhoto(photoId),
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

  Widget _buildLocalPhotoCard(String imagePath, int index) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[300]!, width: 2),
            image: DecorationImage(
              image: FileImage(File(imagePath)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => _removeLocalImage(index),
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
        Positioned(
          bottom: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Not uploaded',
              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoPlaceholder(bool canAdd) {
    return GestureDetector(
      onTap: canAdd && !_isUploading ? _pickImage : null,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              canAdd ? Icons.upload_outlined : Icons.check_circle_outline,
              color: canAdd ? Colors.black87 : Colors.green,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              canAdd ? 'Add Photo' : 'Full',
              style: TextStyle(
                color: canAdd ? Colors.black54 : Colors.green,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
