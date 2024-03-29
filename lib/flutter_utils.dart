// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'package:flutter/foundation.dart';

import 'flutter_utils_platform_interface.dart';

class FlutterUtils {
  Future<String?> getPlatformVersion() {
    return FlutterUtilsPlatform.instance.getPlatformVersion();
  }
}

/// 重试函数
Future<T?> retry<T>({int intervalSecond = 60, int maxCount = 20, required Future<T?> Function() retryBlock}) async {
  T? result; // retry 获取的结果
  int retryCount = 0; // 尝试的次数
  while (retryCount < maxCount && result == null) {
    try {
      if (intervalSecond > 0 && retryCount != 0) {
        await Future.delayed(Duration(seconds: intervalSecond));
      }
      retryCount += 1;
      result = await retryBlock();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
  return result;
}
