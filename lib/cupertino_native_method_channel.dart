import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'cupertino_native_platform_interface.dart';
import 'components/alert_models.dart';

/// An implementation of [CupertinoNativePlatform] that uses method channels.
class MethodChannelCupertinoNative extends CupertinoNativePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('cupertino_native');

  @override
  /// See [CupertinoNativePlatform.getPlatformVersion].
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<CNAlertResult?> showAlert({
    String? title,
    String? message,
    List<CNAlertAction> actions = const [],
    List<CNAlertTextField> textFields = const [],
  }) async {
    final result = await methodChannel
        .invokeMapMethod<String, dynamic>('showAlert', {
          if (title != null) 'title': title,
          if (message != null) 'message': message,
          'actions': actions.map((a) => a.toMap()).toList(),
          'textFields': textFields.map((t) => t.toMap()).toList(),
        });

    if (result == null) {
      return null;
    }

    return CNAlertResult.fromMap(result);
  }
}
