import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_qr/userManagement.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,

      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState(this.title);
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{

  _MyHomePageState(this.title);
  final title;

  String imageUrl;
  String _email;
  String _password;
  bool color = false;
  Color pickerColor = new Color(0xff443a49);
  AnimationController _animationController;

  String qrUrl;
  String name;



  @override
  void initState() {

    FirebaseAuth.instance.currentUser()
    .then((user) {
      Firestore.instance.collection('users')
      .where('uid', isEqualTo: user.uid)
          .getDocuments()
          .then((value) {
            setState(() {
              qrUrl =    value.documents[0].data['qrCodeUrl'];
              name = value.documents[0].data['displayName'];
            });


      });
    });

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    super.initState();
  }

  void _handleOnPressed(){
    setState(() {
      color = !color;
      color ? _animationController.forward() :
      _animationController.reverse();
    });
  }

  void changeColor(Color color){
    setState(() {
      pickerColor = color;

    });
  }



  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(name == null ? "QR Code Generator" : "Welcome, ${name}"),
        leading: Icon(Icons.android, color: Colors.greenAccent,),
        backgroundColor:  Color.fromRGBO(0, 36, 124, 1),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.image, color: Colors.white,),
            onPressed: (){

            },
          )
        ],
      ),

      backgroundColor: Color.fromRGBO(0, 36, 124, 1),
      body: ListView(
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    Center(
                      child: Container(
                        height: 200,
                        width: 200,
                        child: Image.asset('assets/frame.png'),
                      ),
                    ),

                    qrUrl != null ? Center(
                      child: Container(
                        padding: EdgeInsets.only(top: 10),
                        height: 190,
                        width: 190,
                        child: FadeInImage.assetNetwork(placeholder: "assets/loading.gif", image: qrUrl),
                      ),
                    ): Container()
                  ],
                ),

                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 40,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: Colors.white70
                  ),
                  child: Center(
                    child: ListTile(
                      title: Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          cursorColor: Colors.black,
                          onChanged: (value){
                            setState(() {
                              _email = value;
                            });
                          },
                          decoration: new InputDecoration(
                              icon: Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Icon(Icons.supervised_user_circle, color: Colors.black87,),
                              ),
                              hintText: "Enter Email",
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15)
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 40,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: Colors.white70
                  ),
                  child: Center(
                    child: ListTile(
                      title: Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          cursorColor: Colors.black,
                          onChanged: (value){
                            setState(() {
                              name = value;
                            });
                          },
                          decoration: new InputDecoration(
                              icon: Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Icon(Icons.edit, color: Colors.black87,),
                              ),
                              hintText: "Enter Name",
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15)
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 40,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: Colors.white70
                  ),
                  child: Center(
                    child: ListTile(
                      title: Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          cursorColor: Colors.black,
                          onChanged: (value){
                            setState(() {
                              _password = value;
                            });
                          },
                          decoration: new InputDecoration(
                              icon: Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Icon(Icons.vpn_key, color: Colors.black87,),
                              ),
                              hintText: "Enter password",
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15)
                          ),
                        ),
                      ),
                    ),
                  ),
                ),


                SizedBox(
                  height: 15,
                ),


                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 50),
                      height: 70,
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          color: Color.fromRGBO(255, 144, 39, 1)
                      ),
                      child: FlatButton(
                        child: Text("CREATE QR", style: TextStyle(
                            color: Colors.white
                        ),),
                        onPressed: (){
                          if(_email != null){
                            FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: _email,
                                password: _password).then((value) {
                              setState(() {
                                UserManagement().storeNewUser(value, context, name);
                              });
                            });

                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 50),
                      height: 70,
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          color: Color.fromRGBO(0, 180, 245, 1)
                      ),
                      child: FlatButton(
                        child: Text("SAVE QR", style: TextStyle(
                            color: Colors.white
                        ),),
                        onPressed: (){

                        },
                      ),
                    )

                  ],
                )

              ],
            ),
          )
        ],
      ),

    );
  }
}
