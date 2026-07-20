import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../auth_onboarding/presentation/widgets/common/gradient_button.dart';
import '../../../../providers/profile_provider.dart';
import 'package:get/get.dart';

class AboutExpectationsFormScreen extends StatefulWidget {
  const AboutExpectationsFormScreen({super.key});

  @override
  State<AboutExpectationsFormScreen> createState() => _AboutExpectationsFormScreenState();
}

class _AboutExpectationsFormScreenState extends State<AboutExpectationsFormScreen> {
  final TextEditingController _envisionMarriageController = TextEditingController();
  final TextEditingController _relationshipIslamController = TextEditingController();
  final TextEditingController _roleSpouseController = TextEditingController();
  final TextEditingController _aboutYourselfController = TextEditingController();
  final TextEditingController _envisionSpouseController = TextEditingController();
  final TextEditingController _envisionMarriageSpouseController = TextEditingController();
  final TextEditingController _spouseReligiousStatusController = TextEditingController();
  final TextEditingController _openToRelocateDetailsController = TextEditingController();
  final TextEditingController _otherPreferencesController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExistingData();
    });
  }

  @override
  void dispose() {
    _envisionMarriageController.dispose();
    _relationshipIslamController.dispose();
    _roleSpouseController.dispose();
    _aboutYourselfController.dispose();
    _envisionSpouseController.dispose();
    _envisionMarriageSpouseController.dispose();
    _spouseReligiousStatusController.dispose();
    _openToRelocateDetailsController.dispose();
    _otherPreferencesController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingData() async {
    final profileProvider = context.read<ProfileProvider>();
    await profileProvider.loadBasicInfo();
    
    if (profileProvider.basicInfo != null) {
      final info = profileProvider.basicInfo!;
      setState(() {
        _envisionMarriageController.text = info.envisionMarriage ?? '';
        _relationshipIslamController.text = info.relationshipWithIslam ?? '';
        _roleSpouseController.text = info.roleAsSpouse ?? '';
        _aboutYourselfController.text = info.aboutYourself ?? '';
        _envisionSpouseController.text = info.envisionSpouse ?? '';
        _spouseReligiousStatusController.text = info.spouseReligiousStatusPref ?? '';
        _openToRelocateDetailsController.text = info.openToRelocateDetails ?? '';
        _otherPreferencesController.text = info.otherPreferences ?? '';
      });
    }
  }

  Future<void> _saveAndContinue() async {
    setState(() => _isLoading = true);

    final data = {
      'envision_marriage': _envisionMarriageController.text.isNotEmpty ? _envisionMarriageController.text : null,
      'relationship_with_islam': _relationshipIslamController.text.isNotEmpty ? _relationshipIslamController.text : null,
      'role_as_spouse': _roleSpouseController.text.isNotEmpty ? _roleSpouseController.text : null,
      'about_yourself': _aboutYourselfController.text.isNotEmpty ? _aboutYourselfController.text : null,
      'envision_spouse': _envisionSpouseController.text.isNotEmpty ? _envisionSpouseController.text : null,
      'spouse_religious_status_pref': _spouseReligiousStatusController.text.isNotEmpty ? _spouseReligiousStatusController.text : null,
      'open_to_relocate_details': _openToRelocateDetailsController.text.isNotEmpty ? _openToRelocateDetailsController.text : null,
      'other_preferences': _otherPreferencesController.text.isNotEmpty ? _otherPreferencesController.text : null,
    };

    final profileProvider = context.read<ProfileProvider>();
    final success = await profileProvider.updateBasicInfo(data);

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      Get.showSnackbar(
        const GetSnackBar(
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
          messageText: Text('Updated successfully!'), backgroundColor: Colors.green),
      );
      context.pop();
    } else {
      Get.showSnackbar(
        GetSnackBar(
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
          messageText: Text(profileProvider.errorMessage ?? 'Failed to save data'),
          backgroundColor: Colors.red,
        ),
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
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
                
            const Text(
              'About you & expectations',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
          const Text(
            'Help us understand you better.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info, color: Colors.blue[400], size: 16),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'These fields are optional.', 
                    style: TextStyle(color: Colors.blue[400]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          _buildMultilineTextField(
            label: 'Idea of marriage',
            hint: 'What does marriage mean to you?',
            controller: _envisionMarriageController,
          ),
          const SizedBox(height: 24),
          
          _buildMultilineTextField(
            label: 'Describe your relationship with Islam?',
            hint: 'How do you practice your faith?',
            controller: _relationshipIslamController,
          ),
          const SizedBox(height: 24),
          
          _buildMultilineTextField(
            label: 'How do you envision your role as a spouse?',
            hint: 'What kind of spouse do you want to be?',
            controller: _roleSpouseController,
          ),
          const SizedBox(height: 24),
          
          _buildMultilineTextField(
            label: 'Tell me a bit about yourself?',
            hint: 'Your personality, interests, hobbies...',
            controller: _aboutYourselfController,
          ),
          const SizedBox(height: 24),
          
          _buildMultilineTextField(
            label: 'How do you envision your spouse to be?',
            hint: 'What qualities are you looking for?',
            controller: _envisionSpouseController,
          ),
          const SizedBox(height: 24),
          
          _buildMultilineTextField(
            label: 'How do you envision your marriage to be?',
            hint: 'Your vision of married life...',
            controller: _envisionMarriageSpouseController,
          ),
          const SizedBox(height: 24),
          
          _buildMultilineTextField(
            label: 'Preference on spouse\'s religious status?',
            hint: 'Ex: Must wear hijab, must pray 5 times, etc.',
            controller: _spouseReligiousStatusController,
          ),
          const SizedBox(height: 24),
          
          _buildMultilineTextField(
            label: 'Are you open to relocating?',
            hint: 'Details about relocation preferences...',
            controller: _openToRelocateDetailsController,
          ),
          const SizedBox(height: 24),
          
          _buildMultilineTextField(
            label: 'Any other preferences?',
            hint: 'Anything else you\'d like to mention...',
            controller: _otherPreferencesController,
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
                    onPressed: () => context.pop(),
                    child: const Text('Back', style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GradientButton(
                  text: _isLoading ? 'Saving...' : 'Next',
                  onPressed: _isLoading ? null : _saveAndContinue,
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildMultilineTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}
