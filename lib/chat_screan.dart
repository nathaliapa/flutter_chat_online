import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_online/chat_message.dart';
import 'package:flutter_chat_online/text_composer.dart';
import 'package:google_sign_in/google_sign_in.dart';


class ChatScrean extends StatefulWidget {
  @override
  _ChatScreanState createState() => _ChatScreanState();
}

class _ChatScreanState extends State<ChatScrean> {

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseUser _currentUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
        setState(() {
          _currentUser = user;
        });
    });
  }

  Future<FirebaseUser> _getUser() async {

    if(_currentUser != null) return _currentUser;

    try{
        final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
        final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.getCredential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken
        );

        final AuthResult authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

        final FirebaseUser user = authResult.user;
        return user;

    } catch(error){
        return null;
    }
  }

  void _sendMessage({String text,File imgFile}) async{

    final FirebaseUser user = await _getUser();

    if(user == null ){
      // ignore: deprecated_member_use
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
              content: Text('Não foi possivel fazer login. Tente novamente !'),
              backgroundColor: Colors.red,
          )
      );
    }

    Map<String, dynamic> data = {
      'uid': user.uid,
      'senderName' : user.displayName,
      'senderPhotoUrl' : user.photoUrl,
      'time': Timestamp.now(),

    };

    if(imgFile != null){
      StorageUploadTask task = FirebaseStorage.instance.ref().child(user.uid).child(
          DateTime.now().millisecondsSinceEpoch.toString()
      ).putFile(imgFile);

      setState(() {
        _isLoading = true;
      });

      StorageTaskSnapshot taskSnapshot = await task.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();
      print(url);
      data['imgUrl'] = url;

      setState(() {
        _isLoading = false;
      });
    }

    if(text != null) data['text'] = text;

    Firestore.instance.collection('messages').add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          _currentUser != null ? 'Ciau, ${_currentUser.displayName}' : 'Chat app'
        ),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          _currentUser != null ? IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: (){
                FirebaseAuth.instance.signOut();
                googleSignIn.signOut();
                _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text('Voce saiu com sucesso'),
                    )
                );
              },
          ) : Container()
        ],
      ),

      body: Column(
        children: <Widget>[
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('messages').orderBy('time').snapshots(),
                builder: (context, snapshot){
                  switch(snapshot.connectionState){
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    default:
                      List<DocumentSnapshot> documents =
                          snapshot.data.documents.reversed.toList();

                      return ListView.builder(
                        itemCount: documents.length,
                          reverse: true,
                          itemBuilder: (context , index){
                            return ChatMessage(documents[index].data,
                            documents[index].data['uid'] == _currentUser?.uid
                            );
                          }
                          );
                  }
                },
              )),
          _isLoading ? LinearProgressIndicator() : Container(),
          TextComposer(_sendMessage),
        ],
      ),
    );

  }
}
