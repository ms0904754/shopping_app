import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shopping_app/provider/product.dart';
import 'package:http/http.dart' as http;


class products with ChangeNotifier{

  List<product> _Item = [
    // product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   descp: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   image:
    //   'https://5.imimg.com/data5/OX/IC/MY-4906124/dsc_3669-500x500.jpg',
    // ),
    // product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   descp: 'A nice pair of trousers.',
    //   price: 59.99,
    //   image:
    //   'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   descp: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   image:
    //   'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   descp: 'Prepare any meal you want.',
    //   price: 49.99,
    //   image:
    //   'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),product(
    //   id: 'p5',
    //   title: 'Apple mobile',
    //   descp: 'Prepare any meal you want.',
    //   price: 50.99,
    //   image:
    //   'https://kddi-h.assetsadobe3.com/is/image/content/dam/au-com/mobile/mb_img_58.jpg?scl=1',
    // ),product(
    //   id: 'p6',
    //   title: 'Oppo mobile',
    //   descp: 'Prepare any meal you want.',
    //   price: 50.99,
    //   image:
    //   'https://d2d22nphq0yz8t.cloudfront.net/88e6cc4b-eaa1-4053-af65-563d88ba8b26/https://media.croma.com/image/upload/v1622812946/Croma%20Assets/Communication/Mobiles/Images/234467_qohqqn.png/mxw_640,f_auto',
    // )
  ];

  final String authtoken;
  final String userid;
  products(this.authtoken, this.userid,this._Item);



  List<product> get items{
    return _Item;         // or [..._Item]
  }

  List<product> get favitems{
    return _Item.where((prod) => prod.isfavourite).toList();
  }

  // void checker()
  // {
  //   showfav =true;
  //   notifyListeners();
  // }
  // void falsechecker()
  // {
  //   showfav=false;
  //   notifyListeners();
  // }
  productById(String id)
  {
    return _Item.firstWhere((prod) => prod.id==id);
  }

  Future<void> updateproduct(String id,product changeprod) async{
    try{
      final url = Uri.parse('https://flutter-shop-aa122-default-rtdb.asia-southeast1.firebasedatabase.app/Products/$id.json?auth=$authtoken');   //yaha /$id isliye lagaya kyuki sab prod upgrage nhi kar rahe koi particular pro kar rahe hai

      await http.patch(url,body: jsonEncode({
        'title': changeprod.title,
        'descp': changeprod.descp,
        'image': changeprod.image,
        'price': changeprod.price,
      }),
      );
      final itemindex = _Item.indexWhere((element) => element.id==id);
      if(itemindex>=0)
      {
        _Item[itemindex] = changeprod;
      }
      notifyListeners();
    } catch(error) {
      throw error;
    }
  }

  Future<void> deletedproduct(String id) async
  {
    print(id);
    final productindex = _Item.indexWhere((element) => element.id==id);
    var productitem = _Item[productindex];
    _Item.removeWhere((element) => element.id==id);
    print(productindex);
    notifyListeners();
     try{
       final url = Uri.parse('https://flutter-shop-aa122-default-rtdb.asia-southeast1.firebasedatabase.app/Products/$id.json?auth=$authtoken');
       final responde = await http.delete(url);
       if(responde.statusCode>=400)
       {
         _Item.insert(productindex, productitem);
         notifyListeners();
         throw Exception("error Ocurred");   //throw just like return yaha code execution stop ho jayega
       }else                                   //Exception koi error ho to vo catch me throw karta hai
           {
         print("run");
       }
     } catch(error){
       rethrow;
     }
  }


  // Future<void> addproduct(product Items){    //future void isliye lagaya kyuki apan then method ka use karna chate hai edit_screen widget me
  //   final url = Uri.parse('https://flutter-shop-aa122-default-rtdb.asia-southeast1.firebasedatabase.app/Products.json');  //ye Products.json isliye likha kyuki ye database me jake Products naam ka folder bana dega jisme apna deta hoga
  //   return http.post(url,body: jsonEncode({               //json look like a map that why we pass date like map
  //     'title': Items.title,
  //     'descp': Items.descp,
  //     'price': Items.price,
  //     'image': Items.image,
  //     'favorite': Items.isfavourite,
  //   })).then((value) {                                //beacuse post can take future response isse ye hoga ki ekdun se add nhi hoga kuch millisec lagege pehle uper hone ke baad
  //     print(jsonDecode(value.body));     //this will give a map having a name key give cryptic unique id,since we get unique id so we can also used this instead of DateTime.now below here
  //     final Itemlist = product(
  //         id: jsonDecode(value.body)['name'],
  //         title: Items.title,
  //         descp: Items.descp,
  //         image: Items.image,
  //         price: Items.price);                           //catch baad me isliye lagaya taki koi error aaye dono then ke andar to pakad le yaha catch nhi bhi lagayege tab bhi work karega kyuki edit_screen me catch use kar rakha hai
  //     _Item.add(Itemlist);
  //     notifyListeners();
  //   }).catchError((error) {
  //     print(error.toString());
  //     throw error;   // ye error throw karege jo edit screen ke catchError ke onError me jake pahuchega
  //   });   //now if any error occured app not will be crashed because
  // }

  Future<void> fetchdata( [bool filterdata = false]) async{       //square bracket around positional argument means it is optional
    try{
      final filterString = filterdata?'orderBy="createrId"&equalTo="$userid"':'';
      final url = Uri.parse('https://flutter-shop-aa122-default-rtdb.asia-southeast1.firebasedatabase.app/Products.json?auth=$authtoken&$filterString');
      final response = await http.get(url);
      final extractdata = jsonDecode(response.body) as Map<String,dynamic>;
      if(extractdata.isEmpty)
        {
          _Item=[];
          return;
        }
      var urp =Uri.parse('https://flutter-shop-aa122-default-rtdb.asia-southeast1.firebasedatabase.app/Userfavorite/$userid.json?auth=$authtoken');  //id is available beacuse it is the property of this class
      final favresponse = await http.get(urp);
      final favreponsedata = jsonDecode(favresponse.body);

      print("l");
      // print(extractdata);
      List<product> fetchdata = [];
      extractdata.forEach((prodid, value) {    //here value is a map inside of the map
        // print(prodid);
        // print(favreponsedata[prodid]);
        fetchdata.add(product(id: prodid,
            title: value['title'],
            descp: value['descp'],
            image: value['image'],
            price: value['price'],
          isfavourite: favreponsedata==null?false:favreponsedata[prodid] ??false //?? isliye lagaya agar favresponse[prodid] bhi null rehta hai to by default false hoga
       ));                                                                       //null isliye reh sakta hai ki manlo new prod add karne ki bajaye apan existing prod me changes kare
      });
      _Item=fetchdata;
      notifyListeners();
    } catch (error){
      rethrow;
    }
  }

  Future<void> addproduct(product Items) async{      //async lagane se kuch return karne ki jarurat nhi padegi it automatically return future,and all code inside this wrapped into future,async se apan 'then' and 'catchError' se free ho jayege
   try {
     final url = Uri.parse('https://flutter-shop-aa122-default-rtdb.asia-southeast1.firebasedatabase.app/Products.json?auth=$authtoken');
     final value = await http.post(url, body: jsonEncode(
         {
           //json look like a map that why we pass date like map
           'title': Items.title,                                 //await lagane se ye hoga ki ye immediately execute nhi hoga thoda samay lagega pehle ye run hoga fir niche wale me shift
           'descp': Items.descp,
           'price': Items.price,
           'image': Items.image,
           'createrId': userid
         }));
     print("1");
     final Itemlist = product(
         id: jsonDecode(value.body)['name'],
         //error ko handle karne ke liye try and catch ka use karege
         title: Items.title,
         descp: Items.descp,
         image: Items.image,
         price: Items.price);
     _Item.add(Itemlist);
     notifyListeners();
   } catch (error){
    rethrow;
   }

  }

  bool selector()
  {
    return true;
  }

  bool firs=true;
  bool sec = false;
  bool third = false;

}




// import 'package:shopping_app/products/product.dart';
//
//
// class products with no
//
// final List<product> productlist = [
//   product(
//     id: 'p1',
//     title: 'Red Shirt',
//     descp: 'A red shirt - it is pretty red!',
//     price: 29.99,
//     image:
//     'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//   ),
//   product(
//     id: 'p2',
//     title: 'Trousers',
//     descp: 'A nice pair of trousers.',
//     price: 59.99,
//     image:
//     'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//   ),
//   product(
//     id: 'p3',
//     title: 'Yellow Scarf',
//     descp: 'Warm and cozy - exactly what you need for the winter.',
//     price: 19.99,
//     image:
//     'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//   ),
//   product(
//     id: 'p4',
//     title: 'A Pan',
//     descp: 'Prepare any meal you want.',
//     price: 49.99,
//     image:
//     'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//   ),
// ];