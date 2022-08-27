import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class product with ChangeNotifier{
  final String id;
  final String title;
  final String descp;
  final String image;
  final double price;
  bool isfavourite;

  product({required this.id, required this.title, required this.descp, required this.image, required this.price,this.isfavourite=false});


  Future<void> togglefavoritestate(String title, String _token, String userid) async
  {
    final oldstatus = isfavourite;
    isfavourite = !isfavourite;
    notifyListeners();    // ye state ki tarah hi ye jab bhi koi change dekhega child widget me to ye rebuild ho jayega
    try{
      final url =Uri.parse('https://flutter-shop-aa122-default-rtdb.asia-southeast1.firebasedatabase.app/Userfavorite/$userid/$id.json?auth=$_token');  //id is available beacuse it is the property of this class
      // final value=await http.patch(url,body: jsonEncode({
      //   'favorite': isfavourite,
      // }));
      final value = await http.put(url,body: jsonEncode(
        isfavourite
      ));
      if(value.statusCode>=400)
        {
          isfavourite = oldstatus;
          notifyListeners()              ;  //Exception laga ne se ye error catch ko bhej dega kyuki patch method me error throw nhi karta to catch kopata nhi chalta us case me
        }                                 // or ye bhi kar sakte hai ki catch me jo daala hai vo if ke andar daal de
    } catch(error){
      isfavourite = oldstatus;
      notifyListeners();
    }

  }
}


//NOTE:- http throw its own error only in get and post method not in patch,put,delete method