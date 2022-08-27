import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/provider/order.dart';

class order_items extends StatefulWidget {
  final orderitem orders;
  order_items(this.orders);

  @override
  State<order_items> createState() => _order_itemsState();
}


class _order_itemsState extends State<order_items> with TickerProviderStateMixin{

  bool expandmore =false;
  AnimationController ?_controler;
  @override
  void initState() {
    var _controler = AnimationController(vsync: this,duration: Duration(seconds: 1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);

    final ord =Provider.of<Orders>(context,listen: false);
    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      height: expandmore?min(ord.order.length*20+200,200):140,
      curve: Curves.fastOutSlowIn,
      child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text('\₹${widget.orders.Total_amount.toString()}',style: TextStyle(color: Colors.grey,fontSize: 20),),
              subtitle: Text(DateFormat('dd-MM-yyyy, hh:mm').format(widget.orders.date)),
              trailing: IconButton(icon: expandmore?Icon(Icons.expand_less):Icon(Icons.expand_more),onPressed: (){
                setState(() {
                  if(expandmore)
                    {
                      expandmore=!expandmore;
                    }else
                      {
                        expandmore=!expandmore;
                      }
                });
              },),
            ),
            expandmore?SingleChildScrollView(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 600),
                height: expandmore?min(ord.order.length*20+100,200):0,
                width: double.infinity,
                child: ListView(
                  children: widget.orders.itemcarts.map((cartitem) => ListTile(

                        leading: Text(cartitem.title),
                        trailing: Text('${cartitem.quantity} \× ${cartitem.price}'),

                  )).toList(),
                ),
              ),
            ):Container(),
            TextButton(onPressed: () async{
              print(widget.orders.id);
              try{
                await Provider.of<Orders>(context,listen: false).deleteitem(widget.orders.id);
              } catch(error){
                scaffold.showSnackBar(SnackBar(content: Text("Order can't cancel")));
              }
            }, child: Text("Delete"))
          ],
        ),
      ),),
    );
  }
}


