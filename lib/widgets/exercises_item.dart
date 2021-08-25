import 'package:flutter/material.dart';

class ListExercises extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  ListExercises(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: Icon(Icons.fitness_center),
      // CircleAvatar(
      //   backgroundImage: NetworkImage(imageUrl),
      // ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            // IconButton(
            //   icon: Icon(Icons.edit),
            //   onPressed: () {
            //     Navigator.of(context)
            //         .pushNamed(WorkoutPlan.routeName, arguments: id);
            //   },
            //   color: Theme.of(context).primaryColor,
            // ),
            // IconButton(
            //   icon: Icon(Icons.delete),
            //   onPressed: () async {
            //     try {
            //       await Provider.of<Exercises>(context, listen: false)
            //           .deleteExercise(id);
            //     } catch (error) {
            //       scaffold.showSnackBar(
            //         SnackBar(
            //           content: Text(
            //             'Deleting failed!',
            //             textAlign: TextAlign.center,
            //           ),
            //         ),
            //       );
            //     }
            //   },
            //   color: Theme.of(context).errorColor,
            // ),
          ],
        ),
      ),
    );
  }
}
