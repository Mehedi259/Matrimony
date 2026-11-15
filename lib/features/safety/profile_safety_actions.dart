import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';

/// Menu values shared by profile screens.
class ProfileSafetyAction {
  static const hide = 'hide';
  static const block = 'block';
  static const report = 'report';
}

/// Standard "more" menu items for another member's profile.
List<PopupMenuEntry<String>> profileSafetyMenuItems() => const [
      PopupMenuItem(value: ProfileSafetyAction.hide, child: Text('Hide Profile')),
      PopupMenuItem(value: ProfileSafetyAction.block, child: Text('Block Profile')),
      PopupMenuItem(value: ProfileSafetyAction.report, child: Text('Report Profile')),
    ];

/// Runs hide / block / report against the backend (wishlists app).
/// Returns true when the profile should be closed (hidden or blocked).
Future<bool> handleProfileSafetyAction(
  BuildContext context, {
  required String action,
  required String targetUserId,
}) async {
  switch (action) {
    case ProfileSafetyAction.hide:
      return _toggle(context, ApiConstants.hideToggle, targetUserId,
          title: 'Hide this profile?',
          body: 'You won\'t see this profile in your browse results. You can undo this later.',
          confirm: 'Hide',
          done: 'Profile hidden.');
    case ProfileSafetyAction.block:
      return _toggle(context, ApiConstants.blockToggle, targetUserId,
          title: 'Block this member?',
          body: 'You won\'t see each other and they can\'t contact you.',
          confirm: 'Block',
          done: 'Member blocked.');
    case ProfileSafetyAction.report:
      await _report(context, targetUserId);
      return false;
  }
  return false;
}

Future<bool> _toggle(BuildContext context, String path, String id,
    {required String title, required String body, required String confirm, required String done}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
        TextButton(
          onPressed: () => Navigator.pop(c, true),
          child: Text(confirm, style: const TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
  if (ok != true || !context.mounted) return false;
  try {
    await ApiClient().post(path, data: {'target_user_id': id});
    _toast(context, done);
    return true;
  } catch (e) {
    _toast(context, _errorText(e), error: true);
    return false;
  }
}

const _reasons = {
  'child_safety': 'Child safety concern',
  'harassment': 'Harassment',
  'inappropriate': 'Inappropriate content or behaviour',
  'fake_profile': 'Fake profile',
  'spam': 'Spam',
  'other': 'Other',
};

Future<void> _report(BuildContext context, String id) async {
  String? reason;
  final details = TextEditingController();
  final submit = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (c) => StatefulBuilder(
      builder: (c, setState) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(c).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Report profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Reports are confidential and reviewed by our team.',
                style: TextStyle(color: Colors.black54, fontSize: 13)),
            const SizedBox(height: 12),
            ..._reasons.entries.map((e) => RadioListTile<String>(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  value: e.key,
                  groupValue: reason,
                  title: Text(e.value),
                  onChanged: (v) => setState(() => reason = v),
                )),
            TextField(
              controller: details,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Add details (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: reason == null ? null : () => Navigator.pop(c, true),
                child: const Text('Submit report'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  if (submit != true || reason == null || !context.mounted) return;
  try {
    await ApiClient().post(ApiConstants.reportProfile,
        data: {'target_user_id': id, 'reason': reason, 'details': details.text.trim()});
    _toast(context, 'Thank you. Our team will review this report.');
  } catch (e) {
    _toast(context, _errorText(e), error: true);
  }
}

String _errorText(Object e) {
  if (e is DioException && e.response?.data is Map) {
    final d = e.response!.data as Map;
    final msg = d['detail'] ?? d['error'] ?? d['message'] ?? d.values.first;
    return msg is List ? msg.join(' ') : msg.toString();
  }
  return 'Something went wrong. Please try again.';
}

void _toast(BuildContext context, String msg, {bool error = false}) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg), backgroundColor: error ? Colors.red[700] : null),
  );
}
