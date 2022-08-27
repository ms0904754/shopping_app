import 'package:flutter/cupertino.dart';

class cartitem{
  final String id;
  final String title;
  final int quantity;
  final double price;

  cartitem({required this.id, required this.title, required this.quantity, required this.price});
}

class Cart with ChangeNotifier{
  Map<String, cartitem> _cart ={};

  Map<String, cartitem> get items{
    return _cart;  // or we use _cart!
  }

  double get totalamt{
    double total=0.0;
    _cart.forEach((key, cartitem) {           // key here basically an id of product
      total =total + cartitem.price * cartitem.quantity;
    });
    return total;
  }
  void additem(String id,String title,double price)
  {
    if(_cart.containsKey(id))
      {
        //update quantity
        _cart.update(id, (value) => cartitem(id: value.id, title: value.title, quantity: value.quantity+1, price: value.price));
      }else
        {
          //add item
          print(id);
          _cart.putIfAbsent(id, () => cartitem(id: id, title: title, quantity: 1, price: price));

        }

    notifyListeners();
  }
  int  itemcount ()
  {
    return _cart.isEmpty?0:_cart.length;
  }

  void removeitem(String id){
    _cart.remove(id);
    notifyListeners();
  }

  void clearcart(){
    _cart = {};
    notifyListeners();
  }

  void clearsingleitem(String id)
  {
    if(_cart[id]!.quantity>1)
      {
        _cart.update(id, (existingcartitem) => cartitem(id: existingcartitem.id, title: existingcartitem.title, quantity: existingcartitem.quantity-1, price: existingcartitem.price) );
      }else
        {
          _cart.remove(id);
        }

    notifyListeners();
  }
}
