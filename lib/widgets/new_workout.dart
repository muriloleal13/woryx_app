import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_complete_guide/providers/exercises.dart';
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
  final _descController = TextEditingController();
  final _timesController = TextEditingController();
  String _selectedTitle = '';
  String _selectedRec = '';
  DateTime _selectedDate;
  TimeOfDay _selectedTime;
  Color pickerColor = Color(0xff443a49);
  Color _selectedColor = Color(0xff443a49);
  List<bool> _currDays = [];
  List<String> _weekDays = ['Mon', 'Tue', 'Wed'];

  @override
  void initState() {
    super.initState();
    _currDays = List<bool>.filled(_weekDays.length, false);
  }

  Future<void> _submitData() async {
    if (_descController.text.isEmpty) {
      return;
    }
    final enteredDesc = _descController.text;
    final enteredTimes = _timesController.text;

    if (_selectedTitle.isEmpty || _selectedDate == null) {
      return;
    }

    final newTx = WorkoutPlanItem(
      id: DateTime.now().toString(),
      title: _selectedTitle,
      description: enteredDesc,
      date: _selectedDate,
      time: _selectedTime,
      recurrency: _selectedRec,
      times: enteredTimes.isNotEmpty ? enteredTimes : '1',
      color: _selectedColor,
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
      initialTime:
          TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (newTime != null) {
      setState(() {
        _selectedTime = newTime;
      });
    }
  }

  void _presentColorPicker() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: (val) {
              setState(() {
                _selectedColor = val;
              });
            },
            showLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('Set Color'),
            onPressed: () {
              setState(() => _selectedColor = pickerColor);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Exercises>(context);
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<String>.empty();
                  }
                  return productsData.itemName.where((String option) {
                    return option
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase().trim());
                  });
                },
                onSelected: (String selection) {
                  setState(() {
                    _selectedTitle = selection;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Description'),
                controller: _descController,
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
                          _selectedRec == 'Daily'
                              ? TextField(
                                  decoration:
                                      InputDecoration(labelText: 'Times'),
                                  controller: _timesController,
                                  onSubmitted: (_) => _submitData(),
                                  keyboardType: TextInputType.number,
                                )
                              : (_selectedRec == 'Weekly'
                                  ? Expanded(
                                      child: Container(
                                        height: 500,
                                        child: Column(children: [
                                          ListView.builder(
                                              itemCount: _weekDays.length,
                                              itemBuilder: (context, index) {
                                                return CheckboxListTile(
                                                  title: Text(_weekDays[index]),
                                                  value: _currDays[index],
                                                  onChanged: (val) {
                                                    setState(
                                                      () {
                                                        _currDays[index] = val;
                                                      },
                                                    );
                                                  },
                                                );
                                              })
                                        ]),
                                      ),
                                    )
                                  : SizedBox(height: 0)),
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
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedColor == null
                            ? 'No Color Chosen!'
                            : 'Picked Color: ${_selectedColor}',
                      ),
                    ),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                        'Choose Color',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: _presentColorPicker,
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
