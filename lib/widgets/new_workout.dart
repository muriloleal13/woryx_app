import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/workoutplan.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewWorkout extends StatefulWidget {
  static const routeName = '/new-workout';

  @override
  _NewWorkoutState createState() => _NewWorkoutState();
}

class _NewWorkoutState extends State<NewWorkout> {
  bool isSwitched = false;
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedRec = '';
  DateTime _selectedDate;
  TimeOfDay _selectedTime;

  Future<void> _submitData() async {
    if (_descController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredDesc = _descController.text;

    if (enteredTitle.isEmpty || _selectedDate == null) {
      return;
    }

    final newTx = WorkoutPlanItem(
      id: DateTime.now().toString(),
      title: enteredTitle,
      description: enteredDesc,
      date: _selectedDate,
      time: _selectedTime,
      recurrency: _selectedRec,
    );

    try {
      await Provider.of<WorkoutPlan>(context, listen: false).addItem(newTx);
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          content: Text('Something went wrong.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    final DateTime today = DateTime.now();
    showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today.subtract(const Duration(days: 7)),
      lastDate: today.add(const Duration(days: 7)),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
    print('...');
  }

  void _presentTimePicker() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 7, minute: 15),
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (newTime != null) {
      setState(() {
        _selectedTime = newTime;
      });
    }
    print('...');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
                // onChanged: (val) {
                //   titleInput = val;
                // },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Description'),
                controller: _descController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
                // onChanged: (val) => amountInput = val,
              ),
              Row(
                children: <Widget>[
                  Text('Recurrence'),
                  Center(
                      child: Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                        if (!isSwitched) _selectedRec = '';
                      });
                    },
                    activeTrackColor: Colors.yellow,
                    activeColor: Colors.orangeAccent,
                  )),
                ],
              ),
              isSwitched || _selectedRec.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          DropdownButton(
                            hint: _selectedRec.isEmpty
                                ? Text('Recurrence')
                                : Text(_selectedRec),
                            isExpanded: true,
                            items: ['Daily', 'Weekly', 'Monthly'].map(
                              (val) {
                                return DropdownMenuItem<String>(
                                  value: val,
                                  child: Text(val),
                                );
                              },
                            ).toList(),
                            onChanged: (val) {
                              setState(
                                () {
                                  _selectedRec = val;
                                },
                              );
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Times'),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                          ),
                        ])
                  : SizedBox(height: 0),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No Date Chosen!'
                            : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                      ),
                    ),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                        'Choose Date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: _presentDatePicker,
                    ),
                  ],
                ),
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedTime == null
                            ? 'No Time Chosen!'
                            : 'Picked Time: ${_selectedTime.format(context)}',
                      ),
                    ),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                        'Choose Time',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: _presentTimePicker,
                    ),
                  ],
                ),
              ),
              RaisedButton(
                child: Text('Add Workout'),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                onPressed: _submitData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
