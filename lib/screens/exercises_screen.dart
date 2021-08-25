import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/exercises.dart';
import '../widgets/exercises_item.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ListExercisesScreen extends StatefulWidget {
  static const routeName = '/exercises-list';

  @override
  _ListExercisesScreenState createState() => _ListExercisesScreenState();
}

class _ListExercisesScreenState extends State<ListExercisesScreen> {
  var _showOnlyFavorites = false;

  Future<void> _refreshExercises(BuildContext context) async {
    await Provider.of<Exercises>(context, listen: false).fetchAllExercises();
  }

  @override
  Widget build(BuildContext context) {
    print('rebuilding...');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
        ],
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
