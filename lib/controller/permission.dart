import 'package:permission_handler/permission_handler.dart';

class Permissions {
  bool _checkStatus(PermissionStatus status) {
    if (status.isDenied ||
        status.isRestricted ||
        status.isPermanentlyDenied ||
        status.isLimited) {
      return false;
    }
    return true;
  }

  Future<bool> requestLocation() async {
    PermissionStatus ps = await Permission.location.status;
    if (_checkStatus(ps)) {
      return true;
    } else {
      await Permission.location.request();
    }
    ps = await Permission.location.status;
    return _checkStatus(ps);
  }

  Future<bool> checkLocation() async {
    return _checkStatus(await Permission.location.status);
  }
}
