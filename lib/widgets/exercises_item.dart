import 'package:flutter/material.dart';

class ListExercises extends StatefulWidget {
  final String id;
  final String title;
  final String imageUrl;

  ListExercises(this.id, this.title, this.imageUrl);

  @override
  _ListExercisesState createState() => _ListExercisesState();
}

class _ListExercisesState extends State<ListExercises> {
  bool _isFav = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      leading: Icon(Icons.fitness_center),
      // CircleAvatar(
      //   backgroundImage: NetworkImage(imageUrl),
      // ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                  !_isFav ? Icons.favorite_border : Icons.favorite_rounded),
              onPressed: () {
                setState(() {
                  _isFav = !_isFav;
                });
                // Navigator.of(context)
                //     .pushNamed(WorkoutPlan.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
