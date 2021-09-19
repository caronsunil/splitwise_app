import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'BalanceScreen.dart';
import 'AddScreen.dart';
import 'AllExpenseScreen.dart';

class HomeScreen extends StatefulWidget {
  Map<String, double> oweMap;
  HomeScreen({this.oweMap});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {



  void handleClick(String value){
    switch(value){
      case 'Sign Out':
        FirebaseAuth.instance.signOut();
        Phoenix.rebirth(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120.0),
          child: AppBar(
            actions: <Widget>[
              PopupMenuButton<String>(
                onSelected: handleClick,
                itemBuilder: (BuildContext context) {
                  return {'${FirebaseAuth.instance.currentUser.email}', 'Sign Out'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],
            backgroundColor: Color(0xFF804FB3),
            title: Text("SplitWise"),
            bottom: TabBar(
              tabs: [
                buildTab("Add an Expense"),
                buildTab("Balance"),
                buildTab("All Expenses"),
              ],
            ),
          ),
        ),

        body: TabBarView(
            children: [
              AddScreen(),
              BalanceScreen(),
              AllExpenseScreen(),
            ],
        ),
      ),
    );
  }

  Widget buildTab(String x){
    return Tab(
      child: Center(
        child: Text(
          x,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
