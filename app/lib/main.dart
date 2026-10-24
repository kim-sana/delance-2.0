import 'package:flutter/material.dart';

import 'app.dart';
import 'mock/mock_target.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DelanceApp(target: MockTarget.fromEnvironment()));
}
