import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/workoutplan.dart';
import 'package:flutter_complete_guide/widgets/workout_item.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';

class WorkoutsScreen extends StatelessWidget {
  static const routeName = '/list-workouts';

  Future<void> _refreshWorkouts(BuildContext context) async {
    await Provider.of<WorkoutPlan>(context, listen: false)
        .fetchAndSetWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    print('rebuilding...');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(Icons.add),
        //     onPressed: () {
        //       Navigator.of(context).pushNamed(WorkoutPlanScreen.routeName);
        //     },
        //   ),
        // ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshWorkouts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshWorkouts(context),
                    child: Consumer<WorkoutPlan>(
                      builder: (ctx, productsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              WorkoutItem(productsData.items[i]),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
