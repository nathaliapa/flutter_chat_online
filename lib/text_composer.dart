import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {

  TextComposer(this.sendMenssage);
  final Function({String text, File imgFile}) sendMenssage;

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {

  final TextEditingController _controller = TextEditingController();
  bool _isComposing = false;

  void _reset(){
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          IconButton(
              onPressed: () async{
              // ignore: deprecated_member_use
              final File imgFile = await ImagePicker.pickImage(source: ImageSource.gallery);
              if(imgFile == null) return;
              widget.sendMenssage(imgFile: imgFile);
              },
              icon: Icon(Icons.photo_camera),
          ),
          Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration.collapsed(hintText: 'mandare un messaggio'),
                onChanged: (text){
                  setState(() {
                    _isComposing = text.isNotEmpty;
                  });
                },
                onSubmitted: (text){
                  widget.sendMenssage(text: text);
                  _reset();
                },
              ),
          ),
          IconButton(
              onPressed: _isComposing ? (){
                widget.sendMenssage(text: _controller.text);
                _reset();
              } : null,
              icon: Icon(
                  Icons.send,
                  color: Colors.amber),
          ),
        ],
      ),
    );
  }
}
