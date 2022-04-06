import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_keep/Services/db.dart';
import 'package:google_keep/model/model.dart';


class FireDB {

createNewNoteFirestore(KeepNote note, String id) async{

  await FirebaseFirestore.instance.collection("notes").doc("fasil2401@gmail.com").collection("usernotes").doc(id).set(
  {
    "Title" : note.title,
    "content" : note.content,
    "date" : note.createdTime,

  }).then((_){
    print("DATA ADDED SUCCESSFULLY");
  });
}




getAllStoredNotes() async{
  List docs = [];
    await FirebaseFirestore.instance.collection("notes").doc("fasil2401@gmail.com").collection("usernotes").orderBy("date").get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      // print(result.data());
      // // Map note = result.data();
      // print(result.data()["title"]);

      Map note = result.data();
      docs.add(note);
      
      // print(note["Title"]);
      KeepNotesDatabase.instance.InsertEntry(KeepNote(pin: false, isArchieve: false, title: note["Title"], content: note["content"], createdTime: note["date"]));
    });
  });
   
}

updateNoteFirestore(KeepNote note ) async{
   await FirebaseFirestore.instance
        .collection("notes")
        .doc("fasil2401@gmail.com").collection("usernotes").doc(note.id.toString())
        .update({"Title": note.title.toString() , "content" : note.content}).then((_) {
      print("DATA ADDED SUCCESFULLY");
    });
}

deleteNoteFirestore(KeepNote note) async{
    await FirebaseFirestore.instance.collection("notes").doc("fasil2401@gmail.com").collection("usernotes").doc(note.id.toString()).delete().then((_) {
    print("DATA DELETED SUCCESS FULLY");
  });
}

}