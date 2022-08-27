import 'package:flutter/material.dart';

class buttonicon extends StatelessWidget {
  final String value;
  final child;
  buttonicon({required this.value,required this.child});

  @override
  Widget build(BuildContext context) {
    print(value);
    return (value=='0')?child:Stack(children: [
      child,
      Positioned(
      top: 5,
      right: 10,
      child: Container(decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.red
      ),
        child: Text(value,textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),
        constraints: BoxConstraints(
          minHeight: 16,
          minWidth: 16,
        ),
      ),

      ),

    ],);
  }
}
