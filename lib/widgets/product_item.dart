import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/provider/product.dart';
import 'package:shopping_app/screens/product_detail.dart';

import '../provider/Auth.dart';
import '../provider/cart.dart';

class product_item extends StatelessWidget {
  // final String id;
  // final String title;
  // final String image;
  // product_item(this.id,this.title,this.image);

  @override
  Widget build(BuildContext context) {                              //alternative way of using Consumer instead of provifer.of, both are same but Consumer has more advantage
    final item = Provider.of<product>(context,listen: false);       //agar yaha listen : false laga de ge to hoga ye ki user ko uska result nhi dikhega par background me vo run ho rha hai
    final cart = Provider.of<Cart>(context);                                                                 //iska mtlb agar apan fav pe click karege to koi fark nhi padega because listen false kar rakha hai so notifylistner doesn't reach back beacuse it can't listen
    final authdata = Provider.of<Auth>(context,listen: false);
    return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GridTile(child: GestureDetector(child: Hero(tag: item.id,
        child: FadeInImage(image: NetworkImage(item.image), placeholder: AssetImage("assets/image/back_image.jpg"),fit: BoxFit.cover,)),  //Image.network(item.image,fit: BoxFit.cover)
          onTap: (){
            print(item.id);
            Navigator.of(context).pushNamed(product_detail.routename,arguments: item.id);
          },),
        footer: GridTileBar(title: Text(item.title,textAlign: TextAlign.center),
          backgroundColor: Colors.black54,
        leading: Consumer<product>(                     //Consumer ke uper ka part listen nhi karega(mtlb rebuild nhi hoga) kyuki humne listen false kar rakha hai but Consumer always listen aur ye yaha pe isliye use kiya kyuki hum yehi part chahte hai jo rebuild ho i.e icon part
         builder: (context ,prod,_) => IconButton(icon: item.isfavourite?Icon(Icons.favorite):Icon(Icons.favorite_border), onPressed: () {
                       item.togglefavoritestate(item.title,authdata.token,authdata.userid);
        },
                  color: Theme.of(context).colorScheme.errorContainer,            // builder ke andar child ka use ye hai ki agar koi widget part ko rebuild nhi karna chate to usko child me daal dege isse uss part ko chodd kar baaki rebuild ho jayege yaha abhi kuch nhi karna to bas child ki jagah "_" ye laga dege
         ),
        ),
        trailing: IconButton(icon: Icon(Icons.shopping_cart),onPressed: () {
          cart.additem(item.id, item.title, item.price);
          // Scaffold.of(context).openDrawer();     //isko nearest scaffold widget se dur hi uske karte hai nhi to ye kaam nhi karega yaha pe scaffold widget tree nhi hai to yaha use kar sakte hai sabse nearest scaffold product_screen me hai
          ScaffoldMessenger.of(context).hideCurrentSnackBar(); //ye kya karega current snackbar ko hata ke naya wala liyega jaise hi cart pe click karege
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Item is added to Cart",textAlign: TextAlign.center,),duration: Duration(seconds: 2),
            action: SnackBarAction(label: "Undo",onPressed: () {
              cart.clearsingleitem(item.id);
            },textColor: Colors.white,),));                                        //this oper drawer work because it is present in nearest scaffold

        },
          color: Theme.of(context).colorScheme.errorContainer,),),),
    );
  }
}
