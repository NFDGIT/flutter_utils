import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/flutter_utils_platform_interface.dart';
import 'package:flutter_utils/flutter_utils_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterUtilsPlatform
    with MockPlatformInterfaceMixin
    implements FlutterUtilsPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterUtilsPlatform initialPlatform = FlutterUtilsPlatform.instance;

  test('$MethodChannelFlutterUtils is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterUtils>());
  });

  test('getPlatformVersion', () async {
    FlutterUtils flutterUtilsPlugin = FlutterUtils();
    MockFlutterUtilsPlatform fakePlatform = MockFlutterUtilsPlatform();
    FlutterUtilsPlatform.instance = fakePlatform;

    expect(await flutterUtilsPlugin.getPlatformVersion(), '42');
  });
}
