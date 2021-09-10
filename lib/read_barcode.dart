library read_barcode;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The below class listen to the keyboard events
/// and it return string of every keyboard event.
/// It will notify to the parent class whenever
/// key event occurs.
class BarcodeReader with ChangeNotifier {
  String? keycode = '';
  DateTime? _lastScannedTime;
  Duration _buffer = Duration(milliseconds: 100);
  late StreamSubscription<String?> _keySubscription;
  final _keyController = StreamController<String?>();

  BarcodeReader() {
    RawKeyboard.instance.addListener(_keyboardEvent);
    _keySubscription =
        _keyController.stream.where((char) => char != null).listen(onEvent);
  }

  /// This function called for every [RawKeyEvent] for every keyboard event.
  void _keyboardEvent(RawKeyEvent keyEvent) {
    if (keyEvent.logicalKey.keyId > 255 &&
        keyEvent.data.logicalKey != LogicalKeyboardKey.enter) {
      return;
    }
    if (keyEvent is RawKeyUpEvent) {
      if (keyEvent.data.logicalKey == LogicalKeyboardKey.enter) {
      } else if (keyEvent.data is RawKeyEventDataAndroid ||
          keyEvent.data is RawKeyEventDataIos ||
          keyEvent.data is RawKeyEventDataWeb ||
          keyEvent.data is RawKeyEventDataWindows ||
          keyEvent.data is RawKeyEventDataMacOs ||
          keyEvent.data is RawKeyEventDataLinux ||
          keyEvent.data is RawKeyEventDataFuchsia
      ) {
        _keyController.sink.add(keyEvent.data.keyLabel);
        keycode = (keycode! + keyEvent.data.keyLabel.toString());
      }
    }
  }

  /// This function responsible for notifying to the
  /// parent listeners and clears the keycode
  /// for every buffer time(100ms).
  void onEvent(String? char) {
    notifyListeners();
    checkKeyCodeToClear(char);
    _lastScannedTime = DateTime.now();
  }

  /// This function calls reset keycode function if buffer time is over.
  void checkKeyCodeToClear(String? char) {
    if (_lastScannedTime != null) {
      if (_lastScannedTime!.isBefore(DateTime.now().subtract(_buffer))) {
        resetKeyCode(char);
      }
    }
  }

  /// This function resets the keycode.
  void resetKeyCode(String? char) {
    _lastScannedTime = null;
    this.keycode = char;
  }
}
