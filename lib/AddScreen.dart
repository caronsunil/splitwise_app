import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'globalVar.dart';
import 'package:toast/toast.dart';
import 'package:email_validator/email_validator.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final userfieldText = TextEditingController();
  TextEditingController amount = TextEditingController();

  String userEmail;
  List<String> listOfUsers=List<String>();



  void addToList(){
    if(userfieldText.text==null || userfieldText.text.length==0 || !EmailValidator.validate(userfieldText.text)){
      Toast.show("You must enter a valid user email", context, backgroundColor: Colors.white, gravity: Toast.CENTER, textColor: Colors.black);
      return;
    }
    listOfUsers.add(userfieldText.text);
    print(listOfUsers);

    Toast.show("Added ${userfieldText.text}", context, backgroundColor: Colors.white, gravity: Toast.CENTER, textColor: Colors.black);
  }

  void addTransaction() async{
    double totalAmt;
    int len;
    try{
      totalAmt =double.parse(amount.text);
      len=listOfUsers.length;
    }
    catch(e){
      Toast.show("Enter details", context, backgroundColor: Colors.white, gravity: Toast.CENTER, textColor: Colors.black);
      return;
    }
    if(len==0){
      Toast.show("Enter details", context, backgroundColor: Colors.white, gravity: Toast.CENTER, textColor: Colors.black);
      return;
    }
    double amt=totalAmt/len;

    for(int i=0; i<len; i++) {
      String ower =listOfUsers[i];
      print("the ower is $ower");
      if(ower==FirebaseAuth.instance.currentUser.email)continue;
      DocumentReference doc=await FirebaseFirestore.instance.collection("Expense").add({
        'receiver': FirebaseAuth.instance.currentUser.email,
        'ower': ower,
        'amount': amt,
      });
      print("$ower $amt added");
      updateMapList(ower, amt);
    }
    listOfUsers.clear();
    amount.clear();
    Toast.show("Expense Added!", context, backgroundColor: Colors.white, gravity: Toast.CENTER, textColor: Colors.black);
  }

  void updateMapList(String ower, double amt){
    if(oweMap.containsKey(ower)){
      oweMap.update(ower, (value) => value - amt);
      if(oweMap[ower]==0.0)oweMap.remove(ower);
    }
    else oweMap[ower]=0-amt;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 30,),
            Container(
            decoration: kBoxDecorationStyle,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Enter a user's email",
                hintStyle: greyTextStyle,
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15),
              ),
              keyboardType: TextInputType.emailAddress,
              controller: userfieldText,
            ),
            ),
            SizedBox(height: 15,),
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                onPressed: (){
                  addToList();
                  userfieldText.clear();
                },
                child: Text("Add User",
                style: whiteSmallTextStyle,
                ),
                padding: EdgeInsets.all(15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Color(0xFFba8fdb),
              ),
              SizedBox(width: 10,),
              RaisedButton(
                onPressed: (){
                  listOfUsers.clear();
                  Toast.show("Removed all users from this transaction", context, backgroundColor: Colors.white, gravity: Toast.CENTER, textColor: Colors.black);
                },
                padding: EdgeInsets.all(15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Color(0xFFba8fdb),
                child: Text("Cancel",
                  style: whiteSmallTextStyle,
                ),
              ),
            ],
            ),
            SizedBox(height: 15,),
            Container(
            decoration: kBoxDecorationStyle,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Enter amount to be split",
                hintStyle: greyTextStyle,
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15),
              ),
              controller: amount,
              keyboardType: TextInputType.numberWithOptions(),
            ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: RaisedButton(
          onPressed:(){
            addTransaction();
          },
          child: Text("Add Expenses",
            style: whiteSmallTextStyle,
          ),
          padding: EdgeInsets.all(15.0),
          color: Color(0xFFba8fdb),
        ),
      ),
    );
  }

}
