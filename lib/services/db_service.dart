import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttersupabase240902/constants/constants.dart';
import 'package:fluttersupabase240902/models/department_model.dart';
import 'package:fluttersupabase240902/models/user_model.dart';
import 'package:fluttersupabase240902/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DbService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  UserModel? userModel;
  List<DepartmentModel> allDepartments = [];
  int? employeeDepartment;

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

  Future<UserModel> getUserData() async {
    final userData =
        await _supabase.from(Constants.employeeTable).select().eq('id', _supabase.auth.currentUser!.id).single();
    userModel = UserModel.fromJson(userData);
    employeeDepartment == null ? employeeDepartment = userModel?.department : null;
    return userModel!;
  }

  Future<void> getAllDepartments() async {
    final List result = await _supabase.from(Constants.departmentTable).select();
    allDepartments = result.map((department) => DepartmentModel.fromJson(department)).toList();
    notifyListeners();
  }

  Future updateProfile(String name, BuildContext context) async {
    await _supabase.from(Constants.employeeTable).update({
      'name': name,
      'department': employeeDepartment,
    }).eq('id', _supabase.auth.currentUser!.id);

    Utils.showSnackBar("Profile Updated Successfully", context, color: Colors.green);
    notifyListeners();
  }
}
