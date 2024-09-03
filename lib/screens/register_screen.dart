import 'package:flutter/material.dart';
import 'package:fluttersupabase240902/services/auth_service.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            height: screenHeight / 4,
            width: screenWidth,
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(70),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                  size: 80,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Deamyoungpallet",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    label: Text("Employee Email Id"),
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  controller: _emailController,
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    label: Text("Password"),
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  controller: _passwordController,
                  obscureText: true,
                ),
                SizedBox(
                  height: 30,
                ),
                Consumer<AuthService>(
                  builder: (context, authServiceProvider, child) {
                    return SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: authServiceProvider.isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                authServiceProvider.registerEmployee(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                  context,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                              child: Text(
                                "계정 생성",
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                            ),
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
