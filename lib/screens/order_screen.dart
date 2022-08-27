import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/provider/order.dart';
import 'package:shopping_app/provider/product.dart';
import 'package:shopping_app/widgets/order_items.dart';

import '../widgets/Mydrawer.dart';

class order_screen extends StatelessWidget {
  static const routename = '/order_screen';
  const order_screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("repeat");
    // final listorder = Provider.of<Orders>(context);  //ye isliye hata rahe hai kyuki Fututre builder me jab provider me listen notify hoga to ye bhi trigger hoga pura state wapis rebuild hoga aur ye chalta jayega infinite loop
    return Scaffold(                                      //so we use Consumer
        drawer: MyDrawer(),
      appBar: AppBar(
        title: Text("My Order"),
        centerTitle: true,
      ),
      body: FutureBuilder(future: Provider.of<Orders>(context,listen: false).fetchorder(),builder: (BuildContext context, Snapshot) {
        if(Snapshot.connectionState==ConnectionState.waiting)
          {
            return Center(child: CircularProgressIndicator(),);
          }else if(Snapshot.data==null && Snapshot.hasError){
          return Center(child: Text("No Order placed"));
        }else if(Snapshot.error!=null)
            {
              return Center(child: Text("An Error Occured!"),);
            }else
              {
                return Consumer<Orders>(builder: (context,orderdata,child) => ListView.builder(itemBuilder: (context, index) {  //Future builder can also be used in stateful widget
                  print(index);
                  return order_items(orderdata.order[index]);
                },itemCount: orderdata.order.length,),);
              }
      },
      )
    );
  }
}



// @override
// void initState() {                    //other alternative mtehod to fetch is using the FutureBuilder
//   // Future.delayed(Duration.zero).then((value) async{   //beacuse we do here listen false so this Future not req
//   //   setState(() {
//   //     _isloading = true;
//   //   });
//   //   Provider.of<Orders>(context,listen: false).fetchorder().catchError((_) {
//   //     Navigator.of(context).pushReplacementNamed('/');
//   //   }).then((value) {
//   //     setState(() {
//   //       _isloading = false;
//   //     });
//   //   });
//   super.initState();
// }
