import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/workouts_screen.dart';
import 'package:provider/provider.dart';

import '../screens/exercises_screen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Welcome!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.analytics_outlined),
            title: Text('Dashboard - COMING SOON!'),
            onTap: () {
              // Navigator.of(context)
              // .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          // Divider(),
          // ListTile(
          //   leading: Icon(Icons.calendar_today_rounded),
          //   title: Text('Calendar'),
          //   onTap: () {
          //     Navigator.of(context).pushReplacementNamed('/');
          //   },
          // ),
          Divider(),
          ListTile(
            leading: Icon(Icons.article_outlined),
            title: Text('Exercises'),
            onTap: () {
              Navigator.of(context).pushNamed(ListExercisesScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.account_tree_outlined),
            title: Text('Workout Plans'),
            onTap: () {
              Navigator.of(context).pushNamed(WorkoutsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              // Navigator.of(context)
              //     .pushReplacementNamed(UserProductsScreen.routeName);
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
