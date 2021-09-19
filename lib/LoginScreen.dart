import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'HomeScreen.dart';
import 'globalVar.dart';
import 'package:toast/toast.dart';
import 'package:google_fonts/google_fonts.dart';

String _email;
String _password;

String receiver='receiver';
String amount='amount';
String ower='ower';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFB589D6),
                Color(0xFF9969C7),
                Color(0xFF804FB3),
                Color(0xFF6A359C),
              ],
              stops: [0.1, 0.4, 0.7, 0.9],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              SizedBox(height: 10),
              Text(
              'Sign In',
                // style: TextStyle(
                //   color: Colors.white,
                //   fontSize: 35,
                //   fontFamily: 'OpenSans',
                // ),
                style: GoogleFonts.montserrat(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  textStyle: TextStyle(
                    color: Colors.black54,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 40.0),
              buildEmailTF(),
              SizedBox(height: 30.0),
              buildPasswordTF(),
              SizedBox(height: 40.0),
              buildLoginBtn(),
            ]
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLoginBtn(){
    return RaisedButton(
      child: Text("Login"),
      onPressed: signIn,
      elevation: 5.0,
      padding: EdgeInsets.all(15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      color: Colors.white,

    );
  }

  void signIn() async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email:_email,
        password: _password,
      );
      oweMap.clear();
      transactionList.clear();
      await updateMapList();

      Toast.show("Successful Login!", context, backgroundColor: Colors.white, gravity: Toast.CENTER, textColor: Colors.black);

      Navigator.push(context,
        MaterialPageRoute(builder: (context) => HomeScreen()));
    }
    catch (e) {
      String s = e.message;
      print(s);
      if (e.message == null) {
        s = "Fill in the required fields.";
      }
      Toast.show(
          s,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white,
      );
    }
    }

  Future<void> updateMapList() {
    CollectionReference expenses= FirebaseFirestore.instance.collection("Expense");
    expenses.get().
    then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) async{
        print(doc[ower]);
        if(doc[ower]==FirebaseAuth.instance.currentUser.email){
          if(oweMap.containsKey(doc[receiver]))  oweMap.update(doc[receiver], (value) => value + doc[amount]);
          else oweMap[doc[receiver]]=doc[amount];

          if(oweMap[doc[receiver]]==0.0)oweMap.remove(doc[receiver]);
        }
        if(doc[receiver]==FirebaseAuth.instance.currentUser.email){
          if(oweMap.containsKey(doc[ower]))  oweMap.update(doc[ower], (value) => value - doc[amount]);
          else oweMap[doc[ower]]=0-doc[amount];

          if(oweMap[doc[ower]]==0.0)oweMap.remove(doc[ower]);
        }
        String documentID = await get_data(doc);
        updateList(doc[ower], doc[amount], documentID, doc[receiver]); //POSSIBLE ERROR? Try doc.id
        print(doc[ower]);
      });
    });
  }

  void updateList(String owerFunc, double amt, String docID,String receiverFunc){
    UserTransactions a=UserTransactions();
    a.id=docID;
    a.amount=amt;
    a.receiver=receiverFunc;
    a.ower=owerFunc;
    transactionList.add(a);
  }

  Future<String> get_data(DocumentSnapshot docSnap) async {
    var doc_id2 = docSnap.reference.id;
    return doc_id2;
  }

  Widget buildEmailTF(){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: kBoxDecorationStyle,
            height: 60.0,
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                hintText: 'Enter your Email',
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0, left: 8),
              ),
              onChanged: (String email) {
                _email = email;
              },
            ),
          ),
        ],
      );
    }

  Widget buildPasswordTF(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0, left: 8),
              hintText: 'Enter your Password',
            ),
            onChanged: (String pass) {
              _password = pass;
            },
          ),
        ),
      ],
    );
  }

}
