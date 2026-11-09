import 'package:flutter/material.dart';

import 'app.dart';
import 'core/constants/api_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize stored IP settings
  await ApiConfig.init();

  runApp(const SylParkApp());
}
