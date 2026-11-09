import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_protector/screen_protector.dart';

/// Global service to manage screenshot and screen recording prevention
/// across the entire application.
class ScreenProtectionService {
  static void Function()? _customScreenshotCallback;
  static void Function(bool)? _customRecordCallback;
  static bool _isInitialized = false;

  /// Initialize global screenshot and screen recording protection across the entire app
  static Future<void> init() async {
    try {
      await ScreenProtector.preventScreenshotOn();
      await ScreenProtector.protectDataLeakageWithColor(Colors.black);

      if (!_isInitialized) {
        _setupListeners();
        _isInitialized = true;
      }
    } catch (e) {
      debugPrint('ScreenProtectionService init error: $e');
    }
  }

  /// Ensure protection is still on (e.g. on app resume from background)
  static Future<void> ensureProtection() async {
    try {
      await ScreenProtector.preventScreenshotOn();
      await ScreenProtector.protectDataLeakageWithColor(Colors.black);
    } catch (e) {
      debugPrint('ScreenProtectionService ensureProtection error: $e');
    }
  }

  /// Set temporary custom listener (e.g. inside photo view to close photo on screenshot attempt)
  static void setCustomListeners({
    void Function()? onScreenshot,
    void Function(bool)? onRecord,
  }) {
    _customScreenshotCallback = onScreenshot;
    _customRecordCallback = onRecord;
  }

  /// Clear custom listener and restore default global behavior
  static void clearCustomListeners() {
    _customScreenshotCallback = null;
    _customRecordCallback = null;
  }

  static void _setupListeners() {
    ScreenProtector.addListener(() {
      if (_customScreenshotCallback != null) {
        _customScreenshotCallback!();
      } else {
        showScreenshotBlockedNotice();
      }
    }, (isCaptured) {
      if (_customRecordCallback != null) {
        _customRecordCallback!(isCaptured);
      } else if (isCaptured) {
        showScreenRecordingBlockedNotice();
      }
    });
  }

  /// Global notification informing user that screenshots are blocked
  static void showScreenshotBlockedNotice() {
    Get.showSnackbar(
      const GetSnackBar(
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.all(16),
        borderRadius: 8,
        duration: Duration(seconds: 4),
        messageText: Text(
          'Screenshots are blocked to preserve identity and privacy.',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Color(0xFFE54B5E),
      ),
    );
  }

  /// Global notification informing user that screen recording is blocked
  static void showScreenRecordingBlockedNotice() {
    Get.showSnackbar(
      const GetSnackBar(
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.all(16),
        borderRadius: 8,
        duration: Duration(seconds: 4),
        messageText: Text(
          'Screen recording is blocked to preserve identity and privacy.',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Color(0xFFE54B5E),
      ),
    );
  }
}
