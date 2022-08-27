import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/Auth.dart';


enum AuthMode{
  Login,
  Signup
}

class userlogin extends StatelessWidget {
  static const routename = "userlogin";
  const userlogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sizebox = MediaQuery.of(context).size;
    print(sizebox.width);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: sizebox.height,
            width: sizebox.width,
            decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:[
                  Colors.red,
                  Colors.blue
                ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          ),
          child: SingleChildScrollView(
              child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: sizebox.height*0.05),
                      child: Container(
                        height: sizebox.height*0.10,
                        width: sizebox.width*0.80,
                        child: FittedBox(child: Center(child: Text("My Shop",style: TextStyle(fontSize: 20,color: Colors.white),))),
                        transform: Matrix4.rotationZ(-0.03),
                        decoration: BoxDecoration(color: Colors.indigo,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                  blurRadius: 2,
                                  color: Colors.black54,
                                  offset: Offset(0,3)
                              )
                            ]
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Authcard()
                  ],
                ),
            ),
            ),
        ],
      ),
    );
  }
}

class Authcard extends StatefulWidget {
  const Authcard({Key? key}) : super(key: key);


  @override
  State<Authcard> createState() => _AuthcardState();
}

class _AuthcardState extends State<Authcard> with TickerProviderStateMixin{

  AnimationController ?_controller;
  Animation<Size> ?_heightanimation;
  Animation<double> ?_opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this,duration: Duration(milliseconds: 300));
    // _heightanimation = Tween<Size>(begin: Size(double.infinity,280),end: Size(double.infinity,350)).animate(
    //   CurvedAnimation(parent: _controller!, curve: Curves.fastOutSlowIn),
    _opacityAnimation = Tween<double>(begin: 0.0,end: 1.0).animate(CurvedAnimation(parent: _controller!, curve: Curves.fastOutSlowIn)
    );   //Tween only show the information that how to animate b/w two value kaise animate karna hai ye nhi batata,ye .animate batata hai jo iske baad use kare hai
  // _heightanimation!.addListener(() => setState(() {}));        //instead of that we use animated builder so that we can rebuild a part
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();  //we also need to dispose our listener when state or widget removed
  }

  void showdialog (String message){
    showDialog(context: context, builder: (context) {
      return AlertDialog(title: Text("An Error Occured"),content: Text(message),actions: [
        TextButton(onPressed: () {
          Navigator.of(context).pop();
        }, child: Text("Ok"))
      ],);
    });
  }

  GlobalKey<FormState> _formkey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String,dynamic> details = {
    'Email': '',
    'Password': ''
  };
  var _isloading = false;
  final _password = TextEditingController();



  Future<void> submit() async{
    final check = _formkey.currentState?.validate();
    if(!check!)
      {
        return;
      }
    _formkey.currentState!.save();
    setState(() {
      _isloading = true;
    });
   try{
     if(_authMode == AuthMode.Login)
     {
       await Provider.of<Auth>(context,listen: false).Login(details['Email'], details['Password']);
     }
     if(_authMode == AuthMode.Signup)
     {
       await Provider.of<Auth>(context,listen: false).SignUp(details['Email'], details['Password']);
     }
   } on Exception catch(error){
     print("hello");
     print(error);
     var errormesage = 'Authentication failed, please try again later';
     if(error.toString()=='EMAIL_NOT_FOUND')
       {
         errormesage = "Could not find a user with email";
       }else if(error.toString().contains('EMAIL_EXISTS'))
         {
             errormesage = 'The email is already in used';
         }else if(error.toString().contains('INVALID_EMAIL'))
           {
             errormesage = 'This is not a valid email';
           }else if(error.toString().contains('WEAK_PASSWORD'))
             {
               errormesage = 'password is too weak';
             }else if(error.toString().contains('INVALID_PASSWORD'))
               {
                 errormesage = 'Wrong password,please enter the correct password';
               }
     showdialog(errormesage);

   } catch (error) {
     print(error);
     print("run");
    var errormessage = 'Could not Authenticate you. please try again later';
    showdialog(errormessage);
   }
    setState(() {
      _isloading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizebox = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      height: _authMode==AuthMode.Login?sizebox.height*0.40:sizebox.height*0.50,
        // height: _authMode,    //double me karne ke liye .value.height use karna padda
        // constraints: BoxConstraints(minHeight: _authMode==AuthMode.Login?300:400),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.white),
        width: sizebox.width*0.80,
        child: Form(
      key: _formkey,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child:SingleChildScrollView(
          child: Column(children: [
            TextFormField(
              decoration: InputDecoration(labelText: "Email",labelStyle: TextStyle(fontSize: 20),hintText: "Enter the Email",),
              onSaved: (value) {
                details['Email'] = value;
              },
              validator: (value) {
                if(value!.isEmpty || !value.contains('@'))
                {
                  return "Invalid Email";
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Password",labelStyle: TextStyle(fontSize: 20),hintText: "Password greater than 6 letter",),
              controller: _password,
              obscureText: true,
              onSaved: (value) {
                details['Password'] = value;
              },
              validator: (value) {
                if(value!.isEmpty)
                {
                  return "Password can't be Empty";
                }
                if(value.length<=6)
                {
                  return "Password must be grater than 6";
                }
                return null;
              },
            ),
              AnimatedContainer(
                height: _authMode==AuthMode.Login?0:60,
                duration: const Duration(milliseconds: 800),
                curve: Curves.fastOutSlowIn,
                child: FadeTransition(       // fade transition se confirm password dhire dhire aayega
                  opacity: _opacityAnimation!,
                  child: _authMode==AuthMode.Signup?TextFormField(
                    decoration: InputDecoration(labelText: "Confirm Password",labelStyle: TextStyle(fontSize: 20),hintText: "Enter Password Again"),
                    obscureText: true,
                    enabled: _authMode==AuthMode.Signup,
                    onSaved: (value) {
                      details['Password'] = value;
                    },
                    validator: (_authMode==AuthMode.Signup)?(value) {
                      if(value!=_password.text)
                      {
                        return "Password do not match";
                      }

                      return null;
                    }:null,
                  ):null,
                ),
              ),
            SizedBox(height: MediaQuery.of(context).size.height*0.03,),
            (!_isloading)?ElevatedButton(onPressed: () {
              submit();
              FocusScope.of(context).unfocus();
            }, child: (_authMode==AuthMode.Login)?Text("Login"):Text("Sign up")):CircularProgressIndicator(),
            TextButton(onPressed: () {
              setState(() {
                FocusScope.of(context).unfocus();
                if(_authMode==AuthMode.Login)
                {
                  _authMode=AuthMode.Signup;
                  _controller!.forward();   //part of animation
                }else
                {
                  _authMode=AuthMode.Login;
                  _controller!.reverse();  //part of animation
                }
              });
            }, child: (_authMode==AuthMode.Login)?Text("Sign up"):Text("Login"),)

          ],),
        ),
      ),
    ),
    );
  }
}

// niche anmiatedContainer use kar rahe hai instead of animated builder usme fir controller and _heightanimation ki jarurat bhi nhi
// class Authcard extends StatefulWidget {
//   const Authcard({Key? key}) : super(key: key);
//
//
//   @override
//   State<Authcard> createState() => _AuthcardState();
// }
//
// class _AuthcardState extends State<Authcard> with TickerProviderStateMixin{
//
//   AnimationController ?_controller;
//   // Animation<Size> ?_heightanimation;
//   Animation<double> ?_opacityanimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(vsync: this,duration: Duration(milliseconds: 800));
//   //   _heightanimation = Tween<Size>(begin: Size(double.infinity,280),end: Size(double.infinity,350)).animate(
//   //     CurvedAnimation(parent: _controller!, curve: Curves.fastOutSlowIn)
//   //   );   //Tween only show the information that how to animate b/w two value kaise animate karna hai ye nhi batata,ye .animate batata hai jo iske baad use kare hai
//   // // _heightanimation!.addListener(() => setState(() {}));        //instead of that we use animated builder so that we can rebuild a part
//   _opacityanimation = Tween(begin: 0.0,end: 1.0).animate(CurvedAnimation(parent: _controller!, curve: Curves.fastOutSlowIn));
//   }
//
//   // @override
//   // void dispose() {
//   //   super.dispose();
//   //   _controller!.dispose();  //we also need to dispose our listener when state or widget removed
//   // }
//
//   void showdialog (String message){
//     showDialog(context: context, builder: (context) {
//       return AlertDialog(title: Text("An Error Occured"),content: Text(message),actions: [
//         TextButton(onPressed: () {
//           Navigator.of(context).pop();
//         }, child: Text("Ok"))
//       ],);
//     });
//   }
//
//   GlobalKey<FormState> _formkey = GlobalKey();
//   AuthMode _authMode = AuthMode.Login;
//   Map<String,dynamic> details = {
//     'Email': '',
//     'Password': ''
//   };
//   var _isloading = false;
//   final _password = TextEditingController();
//
//
//
//   Future<void> submit() async{
//     final check = _formkey.currentState!.validate();
//     if(!check)
//       {
//         return;
//       }
//     _formkey.currentState!.save();
//     setState(() {
//       _isloading = true;
//     });
//    try{
//      if(_authMode == AuthMode.Login)
//      {
//        await Provider.of<Auth>(context,listen: false).Login(details['Email'], details['Password']);
//      }
//      if(_authMode == AuthMode.Signup)
//      {
//        await Provider.of<Auth>(context,listen: false).SignUp(details['Email'], details['Password']);
//      }
//    } on Exception catch(error){
//      print("hello");
//      print(error);
//      var errormesage = 'Authentication failed, please try again later';
//      if(error.toString()=='EMAIL_NOT_FOUND')
//        {
//          errormesage = "Could not find a user with email";
//        }else if(error.toString().contains('EMAIL_EXISTS'))
//          {
//              errormesage = 'The email is already in used';
//          }else if(error.toString().contains('INVALID_EMAIL'))
//            {
//              errormesage = 'This is not a valid email';
//            }else if(error.toString().contains('WEAK_PASSWORD'))
//              {
//                errormesage = 'password is too weak';
//              }else if(error.toString().contains('INVALID_PASSWORD'))
//                {
//                  errormesage = 'Wrong password,please enter the correct password';
//                }
//      showdialog(errormesage);
//
//    } catch (error) {
//      print(error);
//      print("run");
//     var errormessage = 'Could not Authenticate you. please try again later';
//     showdialog(errormessage);
//    }
//     setState(() {
//       _isloading=false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final sizebox = MediaQuery.of(context).size;
//     return SingleChildScrollView(
//       child: AnimatedContainer(
//         height: _authMode==AuthMode.Login?sizebox.height*0.40:sizebox.height*0.50,  //it own animate when the height or width change even it also animate in padding
//         //   height: _heightanimation!.value.height,    //double me karne ke liye .value.height use karna padda
//         //   constraints: BoxConstraints(minHeight: _authMode==AuthMode.Login?300:400),
//           decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.white),
//           width: sizebox.width*0.80,
//           duration: Duration(milliseconds: 800),
//           curve: Curves.fastOutSlowIn,
//           child: Form(
//         key: _formkey,
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child:SingleChildScrollView(
//             child: Column(children: [
//               TextFormField(
//                 decoration: InputDecoration(labelText: "Email",labelStyle: TextStyle(fontSize: 20),hintText: "Enter the Email",),
//                 onSaved: (value) {
//                   details['Email'] = value;
//                 },
//                 validator: (value) {
//                   if(value!.isEmpty || !value.contains('@'))
//                   {
//                     return "Invalid Email";
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: "Password",labelStyle: TextStyle(fontSize: 20),hintText: "Password greater than 6 letter",),
//                 controller: _password,
//                 obscureText: true,
//                 onSaved: (value) {
//                   details['Password']=value;
//                 },
//                 validator: (value) {
//                   if(value==null)
//                   {
//                     return "Password can't be Empty";
//                   }
//                   if(value.length<=6)
//                   {
//                     return "Password must be grater than 6";
//                   }
//                   return null;
//                 },
//               ),
//                 AnimatedContainer(duration: Duration(milliseconds: 800),
//                   curve: Curves.easeIn,
//                   // color: Colors.red,
//                   height: _authMode==AuthMode.Login?0:60,
//                   // constraints: BoxConstraints(minHeight: AuthMode==AuthMode.Signup?60:0,maxHeight: AuthMode==AuthMode.Signup?80:0),
//                   child: FadeTransition(   //it is already built listener so no need to add listener
//                     opacity: _opacityanimation!,
//                     child: TextFormField(
//                       decoration: InputDecoration(labelText: "Confirm Password",labelStyle: TextStyle(fontSize: 20),hintText: "Enter Password Again"),
//                       obscureText: true,
//                       enabled: _authMode==AuthMode.Signup,
//                       onSaved: (value) {
//                         details['Password'] = value;
//                       },
//                       validator: (_authMode==AuthMode.Signup)?(value) {
//                         if(value!=_password.text)
//                         {
//                           return "Password do not match";
//                         }
//
//                         return null;
//                       }:null,
//                     ),
//                   ),
//                 ),
//               SizedBox(height: MediaQuery.of(context).size.height*0.03,),
//               (!_isloading)?ElevatedButton(onPressed: () {
//                 submit();
//                 FocusScope.of(context).unfocus();
//               }, child: (_authMode==AuthMode.Login)?Text("Login"):Text("Sign up")):CircularProgressIndicator(),
//               TextButton(onPressed: () {
//                 setState(() {
//                   FocusScope.of(context).unfocus();
//                   if(_authMode==AuthMode.Login)
//                   {
//                     _authMode=AuthMode.Signup;
//                     _controller!.forward();   //part of animation
//                   }else
//                   {
//                     _authMode=AuthMode.Login;
//                     _controller!.reverse();  //part of animation
//                   }
//                 });
//               }, child: (_authMode==AuthMode.Login)?Text("Sign up"):Text("Login"),)
//
//             ],),
//           ),
//         ),
//       ),
//       ),
//     );
//   }
// }
//
