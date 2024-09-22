import 'package:flutter/material.dart';
import 'package:fluttersupabase240902/constants/constants.dart';
import 'package:fluttersupabase240902/models/attendance_model.dart';
import 'package:fluttersupabase240902/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  AttendanceModel? attendanceModel;

  String todayDate = DateFormat("dd MMMM yyyy").format(DateTime.now());

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _attendanceHistoryMonth = DateFormat('MMMM yyyy').format(DateTime.now());
  String get attendanceHistoryMonth => _attendanceHistoryMonth;

  set attendanceHistoryMonth(String value) {
    _attendanceHistoryMonth = value;
    notifyListeners();
  }

  Future getTodayAttendance() async {
    final List result = await _supabase
        .from(Constants.attendanceTable)
        .select()
        .eq("employee_id", _supabase.auth.currentUser!.id)
        .eq('date', todayDate);

    if (result.isNotEmpty) {
      attendanceModel = AttendanceModel.fromJson(result.first);
    }
    notifyListeners();
  }

  Future markAttendance(BuildContext context) async {
    if (attendanceModel?.checkIn == null) {
      await _supabase.from(Constants.attendanceTable).insert({
        'employee_id': _supabase.auth.currentUser!.id,
        'date': todayDate,
        'check_in': DateFormat('HH:mm').format(DateTime.now())
      });
    } else if (attendanceModel?.checkOut == null) {
      await _supabase
          .from(Constants.attendanceTable)
          .update({
            'check_out': DateFormat('HH:mm').format(DateTime.now()),
          })
          .eq('employee_id', _supabase.auth.currentUser!.id)
          .eq('date', todayDate);
    } else {
      Utils.showSnackBar("You have already checked out today!", context, color: Colors.redAccent);
    }
    getTodayAttendance();
  }

  Future<List<AttendanceModel>> getAttendanceHistory() async {
    final List data = await _supabase
        .from(Constants.attendanceTable)
        .select()
        .eq('employee_id', _supabase.auth.currentUser!.id)
        .textSearch('date', "'$attendanceHistoryMonth'", config: 'english')
        .order('created_at', ascending: false);

    return data.map((attendance) => AttendanceModel.fromJson(attendance)).toList();
  }
}
