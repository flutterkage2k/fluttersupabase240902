import 'package:flutter/material.dart';
import 'package:fluttersupabase240902/models/department_model.dart';
import 'package:fluttersupabase240902/services/auth_service.dart';
import 'package:fluttersupabase240902/services/db_service.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();

  // int selectedVaule = 0;

  @override
  Widget build(BuildContext context) {
    final dbService = Provider.of<DbService>(context);
    dbService.allDepartments.isEmpty ? dbService.getAllDepartments() : null;
    nameController.text.isEmpty ? nameController.text = dbService.userModel?.name ?? '' : null;

    return Scaffold(
      body: dbService.userModel == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      alignment: Alignment.topRight,
                      child: TextButton.icon(
                        onPressed: () {
                          Provider.of<AuthService>(context, listen: false).signOut();
                        },
                        icon: Icon(Icons.logout),
                        label: Text("Sign out"),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 80),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.redAccent,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text("Employee ID : ${dbService.userModel?.employeeId}"),
                    SizedBox(height: 30),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        label: Text(""),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    dbService.allDepartments.isEmpty
                        ? LinearProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                value: dbService.employeeDepartment ?? dbService.allDepartments.first.id,
                                items: dbService.allDepartments.map((DepartmentModel item) {
                                  return DropdownMenuItem(
                                      value: item.id,
                                      child: Text(
                                        item.title,
                                        style: TextStyle(fontSize: 20),
                                      ));
                                }).toList(),
                                onChanged: (selectedVaule) {
                                  dbService.employeeDepartment = selectedVaule;
                                }),
                          ),
                    SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            dbService.updateProfile(nameController.text.trim(), context);
                          },
                          child: Text(
                            "Update Profile",
                            style: TextStyle(fontSize: 20),
                          )),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
