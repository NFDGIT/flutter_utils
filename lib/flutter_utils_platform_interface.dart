import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_utils_method_channel.dart';

abstract class FlutterUtilsPlatform extends PlatformInterface {
  /// Constructs a FlutterUtilsPlatform.
  FlutterUtilsPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterUtilsPlatform _instance = MethodChannelFlutterUtils();

  /// The default instance of [FlutterUtilsPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterUtils].
  static FlutterUtilsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterUtilsPlatform] when
  /// they register themselves.
  static set instance(FlutterUtilsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
