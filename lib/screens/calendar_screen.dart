import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/new_workout.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../widgets/app_drawer.dart';
import '../providers/workoutplan.dart';

enum FilterOptions {
  Favorites,
  All,
}

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProducts(); // WON'T WORK!
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<WorkoutPlan>(context).fetchAndSetWorkouts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<WorkoutPlan>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Woryx App'),
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
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _startAddNewTransaction(context),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
        drawer: AppDrawer(),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SfCalendar(
                view: CalendarView.week,
                firstDayOfWeek: 6,
                dataSource:
                    MeetingDataSource(getAppointments(productsData.items)),
              ));
  }
}

void _startAddNewTransaction(BuildContext ctx) {
  showModalBottomSheet(
    context: ctx,
    builder: (_) {
      return GestureDetector(
        onTap: () {},
        child: NewWorkout(),
        behavior: HitTestBehavior.opaque,
      );
    },
  );
}

List<Appointment> getAppointments(List<WorkoutPlanItem> items) {
  List<Appointment> meetings = <Appointment>[];
  items.forEach((value) {
    print('${value.date} ${value.time} ${value.recurrency} ${value.times}');
    final DateTime startTime = DateTime(value.date.year, value.date.month,
        value.date.day, value.time.hour, value.time.minute);
    final DateTime endTime = startTime.add(const Duration(hours: 1));
    meetings.add(Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: value.title,
      color: Colors.blue,
      recurrenceRule: value.recurrency.isNotEmpty
          ? 'FREQ=${value.recurrency.toUpperCase()};${value.times != null ? 'INTERVAL=1;COUNT=${value.times}' : ''}'
          : '',
    ));
  });
  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
