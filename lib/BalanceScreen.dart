import 'package:flutter/material.dart';
import 'globalVar.dart';

String receiver='receiver';
String amount='amount';
String ower='ower';

class BalanceScreen extends StatefulWidget {
  @override
  _BalanceScreenState createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  List<String> youOwe= List<String>();
  List<String> owesYou= List<String>();

  @override
  void initState() {
    // implement initState
    super.initState();
    oweMap.forEach((key, value) {
      if(value>0)youOwe.add(key);
      else owesYou.add(key);
    });
    print("you owe:");
    print(youOwe);
    print("owes you:");
    print(owesYou);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height:10),
            Text("Who owes you?",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height:10),
            buildList(owesYou),
            SizedBox(height:10),
            Text("Who do you owe?",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height:10),
            buildList(youOwe),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget buildList(List oweList){
    if(oweList.isEmpty || oweList==null) {
      return Center(
        child: Container(
          decoration: kBoxDecorationStyle,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("No one yet"),
          ),
        ),
      );
    }
    else {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: oweList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 50,
              child: Center(
                child: buildTile(oweList[index]),
              ),
            );
          }
      );
    }
  }

  Widget buildTile(String name){
    double amt= oweMap[name];
    if(amt<0)amt=0-amt;
    return Container(
      height: 40,
      decoration: kBoxDecorationStyle,
      child: Padding(
        padding: const EdgeInsets.only(left: 14.0, right: 14.0),
        child: Row(

          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name),
            Text("Amt: $amt"),
          ],
        ),
      ),
    );
  }



}
