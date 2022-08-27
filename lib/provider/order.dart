import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/provider/cart.dart';

class orderitem{
  final String id;
  final double Total_amount;
  final List<cartitem> itemcarts;
  final DateTime date;

  orderitem({required this.id, required this.Total_amount, required this.itemcarts, required this.date});

}

class Orders with ChangeNotifier{
  List<orderitem> _order = [];

  List<orderitem> get order{
    return [..._order];
  }
  final String authtoken;
  final String userid;
  Orders(this.authtoken,this._order,this.userid);

  Future<void> fetchorder() async{
    final url = Uri.parse('https://flutter-shop-aa122-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userid.json?auth=$authtoken');
     final response= await http.get(url);
     final List<orderitem> listitem = [];
     final extractprod = jsonDecode(response.body) as Map<String,dynamic>;
     print(extractprod);
     if(extractprod.isEmpty)
       {
         _order=[];
         notifyListeners();
         return;
       }

     extractprod.forEach((id, order) {
       listitem.add(orderitem(
         Total_amount: order['Total_amount'],
           id: id,
           date: DateTime.parse(order['date']),
         itemcarts: (order['itemcarts'] as List<dynamic>).map((cart) =>
             cartitem(quantity: cart['quantity'],
                 price: cart['price'],
                 id: cart['id'],
                 title: cart['title'])
         ).toList()
       ));
     });
     _order = listitem.reversed.toList();   //.reversed se jo new order hoga vo uper ayega
     notifyListeners();

  }

  Future<void> addorder(List<cartitem> prod,double total) async{
    final Date = DateTime.now();
   try{
     final url = Uri.parse('https://flutter-shop-aa122-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userid.json?auth=$authtoken');
     final response = await http.post(url,body: jsonEncode({
       'Total_amount': total,
       'date': Date.toIso8601String(),
       'itemcarts': prod.map((cart) => {
         'id': cart.id,
         'title': cart.title,
         'price': cart.price,
         'quantity': cart.quantity
       }).toList()

     }));

    _order.insert(0, orderitem(itemcarts: prod, date: DateTime.now(), Total_amount: total, id: jsonDecode(response.body)["name"]));
    notifyListeners();
   } catch(error){
     throw error;
   }
  }

  Future<void> deleteitem(String id) async
  {
    final orderindex = _order.indexWhere((element) => element.id==id);
    final orderelement = _order[orderindex];
    _order.removeWhere((element) => element.id==id);
    notifyListeners();
    try{
      final url = Uri.parse('https://flutter-shop-aa122-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userid/$id.json?auth=$authtoken');
      final data = await http.delete(url);
     if(data.statusCode>=400)
       {
         _order.insert(orderindex, orderelement);
         notifyListeners();
         throw Exception("An error Occur");
       }
      print(data.statusCode);
    }
    catch(error){
      print(error);
      throw error;
    }
  }

}