import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_keep/Providers/colors.dart';
import 'package:google_keep/Screens/homepage.dart';
import 'package:google_keep/Screens/note_view.dart';
import 'package:google_keep/Services/db.dart';
import 'package:google_keep/model/model.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class EditNoteView extends StatefulWidget {
  KeepNote note;
  EditNoteView({Key? key, required this.note}) : super(key: key);

  @override
  State<EditNoteView> createState() => _EditNoteViewState();
}

class _EditNoteViewState extends State<EditNoteView> {
  String newTitle = '';
  String newNote = '';
  Color currentColor = Colors.amber;
  void changeColor(Color color) => setState(() => currentColor = color);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.newTitle = widget.note.title.toString();
    this.newNote = widget.note.content.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            onPressed: () async {
              KeepNote LatestNote = KeepNote(
                pin: widget.note.pin,
                title: newTitle,
                content: newNote,
                createdTime: widget.note.createdTime,
                id: widget.note.id,
                isArchieve: widget.note.isArchieve,
                
              );
              await KeepNotesDatabase.instance.updateNote(LatestNote);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            },
            splashRadius: 20.w,
            icon: Icon(Icons.save_outlined),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                child: TextFormField(
                  initialValue: newTitle,
                  cursorColor: white,
                  onChanged: (value) {
                    newTitle = value;
                  },
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
                      color: Colors.grey.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
              Container(
                height: 400.h,
                child: Form(
                  child: TextFormField(
                    initialValue: newNote,
                    cursorColor: white,
                    onChanged: (value) {
                      newNote = value;
                    },
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
                        color: Colors.grey.withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
