import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splitwise_app/EditTransaction.dart';
import 'globalVar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



String receiver='receiver';
String amount='amount';
String ower='ower';


class AllExpenseScreen extends StatefulWidget {
  @override
  _AllExpenseScreenState createState() => _AllExpenseScreenState();
}

class _AllExpenseScreenState extends State<AllExpenseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildList(),
    );
  }
  
  Widget buildList(){
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Expense').snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData){
            return Center(
              child: Container(
                decoration: kBoxDecorationStyle,
                alignment: Alignment.topCenter,
                height: 40,
                width: 200,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text("No transactions yet")),
                ),
              ),
            );
          }
          else{
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 130,
                  child: Center(
                    child: Column(
                      children: [
                        buildTile(snapshot.data.docs[index], index),
                        SizedBox(height: 10,),
                      ],
                    ),
                  ),
                );
              }
            );
          }
        }
    );
  }

  Widget buildTile(DocumentSnapshot a, int index){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      height: 120,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            Expanded(

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(flex:10, child: Text("Owed by: ${a[ower]}")),
                  SizedBox(width: 10,),
                  Expanded(flex:3, child:Text("Amt: ${a[amount]}")),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(flex:10, child: Text("Owed to: ${a[receiver]}")),
                SizedBox(width: 10,),
                Expanded(flex:3, child:buildButton(a, index),),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton(DocumentSnapshot a, int index){
    if(a[receiver]==FirebaseAuth.instance.currentUser.email){
      return RaisedButton(onPressed: (){
        UserTransactions aa=UserTransactions();
        aa.id=a.id;
        aa.amount=a[amount];
        aa.receiver=a[receiver];
        aa.ower=a[ower];
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EditTransaction(a: aa, transListIndex: index,)));
        },
        child: Text("Edit",
          style: whiteSmallTextStyle,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Color(0xFFba8fdb),
        );
    }
    else return Container();
  }

}
