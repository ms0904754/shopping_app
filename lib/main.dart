import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/provider/Auth.dart';
import 'package:shopping_app/provider/cart.dart';
import 'package:shopping_app/provider/order.dart';
import 'package:shopping_app/provider/productlist.dart';
import 'package:shopping_app/screens/cartScreen.dart';
import 'package:shopping_app/screens/edit_screen.dart';
import 'package:shopping_app/screens/order_screen.dart';
import 'package:shopping_app/screens/product_detail.dart';
import 'package:shopping_app/screens/products_screen.dart';
import 'package:shopping_app/screens/userLogin.dart';
import 'package:shopping_app/screens/user_controlscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      // ChangeNotifierProvider(create: (context) => Auth()),           //this is necesaary to use the provider or consumer
      ChangeNotifierProvider.value(value: Auth()),
      ChangeNotifierProxyProvider<Auth,products>(create: (context) => products("","",[]), update: (context,Auth,prod) => products(Auth.reruntoken(Auth.token),Auth.rerunuserid(Auth.userid),prod==null?[]:prod.items)),
      // ChangeNotifierProvider(create: (context) => Cart()),
      ChangeNotifierProvider.value(value: Cart()),
      ChangeNotifierProxyProvider<Auth,Orders>(create: (context) => Orders("",[],""), update: (context,Auth,ord) => Orders(Auth.token,ord==null?[]:ord.order,Auth.userid)),

    ],
      child: Consumer<Auth>(builder: (context,Auth,_) {
        print(Auth.isauth);
        return MaterialApp(                           //yaha ChangeNotifierProvider.value ka use tab karte hai jab value not depend on context this is an alternative method of provider and also jab list and grid ke andar provider use karna ho to
        debugShowCheckedModeBanner: false,
        title: 'MyShop',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple,errorColor: Colors.orangeAccent),
            fontFamily: 'Merriweather',
            textTheme: TextTheme(
                bodyMedium: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Merriweather'

                ),
                labelSmall: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Merriweather'
                ),
                titleSmall: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Merriweather',
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
                bodySmall: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Merriweather'
                ),
                displayMedium: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Merriweather',
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple
                )
            )
        ),
        initialRoute: "/",
        routes: {
          userlogin.routename: (context) => userlogin(),
          product_detail.routename: (context) => product_detail(),
          cartScreen.routename: (context) =>cartScreen(),
          order_screen.routename: (context) => order_screen(),
          userScreen.routename: (context) => userScreen(),
          edit_screen.routename: (context) => edit_screen()
        },
          home: Auth.isauth?product_screen(): FutureBuilder(future: Auth.tryAutoplogin(),builder: (context,snap) => snap.connectionState==ConnectionState.waiting?Scaffold(body: Center(child: Text("Loading.."),),):userlogin()),
      );}
      )   //yaha changenotifierprovider nhi lagayege to different part of apps me provider work nhi kar payega
                    //yaha pe return me jo bhi widget paas kar rahe hai uske class ke saath with Changenotifier hona chiye
    );
  }
}
