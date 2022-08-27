import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/provider/productlist.dart';

import '../widgets/product_item.dart';
class productgrid extends StatelessWidget {
  bool favcheck;
  productgrid(this.favcheck);

  @override
  Widget build(BuildContext context) {
    final productlist = favcheck?Provider.of<products>(context).favitems:Provider.of<products>(context).items;
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 15,
          childAspectRatio: 2.5/2), itemBuilder: (context,index){
      print(index);
      return ChangeNotifierProvider.value(                          //this is a good approach if you are not using listview and gridview
        // create: (context) => productlist[index],                //agar product me with ChangeNotifier nhi lagayege to ye bhi work nhi karega
        value: productlist[index],                                 // ye approach shi rehga jab list ya grid ke andar provider use karre to because when widget recycle data will change and builder function would not work correctly but in value it work correctly
        child: product_item(),);
                                                            //yaha productlist[index] jo data provide karega vo stored hota jayega jaise jaise page visit karege fir back ayega aise continuoustly karte jaayege to yaha ChangeNotifier kam karta hai aur vo data ko dispose kardeta hai when it is not required jisse memory overflow na ho ya leak na
    },
      itemCount: productlist.length,);
  }
}



