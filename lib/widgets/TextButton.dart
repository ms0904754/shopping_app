import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';
import '../provider/order.dart';

class Button extends StatefulWidget {

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  var indicator = false;
  @override
  Widget build(BuildContext context) {
    var cont = context;
    final scaffold = ScaffoldMessenger.of(context);
    final cart = Provider.of<Cart>(context);
    return TextButton(onPressed: (cart.totalamt<=0)?null:() async {
      setState(() {
        indicator = true;
      });
     try{
       await Provider.of<Orders>(context,listen: false).addorder(cart.items.values.toList(),cart.totalamt);           // we do listen false because we dont want to change in order , we only want to dispatch it
       cart.clearcart();
       setState(() {
         indicator=false;
       });
     } catch(_){
        setState(() {
          indicator=false;
        });
        return showDialog(context: cont, builder: (_) {
          return  AlertDialog(title: Text("Order Can't Placed"),content: Text("Please try again later",style: Theme.of(context).textTheme.bodySmall,),actions: [
            TextButton(onPressed: () {Navigator.of(context).pop();}, child: Text("ok"))
          ],);
        });

        // scaffold.showSnackBar(SnackBar(content: Center(child: Text("Can't Placed Order")),duration: Duration(seconds: 1),));
      }
    }, child: (indicator)?CircularProgressIndicator():Text('Order Now',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
      ,style: ButtonStyle(textStyle: MaterialStateProperty.all(TextStyle(fontSize: 20))),
    );
  }
}