import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/productlist.dart';

class product_detail extends StatelessWidget {
  // final title;
  // product_detail(this.title);
  static const routename = "/product_detail";

  @override
  Widget build(BuildContext context) {            //listen: false jab hi karege jab ek baar hi data chiye ho usko change nhi karna ho to
    final productsid = ModalRoute.of(context)?.settings.arguments as String;
    final loadedproduct = Provider.of<products>(context).productById(productsid);    // isko bolte hai provider.of
    return Scaffold(                                                              // context ke andar listner property bhi hai or uski by default value true hoti hai
          body: CustomScrollView(
          slivers: [
            SliverAppBar(expandedHeight: 300,pinned: true,  //pinned se ye hoga scroll ke baad bhi visible hoga
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedproduct.title),
              centerTitle: true,
              background: Hero(tag: productsid,
                  child: Image.network(loadedproduct.image,fit: BoxFit.cover))
            ),
            ),
            SliverList(delegate: SliverChildListDelegate([
              SizedBox(height: MediaQuery.of(context).size.height*0.03,),
              Container(width: double.infinity,child: Text('\₹${loadedproduct.price.toString()}',style: TextStyle(color: Colors.grey,),textAlign: TextAlign.center,)),
              SizedBox(height: MediaQuery.of(context).size.height*0.01,),
              Center(child: Text(loadedproduct.descp,)),
              SizedBox(height: 600,)
            ]),
            ),
          ],
        ),
    );
  }
}
