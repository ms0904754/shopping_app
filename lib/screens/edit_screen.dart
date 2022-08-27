import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/provider/productlist.dart';

import '../provider/product.dart';

class edit_screen extends StatefulWidget {
  static const routename = "edit_screen";

  @override
  State<edit_screen> createState() => _edit_screenState();
}

class _edit_screenState extends State<edit_screen> {

  final nodespecifier = FocusNode();
  final nodespec = FocusNode();
  final imagecontrol = TextEditingController();
  final imagefocus = FocusNode();
  final _formkey = GlobalKey<FormState>();    //Global keys uniquely identify elements,For StatefulWidgets, global keys also provide access to State. here global key access the form state
  var inputsdata = product(title: '', price: 0, descp: '', image: '', id: '');
  bool loadindicator = false;
  
  @override
  void dispose() {                  //use it whenever we used focusnode to avoid memory leak or clear the memory which they occupy
    imagefocus.removeListener(updateurl);  // now we have to dispose listener otherwise the listener keeps on living in memory even the page is not present anymore and create memory leak
    nodespecifier.dispose();
    nodespec.dispose();
    imagecontrol.dispose();
    imagefocus.dispose();
    super.dispose();
  }
  @override
  void initState() {
    imagefocus.addListener(updateurl);                  // ye updaterurl function and initstate  isliye banaya hai taaki jab url text me url daalke bina done bataye dusre textfield me jaye to uski image dikhe
    super.initState();
  }

  var alreadytext = {
    'title': '',
    'Descp': '',
    'price': '',
    'image': ''

};

  var _isint = true;
  @override
  void didChangeDependencies() {
   if(_isint)
     {
       print("run");
       final productid = ModalRoute.of(context)!.settings.arguments as String;
       print(productid);
       if(productid!='null')
       {

         inputsdata = Provider.of<products>(context,listen: false).productById(productid);
         alreadytext = {
           'title': inputsdata.title,
           'Descp': inputsdata.descp,
           'price': inputsdata.price.toString(),
           'image': inputsdata.image
         };
         imagecontrol.text =  inputsdata.image;
       }
     }
    _isint=false;          //didchangedependencies multiple times run hota hai isliye one time run ke liye ye var declare kiya hai aur yaha false kiya hai
    super.didChangeDependencies();
  }

  void updateurl(){
    if(!imagefocus.hasFocus)
      {
        // if ((imagecontrol.text.isEmpty) || (!imagecontrol.text.startsWith('http') && !imagecontrol.text.startsWith('https')) ||
        //     (!imagecontrol.text.endsWith('.png') && !imagecontrol.text.endsWith('.jpg') && !imagecontrol.text.endsWith('.jpeg'))
        // )
        // {
        //   print("hi");
        //   return;
        // }else {
          setState(() {});
        // }

      }
}


  // void submittion()
  // {
  //   // _formkey.currentState?.validate(); //or  // par isme yaha condition check nhi kar rahe iski wazah se ye hoga niche wali lines bhi execute hogi
  //   final checker = _formkey.currentState?.validate();   // agar saare textfield valid hoge to ye true dega
  //   if(!checker!)
  //   {
  //     return;    // yaha pe hi function stop ho jayega aur niche ki 5 line execute nhi hogi
  //   }
  //   _formkey.currentState!.save();
  //   setState(() {
  //     loadindicator = true;
  //   });
  //   print(inputsdata.id);
  //   if(inputsdata.id!='')
  //     {
  //       Provider.of<products>(context,listen: false).updateproduct(inputsdata.id,inputsdata);
  //       setState(() {
  //         loadindicator=false;
  //       });
  //       Navigator.of(context).pop();
  //
  //     }else
  //       {
  //         Provider.of<products>(context,listen: false).addproduct(inputsdata).catchError((onError) {
  //           return showDialog(context: context, builder: (context) {
  //             return AlertDialog(title: Text("An Error Occured"),content: Text("Something went Wrong"),
  //             actions: [
  //               TextButton(onPressed: () {
  //                 Navigator.of(context).pop();
  //                 print(onError.toString());
  //               }, child: Text("Ok"))
  //             ],);
  //           }).then((value) {
  //             print("after error");
  //             setState(() {
  //               loadindicator = false;
  //             });
  //             Navigator.of(context).pop();
  //             return;
  //           });
  //
  //         }).then((value) {
  //           setState(() {
  //             loadindicator =false;
  //           });
  //           Navigator.of(context).pop();
  //         });
  //       }




  void submittion() async
  {
    // _formkey.currentState?.validate(); //or  // par isme yaha condition check nhi kar rahe iski wazah se ye hoga niche wali lines bhi execute hogi
    final checker = _formkey.currentState?.validate();   // agar saare textfield valid hoge to ye true dega
    if(!checker!)
    {
      return;    // yaha pe hi function stop ho jayega aur niche ki 5 line execute nhi hogi
    }
    _formkey.currentState!.save();
    setState(() {
      loadindicator = true;
    });
    print(inputsdata.id);
    if(inputsdata.id!='')
      {
        try{
          print("#");
          await Provider.of<products>(context,listen: false).updateproduct(inputsdata.id,inputsdata);
        } catch(error) {
          print("/");
          throw error;
        }

      }else
        {
          try {
            print('3');
          await Provider.of<products>(context,listen: false).addproduct(inputsdata);  //this is async code thats why here we write await
          } catch(Error){
            print('4');
              await showDialog(context: context, builder: (context) {    //await nhi lagaye to iss code complete hue bina aage wala chal jayega i.e final wala code
              return AlertDialog(title: Text("An Error Occured"),content: Text("Something went Wrong"),
                actions: [
                  TextButton(onPressed: () {
                    Navigator.of(context).pop();
                    print(Error.toString());
                  }, child: Text("Ok"))
                ],);
            });
          }
          // finally {     //this will run no matters above code will got error or not
          //   print('5');
          //   setState(() {
          //     loadindicator = false;
          //   });
          //   Navigator.of(context).pop();
          // }

        }
    print('5');
    setState(() {
      loadindicator = false;
    });
    Navigator.of(context).pop();

  }

  @override
  Widget build(BuildContext context) {
    print("again");
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit",style: TextStyle(fontFamily: 'Anton'),),
        centerTitle: true,
      ),
      body: loadindicator?Center(child: CircularProgressIndicator(),):Form(
          key: _formkey,
            child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 16),
            child: ListView(children: [
                TextFormField(
                  initialValue: alreadytext['title'],
                  decoration: InputDecoration(label: Text("Title",
                    style: TextStyle(fontFamily: 'Merriweather',
                        fontSize: 20,fontWeight: FontWeight.bold),),
                      hintText: "Enter the Title",
                      hintStyle: TextStyle(fontSize: 15,fontFamily: 'Merriweather',fontWeight: FontWeight.bold),border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  textInputAction: TextInputAction.go,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(nodespecifier);    // jaise hi right bottom button dabayege to jis focus node nodespecfier diya hai waha pe vo chala jayega

                    submittion();
                  },

                  onSaved: (value) {
                    inputsdata = product(title: value!,
                        price: inputsdata.price,
                        descp: inputsdata.descp,
                        image: inputsdata.image, id: inputsdata.id,
                      isfavourite: inputsdata.isfavourite        //ye isliye lagaya hai kyuki jab fav karne ke baad kuch edit karege to vapis shop pe jayege to vo fav hath jayega
                    );
                  },

                  validator: (value) {
                    if(value!.isEmpty)
                      {
                        return "Please Enter the Field";
                      }
                    return null;
                  },

                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.04,),
                TextFormField(
                  initialValue: alreadytext['price'],
                  decoration: InputDecoration(label: Text("Amount",
                    style: TextStyle(fontFamily: 'Merriweather',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),),
                      hintText: "Enter the Amount",
                      hintStyle: TextStyle(
                          fontSize: 15,fontFamily: 'Merriweather',
                          fontWeight: FontWeight.bold)
                      ,border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  textInputAction: TextInputAction.go,
                  keyboardType: TextInputType.number,
                  focusNode: nodespecifier,
                  onFieldSubmitted: (_) {
                    print(nodespec);
                    FocusScope.of(context).requestFocus(nodespec);

                    submittion();
                  },
                  onSaved: (value) {
                    inputsdata = product(title: inputsdata.title,
                        price: value!.isEmpty?inputsdata.price:double.parse(value),
                        descp: inputsdata.descp,
                        image: inputsdata.image,
                        id: inputsdata.id,
                        isfavourite: inputsdata.isfavourite );
                  },
                  validator: (value) {
                    if(value!.isEmpty)
                      {
                        return "Please Enter the price";
                      }
                    if(double.tryParse(value)==null)   //try parse error nhi deta balki invalid ho jata hai to null deta hai
                      {
                        return "Enter a Valid number";
                      }
                    if(double.parse(value)<=0)
                      {
                        return "Number must be greater than or equal to zero";
                      }
                    return null;
                  },
                ),
              SizedBox(height: MediaQuery.of(context).size.height*0.04,),
              TextFormField(
                initialValue: alreadytext['Descp'],
                  decoration: InputDecoration(label: Text("Description",
                    style: TextStyle(fontFamily: 'Merriweather',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),),
                      hintText: "Enter the description",
                      hintStyle: TextStyle(
                          fontSize: 15,fontFamily: 'Merriweather',
                          fontWeight: FontWeight.bold)
                      ,border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                 maxLines: 3,
                  // keyboardType: TextInputType.multiline,
                focusNode: nodespec,
                onFieldSubmitted: (_){

                    submittion();
                },
                onSaved: (value) {
                  inputsdata = product(title: inputsdata.title,
                      price: inputsdata.price,
                      descp: value!,
                      image: inputsdata.image,
                      id: inputsdata.id,
                  isfavourite: inputsdata.isfavourite);
                },
                validator: (value) {
                  if(value!.isEmpty)
                  {
                    return "Please Enter the Description";
                  }
                  if(value.length<10)
                    {
                      return "please enter description of atleast 10 character";
                    }
                  return null;
                },

                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.black)),
                  child: imagecontrol.text.isEmpty?Center(child: Text("Enter Url")):FittedBox(
                    child: Image.network(imagecontrol.text),
                  ),
                ),
                Expanded(child: TextFormField(
                  decoration: InputDecoration(label: Text("Image Url",style: TextStyle(fontFamily: 'Merriweather',
                      fontSize: 20,
                      fontWeight: FontWeight.bold),softWrap: true,)),
                  keyboardType: TextInputType.url,
                  controller: imagecontrol,                        //controller and initialValue cannot be used both at a time
                  focusNode: imagefocus,
                  onFieldSubmitted: (_){
                    submittion();
                  },
                  onSaved: (value) {
                    inputsdata = product(title: inputsdata.title,
                        price: inputsdata.price,
                        descp: inputsdata.descp,
                        image: value!,
                        id: inputsdata.id,
                    isfavourite: inputsdata.isfavourite);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Enter the url";
                    }
                    if(!value.startsWith('http') && !value.startsWith('https'))
                    {
                      return "Enter a valid Url";
                    }
                    // if(!value.endsWith('.png') && !value.endsWith('.jpg') && !value.endsWith('.jpeg'))
                    // {
                    //   return "Enter a valid Url";
                    // }

                    return null;
                  }

    ))
              ],),
              SizedBox(height: MediaQuery.of(context).size.height*0.03,),
              Container(
                height: 50,
                child: FittedBox(
                  child: ElevatedButton(onPressed: () {
                      submittion();
                      setState(() {
                        FocusScope.of(context).unfocus();

                      });
                      },
                      child: Text("Submit",style: TextStyle(fontSize: 20,fontFamily: 'Merriweather',fontWeight: FontWeight.bold),
                      ),
                  ),
                ),
              ),
            ],),
          )),
    );
  }
}
