import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UploadPhotoFormScreen extends StatelessWidget {
  const UploadPhotoFormScreen({super.key});

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
            Row(
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
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1, // Square
              children: [
                _buildPhotoSlot(context),
                _buildPhotoSlot(context),
                _buildPhotoSlot(context),
                _buildPhotoSlot(context),
              ],
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
                onPressed: () {},
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
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Next', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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
    return Container(
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
    );
  }
}
