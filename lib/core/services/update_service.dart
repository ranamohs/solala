import 'dart:io';
import 'package:in_app_update/in_app_update.dart';
import 'package:upgrader/upgrader.dart';

class UpdateService {
  Future<void> checkForUpdates() async {
    if (Platform.isAndroid) {
      await _checkAndroidUpdate();
    }
    // For iOS, Upgrader usually handles it via UI components,
    // but we can also trigger a manual check if needed.
  }

  Future<void> _checkAndroidUpdate() async {
    try {
      final info = await InAppUpdate.checkForUpdate();
      print('Android Update Availability: ${info.updateAvailability}');
      print('Immediate Update Allowed: ${info.immediateUpdateAllowed}');
      print('Flexible Update Allowed: ${info.flexibleUpdateAllowed}');
      print('Available Version Code: ${info.availableVersionCode}');

      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        if (info.immediateUpdateAllowed) {
          await InAppUpdate.performImmediateUpdate();
        } else if (info.flexibleUpdateAllowed) {
          await InAppUpdate.startFlexibleUpdate();
          await InAppUpdate.completeFlexibleUpdate();
        }
      }
    } catch (e) {
      // Log error or handle it silently
      print('Android In-App Update Error: $e');
    }
  }
}
