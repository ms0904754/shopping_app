import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/screens/edit_screen.dart';

import '../provider/productlist.dart';

class user_item extends StatelessWidget {
  final String id;
  final String title;
  final String image;
  user_item(this.title,this.image, this.id);


  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(image)),
      title: Text(title,style: Theme.of(context).textTheme.labelSmall,),
      trailing: FittedBox(
        fit: BoxFit.cover,
        child: Row(
          children: [
            IconButton(onPressed: () {
              Navigator.of(context).pushNamed(edit_screen.routename,arguments: id);
            }, icon: Icon(Icons.edit,color: Colors.indigo,)),
            IconButton(onPressed: () async{
                try{
                  await Provider.of<products>(context,listen: false).deletedproduct(id);
                } catch(_){
                  print(_);
                  scaffold.showSnackBar(SnackBar(content: Text("Delete Failed!"),duration: Duration(seconds: 1),));
                }
              }, icon: Icon(Icons.delete,color: Colors.red,
        ),
      ),
      ]))
    );
  }
}
