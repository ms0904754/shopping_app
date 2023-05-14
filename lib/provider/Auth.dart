import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Auth with ChangeNotifier{

  String ?_token;
  DateTime ?_expirydate;
  String ?_userid;
  Timer ?authtime;

  bool get isauth{
    return _token!=null;
  }

  String get token{
    if(_token!=null && _expirydate!.isAfter(DateTime.now()) && _expirydate!=null)
      {
        return _token.toString();
      }
    return null.toString();
  }

  String get userid{
    return _userid.toString();
  }


  Future<void> SignUp(String email,String password) async
  {
    try{
      final url = Uri.parse("Your Api key");
      final response = await http.post(url,body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true
      }));
      // print(jsonDecode(response.body));
      final respondata = jsonDecode(response.body);
      if(respondata==null)
        {
          throw Exception(respondata['error']['message']);
        }
      _token=respondata['idToken'];
      _expirydate = DateTime.now().add(Duration(seconds: int.parse(respondata['expiresIn'])));
      _userid= respondata['localId'];
      authtimer();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userdata = jsonEncode({
        'token': _token,
      'userid': _userid,
      'expirydate': _expirydate!.toIso8601String()});
      prefs.setString('userdata', userdata);

    } catch(error){
      rethrow;
    }

  }
  Future<void> Login(String email,String password) async
  {
   try{
     final url = Uri.parse("Your Api key");
     final respo = await http.post(url,body: jsonEncode({
       'email': email,
       'password': password,
       'returnSecureToken': true
     }));
     final responsedata = jsonDecode(respo.body);
     print(responsedata);
     print(respo.statusCode);
     if(responsedata==null)
       {
         throw Exception(responsedata['error']['message']);
       }
     _token=responsedata['idToken'];
     _expirydate = DateTime.now().add(Duration(seconds: int.parse(responsedata['expiresIn'])));
     _userid= responsedata['localId'];
     authtimer();
     notifyListeners();
     final prefs = await SharedPreferences.getInstance();
     final userdata = jsonEncode({
       'token': _token,
       'userid': _userid,
       'expirydate': _expirydate!.toIso8601String()});
     prefs.setString('userdata', userdata);
   } catch(error){
     rethrow;
   }

  }

  Future<bool> tryAutoplogin() async{
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userdata')){
      return false;
    }
    final extractuserdata = jsonDecode(prefs.getString('userdata') as String) as Map<String,dynamic>;
    final expirydate = DateTime.parse(extractuserdata['expirydate'] as String);
    if(expirydate.isBefore(DateTime.now()))
      {
        return false;
      }

    _userid = extractuserdata['userid'] as String;
    _token = extractuserdata['token'] as String;
    _expirydate = expirydate;
    notifyListeners();
    authtimer();
    print(_expirydate.toString());
    print(expirydate);
    return true;

  }

  Future<void> logout() async{
    _token = null;
    _userid=null;
    _expirydate=null;
    if(authtime!=null)
      {
        authtime!.cancel();
        authtime = null;
      }
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    // pref.remove('userdata'); //it is used if you store multiple things in Sharedpreferences and don't want all to delete when logout but here we store only userdata so we use claer()
    pref.clear();
  }

  void authtimer(){
    print(authtime.toString());
    if(authtime!=null)
      {
        authtime!.cancel();  //isse ongoing time cancel ho jata hai
      }
    final expirytime = _expirydate!.difference(DateTime.now()).inSeconds;
    print(expirytime);
    authtime = Timer(Duration(seconds: expirytime), logout);
  }

  String reruntoken(String token)
  {
    return this.token;
  }
  String rerunuserid(String userid)
  {
    return this.userid;
  }


}
