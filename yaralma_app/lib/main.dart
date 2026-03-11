import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';

/// Supabase URL and anon key. Replace with your project values from Supabase Dashboard.
/// For local dev you can use placeholder values; the app will run but auth/data will fail until set.
const String _supabaseUrl = '';
const String _supabaseAnonKey = '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (_supabaseUrl.isNotEmpty && _supabaseAnonKey.isNotEmpty) {
    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _supabaseAnonKey,
    );
  }

  runApp(const YaralmaApp());
}
