import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttersupabase240902/constants/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DbService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  String generateRendomEmployeeId() {
    final random = Random();
    const allChars = "abcdefgigjhi123456789";
    final randomString = List.generate(8, (index) => allChars[random.nextInt(allChars.length)]).join();
    return randomString;
  }

  Future inserNewUser(String email, var id) async {
    await _supabase.from(Constants.employeeTable).insert({
      'id': id,
      'name': '',
      'email': email,
      'employee_id': generateRendomEmployeeId(),
      'department': null,
    });
  }
}
