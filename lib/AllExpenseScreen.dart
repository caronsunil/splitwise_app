import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splitwise_app/EditTransaction.dart';
import 'globalVar.dart';

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
    if(transactionList.isEmpty || transactionList==null) {
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
    else {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: transactionList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 130,
              child: Center(
                child: Column(
                  children: [
                  buildTile(transactionList[index], index),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
            );
          }
      );
    }
  }

  Widget buildTile(UserTransactions a, int index){
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
                  Expanded(flex:10, child: Text("Owed by: ${a.ower}")),
                  SizedBox(width: 10,),
                  Expanded(flex:3, child:Text("Amt: ${a.amount}")),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(flex:10, child: Text("Owed to: ${a.receiver}")),
                SizedBox(width: 10,),
                Expanded(flex:3, child:buildButton(a, index),),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton(UserTransactions a, int index){
    if(a.receiver==FirebaseAuth.instance.currentUser.email){
      return RaisedButton(onPressed: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EditTransaction(a: a, transListIndex: index,)));
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
