import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../providers/auth_provider.dart';
import '../../../../providers/profile_provider.dart';
import '../../../auth_onboarding/presentation/widgets/common/country_phone_field.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  final TextEditingController _waliNameController = TextEditingController();
  final TextEditingController _waliRelationController = TextEditingController();
  final TextEditingController _waliNumberController = TextEditingController();
  static const List<String> _waliRelationOptions = [
    'Father',
    'Brother',
    'Uncle',
    'Grandfather',
    'Other',
  ];
  String? _selectedWaliRelation;
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;
    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWaliDetails();
    });
  }

  Future<void> _loadWaliDetails() async {
    if (!mounted) return;
    final user = context.read<AuthProvider>().currentUser;
    final role = user?.role.toLowerCase() ?? '';
    if (role != 'female' && role != 'wali') return;

    final profileProvider = context.read<ProfileProvider>();
    if (role == 'wali') {
      await profileProvider.loadWaliProfile();
      if (!mounted) return;
      final wp = profileProvider.waliProfile;
      final fallbackName =
          '${user?.firstName ?? ''} ${user?.lastName ?? ''}'.trim();
      setState(() {
        _waliNameController.text =
            (wp?.waliName != null && wp!.waliName!.isNotEmpty)
                ? wp.waliName!
                : fallbackName;
        final rawRel = wp?.relationToSister?.trim() ?? '';
        if (rawRel.isNotEmpty) {
          final normalized = rawRel[0].toUpperCase() +
              (rawRel.length > 1 ? rawRel.substring(1).toLowerCase() : '');
          _selectedWaliRelation = _waliRelationOptions.contains(normalized)
              ? normalized
              : 'Other';
          _waliRelationController.text = _selectedWaliRelation!;
        }
        _waliNumberController.text = wp?.phone ?? '';
      });
    } else {
      await profileProvider.loadBasicInfo();
      if (!mounted) return;
      final info = profileProvider.basicInfo;
      setState(() {
        _waliNameController.text = info?.waliName ?? '';
        _waliRelationController.text = info?.waliRelation ?? '';
        _waliNumberController.text = info?.waliNumber ?? '';
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _waliNameController.dispose();
    _waliRelationController.dispose();
    _waliNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final profileProvider = context.read<ProfileProvider>();
    final role = authProvider.currentUser?.role.toLowerCase() ?? '';
    final isFemaleOrWali = role == 'female' || role == 'wali';

    if (isFemaleOrWali) {
      final waliRel = role == 'wali'
          ? (_selectedWaliRelation ?? '')
          : _waliRelationController.text.trim();
      if (_waliNameController.text.trim().isEmpty ||
          waliRel.isEmpty ||
          _waliNumberController.text.trim().isEmpty) {
        Get.showSnackbar(
          const GetSnackBar(
            snackPosition: SnackPosition.TOP,
            margin: EdgeInsets.all(16),
            borderRadius: 8,
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
            messageText: Text(
              'Please fill all required Wali fields',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    bool success = true;

    if (_firstNameController.text.trim() != authProvider.currentUser?.firstName ||
        _lastNameController.text.trim() != authProvider.currentUser?.lastName) {
      success = await authProvider.updateProfile(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      );
    }

    if (success && _selectedImage != null) {
      success = await authProvider.updateProfilePicture(imagePath: _selectedImage!.path);
    }

    if (success && role == 'female') {
      success = await profileProvider.updateBasicInfo({
        'wali_name': _waliNameController.text.trim(),
        'wali_relation': _waliRelationController.text.trim(),
        'wali_number': _waliNumberController.text.trim(),
      });
    } else if (success && role == 'wali') {
      success = await profileProvider.updateWaliProfile({
        'wali_name': _waliNameController.text.trim(),
        'relation_to_sister': (_selectedWaliRelation ?? 'other').toLowerCase(),
        'phone': _waliNumberController.text.trim(),
      });
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      if (success) {
        Get.showSnackbar(
          const GetSnackBar(
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.all(16),
          borderRadius: 8,
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
          messageText: Text(
            'Profile updated successfully',
            style: TextStyle(color: Colors.white),
          )),
        );
        context.pop();
      } else {
        Get.showSnackbar(
          GetSnackBar(
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
          messageText: Text(
            profileProvider.errorMessage ??
                authProvider.errorMessage ??
                'Failed to update profile',
            style: const TextStyle(color: Colors.white),
          )),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final role = user?.role.toLowerCase() ?? '';
    final isFemaleOrWali = role == 'female' || role == 'wali';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(onPressed: () => context.pop()),
        title: const Text('Edit Profile', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: _selectedImage != null
                          ? Image.file(_selectedImage!, fit: BoxFit.cover)
                          : (user?.profilePicture != null && user!.profilePicture!.isNotEmpty)
                              ? CachedNetworkImage(
                                  imageUrl: user.profilePicture!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
                                  errorWidget: (context, url, error) => const Icon(Icons.person, size: 50, color: Colors.grey),
                                )
                              : const Icon(Icons.person, size: 50, color: Colors.grey),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1),
                          ],
                        ),
                        child: const Icon(Icons.camera_alt_outlined, size: 16, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${user?.firstName ?? ''} ${user?.lastName ?? ''}'.trim(),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Text(
                user?.email ?? '',
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(height: 40),
              
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Personal Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              ),
              const SizedBox(height: 24),
              
              _buildEditableField('First Name', _firstNameController, isRequired: true),
              const SizedBox(height: 24),
              
              _buildEditableField('Last Name', _lastNameController, isRequired: true),

              if (isFemaleOrWali) ...[
                const SizedBox(height: 32),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Wali (Guardian) Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildEditableField('Wali Name', _waliNameController, isRequired: true),
                const SizedBox(height: 20),
                if (role == 'wali')
                  _buildWaliRelationDropdown()
                else
                  _buildEditableField(
                    'Wali Relation',
                    _waliRelationController,
                    isRequired: true,
                  ),
                const SizedBox(height: 20),
                CountryPhoneField(
                  controller: _waliNumberController,
                  label: 'Wali Contact Number',
                  hintText: 'Guardian contact number',
                  isRequired: true,
                ),
              ],

              const SizedBox(height: 40),
              
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8C9EFF), Color(0xFFE5A8B6)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: _isLoading 
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWaliRelationDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text.rich(
          TextSpan(
            text: 'Wali Relation',
            style: TextStyle(color: Colors.black54),
            children: [
              TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedWaliRelation,
              isExpanded: true,
              hint: const Text('Select relation to sister'),
              items: _waliRelationOptions
                  .map((rel) => DropdownMenuItem(value: rel, child: Text(rel)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedWaliRelation = value;
                  _waliRelationController.text = value ?? '';
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditableField(
    String label,
    TextEditingController controller, {
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: const TextStyle(color: Colors.black54),
            children: isRequired
                ? const [
                    TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
                  ]
                : const [],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: (value) => value == null || value.trim().isEmpty ? 'Please enter $label' : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFEEEEEE),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          ),
          style: const TextStyle(color: Colors.black87),
        ),
      ],
    );
  }
}
