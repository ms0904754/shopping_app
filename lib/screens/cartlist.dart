import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/provider/cart.dart';

class cartlist extends StatelessWidget {

  final String id;
  final double price;
  final String title;
  final  int quantity;
  cartlist(this.title,this.id,this.price, this.quantity);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(context: context, builder: (context) =>
        AlertDialog(title: Text("Are You Sure?",style: Theme.of(context).textTheme.bodyMedium),
        content: Text("Do you Want to Remove the item from Cart",style: Theme.of(context).textTheme.bodySmall),
        actions: [
          TextButton(onPressed: () {
            Navigator.of(context).pop(false);
          }, child: Text("No",style: Theme.of(context).textTheme.displayMedium)),
          TextButton(onPressed: () {
            Navigator.of(context).pop(true);
          }, child: Text("Yes",style: Theme.of(context).textTheme.displayMedium)),
        ],));
      },
      key: ValueKey(id),
      background: Container(child: Icon(Icons.delete,size: 40,color: Colors.white),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.red),  //margin and decoration vaise hi dedo jaise card me diya hai jisse match kare
          margin: EdgeInsets.all(10)),
      onDismissed: (Direction) {
        Provider.of<Cart>(context,listen: false).removeitem(id);   // we only want to access dont want to listen to change the ui
      print(id);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
       color: Colors.white,
        margin: EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: FittedBox(child: Text('\ ${price}')),
            ),backgroundColor: Colors.deepPurple,foregroundColor: Colors.white,maxRadius: 20,),
            title: Text(title,style: Theme.of(context).textTheme.labelSmall,),
            subtitle: Text("Total = \₹${price*quantity}"),
            trailing: Container(decoration: BoxDecoration(shape: BoxShape.rectangle,color: Colors.deepPurple),child: Center(child: FittedBox(child: Text('×${quantity}',style: TextStyle(color: Colors.white),))),height: 30,width: 30,),
          ),
        )
      ),
    );
  }
}
