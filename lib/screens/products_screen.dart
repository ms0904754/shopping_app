import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/provider/cart.dart';
import 'package:shopping_app/provider/productlist.dart';
import 'package:shopping_app/screens/buttonicon.dart';
import 'package:shopping_app/screens/cartScreen.dart';
import 'package:shopping_app/screens/productgrid.dart';

import '../provider/Auth.dart';
import '../widgets/Mydrawer.dart';

enum filteroption{
  Favorite,
  All
}


class product_screen extends StatefulWidget {

  @override
  State<product_screen> createState() => _product_screenState();
}

class _product_screenState extends State<product_screen> {
   bool favcheck=false;
   var isinit = true;
   var isloadingspinner = true;

  //  @override
  // void initState() {
  //   Provider.of<products>(context,listen: false).fetchdata();  //listen false karege jab hi apan provider ko initstate me daal sakte hai nhi to fir error ayega
  //   super.initState();
  // }

   //or  2nd method
   @override
  void didChangeDependencies() {    //it can run multiple times so thats why we use a var so that provider run only one time
     if(isinit)
      {
       Provider.of<products>(context).fetchdata().then((_) {
         setState(() {
           isloadingspinner=false;
         });
       });                                   //we cannot use async in didchangedependencies and initstate bacuse it doesn't return future
      print("hello");
      }
    isinit = false;
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
          appBar: AppBar(
            title: Text("My Shop"),
            centerTitle: true,
            actions: [
              PopupMenuButton(
                  onSelected: (filteroption selectvalue) {
                    setState(() {
                      if(selectvalue ==filteroption.Favorite)
                      {
                        favcheck=true;
                      }else
                      {
                        favcheck=false;
                      }
                    });

                  },
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(child: Center(child: Text("Favourite",style: Theme.of(context).textTheme.bodyMedium)),value: filteroption.Favorite,),
                    PopupMenuItem(child: Center(child: Text("All Items",style: Theme.of(context).textTheme.bodyMedium)),value: filteroption.All,),
                    PopupMenuItem(child: ListTile(
                      onTap: () {
                        Navigator.of(context).pop();
                        Provider.of<Auth>(context,listen: false).logout();
                      },
                      leading: Icon(Icons.exit_to_app,color: Colors.black,),
                      title: Text("Logout",style: Theme.of(context).textTheme.bodyMedium),
                    ),value: filteroption.All,),
                  ]),
              Consumer<Cart>(
                builder: (ctx,carts,ch) =>
                    buttonicon(
                      value: carts.itemcount().toString(),
                      child: ch,

                    ),
                child: IconButton(icon: Icon(Icons.add_shopping_cart),onPressed: (){
                  Navigator.of(context).pushNamed(cartScreen.routename);
                },),
              )
            ],
          ),
            body: isloadingspinner?Center(child: CircularProgressIndicator(),):productgrid(favcheck),

    );
  }
}


