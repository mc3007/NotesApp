import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pages/new_note.dart';
import 'package:pages/notesViewer.dart';
import 'package:pages/services/authenticate.dart';

import 'Authentication/logIn.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String refId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Material(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                color: Colors.blue,
                child: DrawerHeader(
                  padding: EdgeInsets.zero,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Welcome",
                        style: TextStyle(
                          fontSize: 40,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Center(
                        child: Text(
                          FirebaseAuth.instance.currentUser.email.toString(),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text('Create New Note'),
                leading: Icon(Icons.note_add,
                  color: Colors.blue,),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return NewNote();
                  }));
                },
              ),
              ListTile(
                title: Text('Settings'),
                leading: Icon(Icons.settings),
                onTap: () {},
              ),
              ListTile(
                title: Text('Log out'),
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.blue,
                ),
                onTap: () async {
                  bool condition = await signOut();
                  if (condition) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return LogIn();
                      }),
                      (route) => false,
                    );
                  }
                },
              ),
              ListTile(
                title: Text('Info'),
                leading: Icon(Icons.info_outline),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text("Pages"),
      ),
      body: Scrollbar(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser.uid)
              .collection('Pages')
              .orderBy('createdOn', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView(
                  children: snapshot.data.docs.map((document) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                refId = document.id;
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return NotesViewer(docId: refId);
                                }));
                              },
                              child: Text(
                                document.data()['title']!=null? document.data()['title']:"(no title)",
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          IconButton(
                              icon: document.data()['isImportant']
                                  ? const Icon(Icons.star)
                                  : const Icon(Icons.star_border),
                              color: document.data()['isImportant']?  Colors.amberAccent: null, onPressed: (){
                                setState(() {
                                  refId=document.id;
                                  FirebaseFirestore.instance.collection('Users').doc(
                                      FirebaseAuth.instance.currentUser.uid)
                                      .collection('Pages')
                                      .doc(refId).update({
                                    'title': document.data()['title'],
                                    'content': document.data()['content'],
                                    'isImportant': !document.data()['isImportant'],
                                  });
                                });
                              }
                              ),
                          PopupMenuButton(
                              itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: FlatButton.icon(
                                          onPressed: () {
                                             refId = document.id;
                                             Navigator.push(context,
                                             MaterialPageRoute(builder: (context) {
                                               return NotesViewer(docId: refId);
                                             }));
                                          },
                                          icon: Icon(Icons.visibility),
                                          label: Text('View')),
                                      value: 1,
                                    ),
                                PopupMenuItem(
                                  child: FlatButton.icon(
                                      onPressed: (){
                                        refId = document.id;
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) {
                                              return EditView(docId: refId);
                                            }));
                                      },
                                      icon: Icon(Icons.edit),
                                      label: Text('Edit')),
                                  value: 2,
                                ),
                                    PopupMenuItem(
                                      child: FlatButton.icon(
                                          onPressed: (){
                                            setState(() {
                                              refId = document.id;
                                              FirebaseFirestore.instance.collection('Users')
                                                  .doc(FirebaseAuth.instance.currentUser.uid)
                                                  .collection('Pages')
                                                  .doc(refId)
                                                  .delete();
                                            });
                                          },
                                          icon: Icon(Icons.delete),
                                          label: Text('Delete')),
                                      value: 3,
                                    ),
                                  ]),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: GestureDetector(
                          onTap: () {
                            refId = document.id;
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return NotesViewer(docId: refId);
                            }));
                          },
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(right:3),
                                  child: Text(
                                    document.data()['content']!=null? document.data()['content']:"(no description)",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Text(
                                document.data()['dateTime'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 2,
                      ),
                    ],
                  ),
                );
                /*ListTile(
                  leading: Icon(Icons.note),
                  title: Text(document.data()['title'].toString()),
                  subtitle: Text(document.data()['content']),
                  trailing: Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.star_border), onPressed: null),
                      IconButton(icon: Icon(Icons.more_vert), onPressed: null),
                    ],
                  ),
                );*/
              }).toList());
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return NewNote();
          }));
        },
        child: Icon(Icons.note_add),
        tooltip: "Add new note",
      ),
    );
  }
}

