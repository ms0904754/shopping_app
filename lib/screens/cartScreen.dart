import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/provider/cart.dart';
import '../provider/order.dart';
import '../widgets/TextButton.dart';
import 'cartlist.dart';

class cartScreen extends StatelessWidget {
  static const routename = "/cartscreen";
  var indicator = false;

  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<Cart>(context);
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.9),
      appBar: AppBar(
        title: Text("My Cart"),
        centerTitle: true,
      ),
      body: Column(
          children: [
          SizedBox(
            height: MediaQuery.of(context).size.height*0.13,
            child: Card(
              color: Colors.white,
              elevation: 2,
              margin: EdgeInsets.all(12),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround
                  ,children: [
                    SizedBox(width: 5,),
                Text("Total",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                Spacer(),        //spacer space available kara ta hai jitna ho sake
                Chip(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  label: Text("\₹${cart.totalamt.toStringAsFixed(2)}",style: TextStyle(fontSize: 18,color: Colors.white),),
                ),
                Button()
              ]
              ),
            ),
          ),
            Expanded(
              child: ListView.builder(itemBuilder: (context,index) {
                    return cartlist(cart.items.values.toList()[index].title, cart.items.values.toList()[index].id, cart.items.values.toList()[index].price, cart.items.values.toList()[index].quantity);   // argument na dalke apan consumer ka bhi use kar sakte hai

              },
                  itemCount: cart.items.length,),
                ),
          ],),
    );
  }
}




// Row(
// children: [
// Text('title'),
// Container(decoration: BoxDecoration(shape: BoxShape.rectangle,color: Colors.orangeAccent),child: Text("1",style: TextStyle(color: Colors.white),),)
// ],
// )






// Baseline(
// baseline: MediaQuery.of(context).size.height*0.82,
// baselineType: TextBaseline.alphabetic,
// child: Container(
// height: MediaQuery.of(context).size.height*0.13,
// // color: Colors.red,
// child: Card(
// color: Colors.white70,
// elevation: 2,
// margin: EdgeInsets.all(16),
// child: Row(children: [
// SizedBox(width: 30,),
// Text("Total",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
// SizedBox(width: 50,),
// Chip(
// label: Text("\₹${cart.totalamt}",style: TextStyle(fontSize: 18),),
// ),
// SizedBox(width: MediaQuery.of(context).size.width*0.20,),
// ElevatedButton(onPressed: () {}, child:  Text("Buy",style: TextStyle(fontSize: 18),),
// style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
// foregroundColor: MaterialStateProperty.all(Colors.white),
// shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))),
// )
// ]
// ),
// ),
// ),
// ),