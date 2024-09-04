import 'package:flutter/material.dart';
import 'package:fluttersupabase240902/services/db_service.dart';
import 'package:fluttersupabase240902/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  final DbService _dbService = DbService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future registerEmployee(String email, String password, BuildContext context) async {
    try {
      setIsLoading = true;
      if (email == "" || password == "") {
        throw ("모든 칸을 채워야합니다. ");
      }
      final AuthResponse response = await _supabase.auth.signUp(email: email, password: password);
      if (response != null) {
        await _dbService.inserNewUser(email, response.user!.id);
        Utils.showSnackBar(
          "성공! 이제 로그인을 할 수 있습니다.",
          context,
          color: Colors.green,
        );
        await loginEmployee(email, password, context);
        Navigator.pop(context);
      }
    } catch (e) {
      setIsLoading = false;
      Utils.showSnackBar(e.toString(), context, color: Colors.red);
    }
  }

  Future loginEmployee(String email, String password, BuildContext context) async {
    try {
      setIsLoading = true;
      if (email == "" || password == "") {
        throw ("모든 칸을 채워야합니다. ");
      }
      final AuthResponse response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      setIsLoading = false;
    } catch (e) {
      setIsLoading = false;
      Utils.showSnackBar(e.toString(), context, color: Colors.red);
    }
  }

  Future signOut() async {
    await _supabase.auth.signOut();
    notifyListeners();
  }

  User? get currentUser => _supabase.auth.currentUser;
}
