import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  Future<bool> notificationPermNeeded() async {
    PermissionStatus status = await Permission.notification.status;
    return !status.isGranted;
  }

  Future<bool> requestNotification() async {
    PermissionStatus status = await Permission.notification.request();
    if (status.isPermanentlyDenied) openAppSettings();
    return status.isGranted;
  }
}
