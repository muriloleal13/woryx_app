import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/exercises.dart';
import '../widgets/exercises_item.dart';
import '../widgets/app_drawer.dart';

class ListExercisesScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshExercises(BuildContext context) async {
    await Provider.of<Exercises>(context, listen: false).fetchAllExercises();
  }

  @override
  Widget build(BuildContext context) {
    print('rebuilding...');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises'),
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(Icons.add),
        //     onPressed: () {
        //       Navigator.of(context).pushNamed(WorkoutPlanScreen.routeName);
        //     },
        //   ),
        // ],
      ),
      // drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshExercises(context),
        child: Consumer<Exercises>(
          builder: (ctx, productsData, _) => Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
              itemCount: productsData.items.length,
              itemBuilder: (_, i) => Column(
                children: [
                  ListExercises(
                    productsData.items[i].id,
                    productsData.items[i].title,
                    productsData.items[i].imageUrl,
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
