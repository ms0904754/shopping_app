import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/provider/productlist.dart';
import 'package:shopping_app/screens/edit_screen.dart';
import 'package:shopping_app/widgets/Mydrawer.dart';
import 'package:shopping_app/widgets/user_items.dart';

class userScreen extends StatelessWidget {
  static const routename = "/userscreen";
  const userScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Control"),
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).pushNamed(edit_screen.routename,arguments: 'null');
          }, icon: Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(future: Provider.of<products>(context,listen: false).fetchdata(true),builder: (context,snapshot) =>
      snapshot.connectionState==ConnectionState.waiting?Center(child: CircularProgressIndicator()):RefreshIndicator(
        onRefresh: () async{
          Provider.of<products>(context,listen: false).fetchdata(true);
        },
        child:Consumer<products>(builder: (context,itemlist,_) => Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(itemBuilder: (context, index) {
              return user_item(itemlist.items[index].title, itemlist.items[index].image,itemlist.items[index].id);

            },itemCount: itemlist.items.length,)
        ),)
      ),),
      drawer: MyDrawer(),
    );
  }
}
