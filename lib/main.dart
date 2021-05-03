
import 'package:flutter/material.dart';
import 'package:flutter_chat_online/chat_screan.dart';

void main() async {

    runApp(MyApp());



    /*
    // escrever dados no banco
    Firestore.instance.collection('mensagem').document('msg2').collection('arquivos').document().setData({
      'arqname' : 'foto.png',
    });

    //ler os dados 1 vez só
    QuerySnapshot snapshot = await Firestore.instance.collection('mensagens').getDocuments();
    snapshot.documents.forEach((d) {
      print('--------------snapshot----------------------');
      print(d.data);

    });
    //saber de um id em especifico
    DocumentSnapshot snapshot1 = await Firestore.instance.collection('mensagens')
        .document('9yMnr2Rem6KVK1GBnLe1').get();
    print('---------------snapshot1---------------------');
    print(snapshot1.data);

    //
    QuerySnapshot snapshot2 = await Firestore.instance.collection('mensagens').getDocuments();
    snapshot.documents.forEach((d) {
      print('---------------snapshot2---------------------');
      print(d.data);
      print(d.documentID);
    });

    QuerySnapshot snapshot3 = await Firestore.instance.collection('mensagens').getDocuments();
    snapshot.documents.forEach((d) {
      d.reference.updateData({'lido' : false});
    });

   // atualização em tempo real
    Firestore.instance.collection('mensagens').snapshots().listen((dado) {
      //print(dado.documents[0].data);
      dado.documents.forEach((d) {
        print(d.data);
      });
    });

    Firestore.instance.collection('mensagens').document('jcfCHv30kkMHWSgRCkLm')
  .snapshots().listen((dado) {
    print(dado.data);
    });

    */
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        iconTheme:  IconThemeData(
          color: Colors.blue,
        )
      ),
      home: ChatScrean(),
    );
  }
}