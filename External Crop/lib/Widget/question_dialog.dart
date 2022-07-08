import 'package:flutter/material.dart';
import 'package:external_crop/Utils/constants.dart';

class QuestionDialog extends StatelessWidget {

  //When creating please recheck 'context' if there is an error!

  Color _color = Colors.green.shade100;//Color.fromARGB(220, 186, 178 ,57);

  String _title="";
  String _content="";
  String _yes="";
  String _no="";
  Function _yesOnPressed;
  Function _noOnPressed;

  QuestionDialog({String title, String content, Function yesOnPressed, Function noOnPressed, String yes = "Yes", String no = "No"}){
    this._title = title;
    this._content = content;
    this._yesOnPressed = yesOnPressed;
    this._noOnPressed = noOnPressed;
    this._yes = yes;
    this._no = no;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text(this._title),
      content: new Text(this._content),
      backgroundColor: this._color,
      shape:
      RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
      actions: <Widget>[
        new FlatButton(
          child: new Text(this._yes),
          textColor: Colors.black,
          onPressed: () {
            this._yesOnPressed();
          },
        ),
        new FlatButton(
          child: Text(this._no),
          textColor: Colors.black,
          onPressed: () {
            this._noOnPressed();
          },
        ),
      ],
    );
  }
}