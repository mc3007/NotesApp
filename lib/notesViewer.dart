import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotesViewer extends StatefulWidget {

  final String docId;

  NotesViewer({Key key, this.docId}) : super(key: key);

  @override
  _NotesViewerState createState() => _NotesViewerState();
}

class _NotesViewerState extends State<NotesViewer> {

  String title="(no title)";
  String content="(no content)";
  String dateTime;
  bool isImportant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes viewer'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'back',
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.delete), onPressed: () {
            Navigator.pop(context);
            FirebaseFirestore.instance.collection('Users')
                .doc(FirebaseAuth.instance.currentUser.uid)
                .collection('Pages')
                .doc(widget.docId)
                .delete();
          }),
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                      return EditView(docId: widget.docId);
                    }));
              }
          ),
        ],
      ),
      body: Scrollbar(
          child: SingleChildScrollView(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseAuth.instance.currentUser.uid)
                  .collection('Pages')
                  .doc(widget.docId)
                  .snapshots(),
              builder:
                  (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if(snapshot.connectionState==ConnectionState.active){
                  dynamic data = snapshot.data;
                  title = data['title']==null ? title : data['title'];
                  content = data['content']==null ? content :data['content'];
                  dateTime = data['dateTime'];
                  isImportant=data['isImportant'];

                  return Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Title',
                              ),
                              Icon(isImportant
                                  ?  Icons.star
                                  :  Icons.star_border,
                                color: isImportant?  Colors.amberAccent: null,),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 2,
                                color: Colors.lightBlue
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            title,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Description',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2,
                                  color: Colors.lightBlue
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Text(
                              content,
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            dateTime,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  );
                }else if(snapshot.connectionState==ConnectionState.waiting){
                  return Center(

                      child: CircularProgressIndicator());
                }else {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.warning),
                        ),
                        Text('Error in loading data')
                      ],
                    ),
                  );
                }
              },
            ),
          )),
    );
  }
}

//Edit screen on edit button pressed
class EditView extends StatefulWidget {

  final String docId;

  EditView({Key key, this.docId}) : super(key: key);

  @override
  _EditViewState createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {

  String title;
  String content;
  String dateTime;
  bool isImportant;

  String newTitle ;
  String newContent ;

  void update(){
    FirebaseFirestore.instance.collection('Users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('Pages')
        .doc(widget.docId)
        .update({
           'title': title,
           'content': content,
           'isImportant': isImportant,
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Notes'),
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'back',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              FirebaseFirestore.instance.collection('Users').doc(
                  FirebaseAuth.instance.currentUser.uid)
                  .collection('Pages')
                  .doc(widget.docId).update({
                  'title': title,
                  'content': content,
                 'isImportant': isImportant,
              }).whenComplete(() => Navigator.pop(context));
            },
          ),
        ],
      ),
      body: Scrollbar(
          child: SingleChildScrollView(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseAuth.instance.currentUser.uid)
                  .collection('Pages')
                  .doc(widget.docId)
                  .snapshots(),
              builder:
                  (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                 if(snapshot.connectionState==ConnectionState.active){
                   dynamic data = snapshot.data;
                   title = data['title'];
                   content = data['content'];
                   dateTime = data['dateTime'];
                   isImportant=data['isImportant'];
                   return Container(
                     padding: EdgeInsets.all(10),
                     child: Column(
                       children: <Widget>[
                         Container(
                           alignment: Alignment.topRight,
                           child: IconButton(
                             icon:isImportant
                                 ? const Icon(Icons.star)
                                 : const Icon(Icons.star_border),
                             color: isImportant?  Colors.amberAccent: null,
                             onPressed: (){
                               setState(() {
                                 isImportant=!isImportant;
                                 update();
                               });
                             },
                           ),
                         ),
                         TextFormField(
                           maxLines: null,
                           initialValue: title,
                           onChanged: (String value){
                             title=value;
                             update();
                           },
                           decoration: InputDecoration(
                               labelText: 'Title',
                               border: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(5.0))),
                         ),
                         Padding(
                           padding: const EdgeInsets.symmetric(vertical: 10),
                           child: TextFormField(
                             maxLines: null,
                             initialValue: content,
                             onChanged: (String value){
                               content=value;
                               update();
                             },
                             decoration: InputDecoration(
                                 labelText: 'Description',
                                 border: OutlineInputBorder(
                                     borderRadius: BorderRadius.circular(5.0))),
                           ),
                         ),
                         Container(
                           alignment: Alignment.bottomRight,
                           child: Text(
                             dateTime,
                             textAlign: TextAlign.center,
                             style: TextStyle(fontSize: 10),
                           ),
                         ),
                       ],
                     ),
                   );
                 } else if(snapshot.connectionState==ConnectionState.waiting){
                   return Center(
                       child: CircularProgressIndicator());
                 }else {
                   return Container(
                     child: Column(
                       children: <Widget>[
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Icon(Icons.warning),
                         ),
                         Text('Error in loading data')
                       ],
                     ),
                   );
                 }
              },
            ),
          )),
    );
  }
}

