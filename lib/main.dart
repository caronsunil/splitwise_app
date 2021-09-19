import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:splitwise_app/HomeScreen.dart';
import 'package:splitwise_app/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'globalVar.dart';

String receiver='receiver';
String amount='amount';
String ower='ower';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SplitWise',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'SplitWise'),
    );
}
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFba8fdb),
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("Welcome to SplitWise!",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            button(),
          ],
        ),
      ),
    );
  }

  Widget button(){
    String buttonText;
    buttonText="Continue to App";
    return RaisedButton(onPressed: goToApp,
      child: Text(buttonText,
        style: whiteSmallTextStyle,
      ),
      padding: EdgeInsets.all(15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Color(0xFFba8fdb),
    );
  }

  void goToApp() async{
    print("going to app");
    User user = FirebaseAuth.instance.currentUser;
    if(user==null){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => LoginScreen()));
    }
    else{
      oweMap.clear();
      transactionList.clear();
      await updateMapList();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => HomeScreen(oweMap: oweMap)));
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
        updateList(doc[ower], doc[amount], documentID, doc[receiver]);
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

}
