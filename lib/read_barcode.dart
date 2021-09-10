library read_barcode;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  void _keyboardEvent(RawKeyEvent keyEvent) {
    if (keyEvent.logicalKey.keyId > 255 &&
        keyEvent.data.logicalKey != LogicalKeyboardKey.enter) {
      return;
    }
    if (keyEvent is RawKeyUpEvent) {
      if (keyEvent.data.logicalKey == LogicalKeyboardKey.enter) {
      } else if (keyEvent.data is RawKeyEventDataAndroid) {
        _keyController.sink.add(keyEvent.data.keyLabel);
        keycode = (keycode! + keyEvent.data.keyLabel.toString());
      } else if (keyEvent.data is RawKeyEventDataFuchsia) {
        _keyController.sink.add(keyEvent.data.keyLabel);
        keycode = (keycode! + keyEvent.data.keyLabel.toString());
      } else if (keyEvent.data is RawKeyEventDataWindows) {
        _keyController.sink.add(keyEvent.data.keyLabel);
        keycode = (keycode! + keyEvent.data.keyLabel.toString());
      } else if (keyEvent.data is RawKeyEventDataWeb) {
        _keyController.sink.add(keyEvent.data.keyLabel);
        keycode = (keycode! + keyEvent.data.keyLabel.toString());
      } else if (keyEvent.data is RawKeyEventDataIos) {
        _keyController.sink.add(keyEvent.data.keyLabel);
        keycode = (keycode! + keyEvent.data.keyLabel.toString());
      } else if (keyEvent.data is RawKeyEventDataMacOs) {
        _keyController.sink.add(keyEvent.data.keyLabel);
        keycode = (keycode! + keyEvent.data.keyLabel.toString());
      } else if (keyEvent.data is RawKeyEventDataLinux) {
        _keyController.sink.add(keyEvent.data.keyLabel);
        keycode = (keycode! + keyEvent.data.keyLabel.toString());
      }
    }
  }

  void onEvent(String? char) {
    notifyListeners();
    checkKeyCodeToClear(char);
    _lastScannedTime = DateTime.now();
  }

  void checkKeyCodeToClear(String? char) {
    if (_lastScannedTime != null) {
      if (_lastScannedTime!.isBefore(DateTime.now().subtract(_buffer))) {
        resetKeyCode(char);
      }
    }
  }

  void resetKeyCode(String? char) {
    _lastScannedTime = null;
    this.keycode = char;
  }
}
