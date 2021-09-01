import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NewNote extends StatefulWidget {
  @override
  _NewNoteState createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {

  String dateTime = DateFormat('kk:mm\nd MMM y').format(DateTime.now());
  bool isImportant=false;
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  CollectionReference ref = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("Pages");

  void clearText() {
    title.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'cancel',
        ),
        title: Text('New Note'),
        actions: <Widget>[
          IconButton(
            icon:isImportant
                ? const Icon(Icons.star)
                : const Icon(Icons.star_border),
            color: isImportant?  Colors.amberAccent: null,
            onPressed: (){
              setState(() {
                isImportant=!isImportant;
              });
            },
            tooltip: 'prioritize',
          ),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if(title!=null && content!=null){
                ref.add({
                  'title': title.text,
                  'content': content.text,
                  'dateTime': dateTime,
                  'isImportant':isImportant,
                  'createdOn':FieldValue.serverTimestamp(),
                }).whenComplete(() => Navigator.pop(context));
              }
            },
            tooltip: 'save if done',
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              TextField(
                controller: title,
                maxLines: null,
                style: TextStyle(decoration: TextDecoration.none),
                decoration: InputDecoration(
                    labelText: 'Title',
                    suffixIcon: IconButton(
                        icon: Icon(Icons.clear), onPressed: clearText),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Expanded(
                  child: TextField(
                    controller: content,
                    maxLines: null,
                    decoration: InputDecoration(
                        labelText: 'Notes',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
