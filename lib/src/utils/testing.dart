import 'dart:io';

bool get isTesting => Platform.environment.containsKey('FLUTTER_TEST');
