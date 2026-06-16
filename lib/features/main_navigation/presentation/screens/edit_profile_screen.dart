import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: const DecorationImage(
                      image: AssetImage('assets/profileImage.png'), // Profile avatar
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
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
            const SizedBox(height: 16),
            const Text('Kader Molla', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 4),
            const Text('kader@gmail.com', style: TextStyle(color: Colors.black54, fontSize: 14)),
            const SizedBox(height: 40),
            
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Personal Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: Row(
                children: const [
                  Icon(Icons.lock_outline, size: 14, color: Color(0xFFE57C04)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Name and Gender cannot be changed after registration.',
                      style: TextStyle(fontSize: 12, color: Color(0xFFE57C04)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            _buildReadOnlyField('Full Name', 'James'),
            const SizedBox(height: 24),
            
            _buildReadOnlyDropdownField('Gender', 'Male'),
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
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: value),
          readOnly: true,
          enabled: false,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFEEEEEE),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            suffixIcon: const Icon(Icons.lock_outline, size: 16, color: Colors.grey),
          ),
          style: const TextStyle(color: Colors.black45),
        ),
      ],
    );
  }

  Widget _buildReadOnlyDropdownField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(value, style: const TextStyle(color: Colors.black45)),
              ),
              const Icon(Icons.lock_outline, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }
}
