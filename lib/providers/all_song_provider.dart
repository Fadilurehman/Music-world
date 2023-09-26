import 'package:flutter/material.dart';
import 'package:music/sections/search.dart';
import 'package:permission_handler/permission_handler.dart';

class AllsongsProvider with ChangeNotifier {
  void requestPermission() async {
    bool permissionStatus = await audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await audioQuery.permissionsRequest();
    }

    Permission.storage.request();
  }
}
