import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/workoutplan.dart';

class WorkoutItem extends StatelessWidget {
  final WorkoutPlanItem workout;

  WorkoutItem(this.workout);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(workout.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text(
              'Do you want to remove the workout plan?',
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<WorkoutPlan>(context, listen: false).removeItem(workout.id);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: workout.date.isAfter(DateTime.now())
                  ? Colors.red
                  : Colors.green,
              foregroundColor: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text(
                      '${workout.date.isAfter(DateTime.now()) ? 'TODO' : 'OK'}'),
                ),
              ),
            ),
            title: Text(workout.title),
            subtitle: Text(workout.description),
            trailing: Text(DateFormat('dd/MM/yyyy hh:mm').format(workout.date)),
          ),
        ),
      ),
    );
  }
}
