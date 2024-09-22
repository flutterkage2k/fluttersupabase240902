import 'package:flutter/material.dart';
import 'package:fluttersupabase240902/models/attendance_model.dart';
import 'package:fluttersupabase240902/services/attendance_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_month_year_picker/simple_month_year_picker.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  @override
  Widget build(BuildContext context) {
    final attendanceService = Provider.of<AttendanceService>(context);

    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 20, top: 60, bottom: 10),
          child: Text(
            "MyAttendance",
            style: TextStyle(fontSize: 25),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              attendanceService.attendanceHistoryMonth,
              style: TextStyle(fontSize: 25),
            ),
            OutlinedButton(
                onPressed: () async {
                  final selectedDate = await SimpleMonthYearPicker.showMonthYearPickerDialog(
                    context: context,
                    disableFuture: true,
                  );
                  String pickedMonth = DateFormat('MMMM yyyy').format(selectedDate);
                  attendanceService.attendanceHistoryMonth = pickedMonth;
                },
                child: Text("Pick a month"))
          ],
        ),
        Expanded(
          child: FutureBuilder(
            future: attendanceService.getAttendanceHistory(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        AttendanceModel attendanceData = snapshot.data[index];
                        return Container(
                          margin: const EdgeInsets.only(top: 12, left: 20, right: 20, bottom: 10),
                          height: 150,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(2, 2)),
                              ],
                              borderRadius: BorderRadius.all(Radius.circular(20))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.redAccent, borderRadius: BorderRadius.all(Radius.circular(20))),
                                  child: Center(
                                    child: Text(
                                      DateFormat("EE \n dd").format(attendanceData.createdAt),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Check in",
                                    style: TextStyle(fontSize: 20, color: Colors.black54),
                                  ),
                                  SizedBox(
                                    width: 80,
                                    child: Divider(),
                                  ),
                                  Text(
                                    attendanceData.checkIn,
                                    style: TextStyle(fontSize: 25),
                                  )
                                ],
                              )),
                              Expanded(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Check Out",
                                    style: TextStyle(fontSize: 20, color: Colors.black54),
                                  ),
                                  SizedBox(
                                    width: 80,
                                    child: Divider(),
                                  ),
                                  Text(
                                    attendanceData.checkOut?.toString() ?? '--/--',
                                    style: TextStyle(fontSize: 25),
                                  )
                                ],
                              )),
                              SizedBox(
                                width: 15,
                              )
                            ],
                          ),
                        );
                      });
                } else {
                  return const Center(
                    child: Text(
                      "No Data Available",
                      style: TextStyle(fontSize: 25),
                    ),
                  );
                }
              }
              return const LinearProgressIndicator(
                backgroundColor: Colors.white,
                color: Colors.grey,
              );
            },
          ),
        ),
      ],
    );
  }
}
