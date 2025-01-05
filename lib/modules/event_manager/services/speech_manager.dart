import 'dart:developer';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:tick_tock/app/config.dart';
import 'package:tick_tock/shared/utils/permission_handler.dart';

class SpeechToTextManager {
  final SpeechToText speech = SpeechToText();

  final ValueNotifier<bool> speechState = ValueNotifier<bool>(false);

  bool get isRunning => speechState.value;

  Future<bool> _initialize(VoidCallback callback) async {
    try {
      return await speech.initialize(
        onStatus: (text) {
          if (text == 'listening') {
            speechState.value = true;
          } else {
            speechState.value = false;
            callback();
          }
        },
        onError: (errorNotification) {
          log('error: $errorNotification');
          speechState.value = false;
          callback();
        },
        debugLogging: kDebugMode,
      );
    } catch (e) {
      log('speech_init', error: e);
    }
    return false;
  }

  void run({
    required void Function(String) onResult,
    required void Function() onComplete,
    required void Function(String) onFailure,
  }) async {
    bool hasPermission = await PermissionHandler().requestMicrophone();
    if (!hasPermission) return onFailure('Microphone permission needed');
    final available = await _initialize(onComplete);

    if (available) {
      speech.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
        },
      );
    } else {
      onFailure('Speech recognition not available on this device');
    }
  }

  void stop() {
    speech.stop();
  }

  void dispose() {
    speech.stop();
    speechState.dispose();
  }
}
