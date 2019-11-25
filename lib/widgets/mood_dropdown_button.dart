import 'package:flutter/material.dart';



class MoodDropdownButton extends StatefulWidget {
  final void Function(String value) parentAction;

  MoodDropdownButton(this.parentAction);

  @override
  _MoodDropdownButtonState createState() => _MoodDropdownButtonState();
}

class _MoodDropdownButtonState extends State<MoodDropdownButton> {
  String dropdownValue = '😀';
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
          value: dropdownValue,
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.deepPurple),
          // underline: Container(
          //   height: 2,
          //   color: Colors.deepPurpleAccent,
          // ),
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
              widget.parentAction(dropdownValue);
            });
          },
          items: <String>['😀', '🤣', '🥰', '😍', '😔', '😢', '🤬', '🤮', '🤔', '🙄']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(fontSize: 30),),
            );
          }).toList(),
        );
      
  }
}