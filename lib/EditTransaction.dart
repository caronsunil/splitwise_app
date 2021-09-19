import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:splitwise_app/HomeScreen.dart';
import 'globalVar.dart';

class EditTransaction extends StatefulWidget {
  UserTransactions a;
  int transListIndex;
  EditTransaction({this.a, this.transListIndex});
  @override
  _EditTransactionState createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  TextEditingController amountCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF804FB3),
        title: Text("Owed by: ${widget.a.ower}"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Amt: ${widget.a.amount}",
                    style: TextStyle(
                      fontSize: 27,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                decoration: kBoxDecorationStyle,
                child: Padding(
                  padding: const EdgeInsets.only(left:18.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Enter new amount",
                      hintStyle: greyTextStyle,
                      border: InputBorder.none,
                    ),
                    controller: amountCtrl,
                    keyboardType: TextInputType.numberWithOptions(),
                  ),
                ),
              ),
              SizedBox(height: 10),
              RaisedButton(onPressed: editTransaction,
                child: Text("Edit Amount",
                  style: whiteSmallTextStyle,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Color(0xFFba8fdb),
              ),
              RaisedButton(onPressed: deleteTransaction,
                child: Text("Delete Transaction",
                  style: whiteSmallTextStyle,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Color(0xFFba8fdb),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void editTransaction() async {
    if(amountCtrl.text==null) Navigator.pop(context);
    else {
      double newAmt = double.parse(amountCtrl.text);
      double difference = widget.a.amount - newAmt;

      if(oweMap.containsKey(widget.a.ower)) {
        oweMap.update(widget.a.ower, (value) => value + difference);
        if (oweMap[widget.a.ower] == 0.0) oweMap.remove(widget.a.ower);
      }
      transactionList[widget.transListIndex].amount = newAmt;

      await FirebaseFirestore.instance.collection('Expense')
          .doc(widget.a.id)
          .set({
        'amount': newAmt,
        'ower': widget.a.ower,
        'receiver': widget.a.receiver,
      });
    }
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => HomeScreen()));

  }

  void deleteTransaction() async{
    transactionList.removeAt(widget.transListIndex);
    if(oweMap.containsKey(widget.a.ower)) {
      oweMap.update(widget.a.ower, (value) => value + widget.a.amount);
      if (oweMap[widget.a.ower] == 0.0) oweMap.remove(widget.a.ower);
    }
    await FirebaseFirestore.instance.collection('Expense').doc(widget.a.id).delete();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => HomeScreen()));
  }

}