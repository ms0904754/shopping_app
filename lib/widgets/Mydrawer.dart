import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/provider/productlist.dart';
import 'package:shopping_app/screens/order_screen.dart';
import 'package:shopping_app/screens/user_controlscreen.dart';

class MyDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final data = Provider.of<products>(context);
    return Drawer(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(child: Center(child: Text("Hello !",style: Theme.of(context).textTheme.titleSmall)),color: Colors.indigo,height: 100,width: double.infinity,),
        ),
        ListTile(
          leading: Icon(Icons.shop,color: Colors.deepPurple,size: 30,),
          title: Text("Shop",style: TextStyle(fontSize: 20,fontFamily: 'Merriweather',fontWeight: FontWeight.bold),),
          selectedColor: Colors.deepPurple,
          selected: data.firs,
          onTap: () {
            data.firs = data.selector();
            data.sec=false;
            data.third=false;
            Navigator.of(context).pushReplacementNamed('/');

          },
        ),
        Divider(thickness: 1,),
        ListTile(
          leading: Icon(Icons.payment_outlined,color: Colors.deepPurple,size: 30,),
          title: Text("Order",style: TextStyle(fontSize: 20,fontFamily: 'Merriweather',fontWeight: FontWeight.bold)),
          selectedColor: Colors.deepPurple,
          selected: data.sec,
          onTap: () {
            data.sec=data.selector();

            data.firs=false;
            data.third=false;
            Navigator.of(context).pushReplacementNamed(order_screen.routename);

          },
        ),
        Divider(thickness: 1,),
        ListTile(
          leading: Icon(Icons.edit,color: Colors.deepPurple,size: 30,),
          title: Text("User Manage",style: TextStyle(fontSize: 20,fontFamily: 'Merriweather',fontWeight: FontWeight.bold)),
          selectedColor: Colors.deepPurple,
          selected: data.third,
          onTap: () {
            data.third=data.selector();
            data.firs=false;
            data.sec=false;
            Navigator.of(context).pushReplacementNamed(userScreen.routename);

          },
        )
      ],),
    );
  }
}
