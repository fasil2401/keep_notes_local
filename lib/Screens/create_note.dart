import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_keep/Components/custom_widgets.dart';
import 'package:google_keep/Providers/colors.dart';
import 'package:google_keep/Providers/notification.dart';
import 'package:google_keep/Screens/homepage.dart';
import 'package:google_keep/Services/db.dart';
import 'package:google_keep/model/model.dart';
import 'package:intl/intl.dart';

class CreateNoteView extends StatefulWidget {
  const CreateNoteView({Key? key}) : super(key: key);

  @override
  State<CreateNoteView> createState() => _CreateNoteViewState();
}

class _CreateNoteViewState extends State<CreateNoteView> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  Color currentColor = Colors.amber;
  void changeColor(Color color) => setState(() => currentColor = color);
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  DateFormat dateFormat = DateFormat('dd MMM yyyy');
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    title.dispose();
    content.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (content.text.isNotEmpty) {
          await KeepNotesDatabase.instance.InsertEntry(
            KeepNote(
              title: title.text,
              content: content.text,
              pin: false,
              createdTime: DateTime.now(),
              isArchieve: false,
             
            ),
          );
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }
        if (selectedDate != null) {
          createReminderNotification(
              DateTime(
                  selectedDate!.year,
                  selectedDate!.month,
                  selectedDate!.day,
                  selectedTime!.hour,
                  selectedTime!.minute,
                  00),
              title: title.text,
              note: content.text);
        } else {
          Navigator.pop(context);
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0.0,
          actions: [
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => Container(
                          child: BlockPicker(
                              pickerColor: currentColor,
                              onColorChanged: changeColor),
                        ));
              },
              child: CircleAvatar(
                radius: 15,
              ),
            ),
            IconButton(
              onPressed: () {
                showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 5))
                    .then((value) {
                  if (value != null) {
                    selectedDate = value;
                    showTimePicker(
                            context: context,
                            initialTime: selectedTime ?? TimeOfDay.now())
                        .then((value) {
                      if (value != null) {
                        selectedTime = value;
                        setState(() {});
                      }
                    });
                  }
                });
              },
              icon: const Icon(Icons.notifications_active_outlined),
              splashRadius: 20,
            )
            // IconButton(
            //     onPressed: () async {
            //       await KeepNotesDatabase.instance.InsertEntry(
            //         KeepNote(
            //           title: title.text,
            //           content: content.text,
            //           pin: false,
            //           createdTime: DateTime.now(),
            //           isArchieve: false,
            //         ),
            //       );
            //       Navigator.pushReplacement(context,
            //           MaterialPageRoute(builder: (context) => HomePage()));
            //     },
            //     splashRadius: 20.w,
            //     icon: Icon(Icons.save_outlined))
          ],
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: title,
                  cursorColor: white,
                  style: const TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: "Title",
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.withOpacity(0.8))),
                ),
                Container(
                  height: 400.h,
                  child: TextField(
                    controller: content,
                    cursorColor: white,
                    keyboardType: TextInputType.multiline,
                    minLines: 50,
                    maxLines: null,
                    style: TextStyle(fontSize: 17, color: Colors.white),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "Note",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.withOpacity(0.8))),
                  ),
                ),
                (selectedDate != null)
                    ? FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Icon(Icons.alarm),
                                SizedBox(
                                  width: 5,
                                ),
                                CustomText(
                                    textData:
                                        '${dateFormat.format(selectedDate!)} ${selectedTime!.format(context)}',
                                    textSize: 16),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
