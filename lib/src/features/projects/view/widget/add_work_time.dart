import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tt_bytepace/src/features/projects/bloc/detail_project_bloc/detail_project_bloc.dart';
import 'package:tt_bytepace/src/features/projects/utils/methods.dart';
import 'package:tt_bytepace/src/resources/constant_size.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddWorkTime extends StatefulWidget {
  final int projectID;
  const AddWorkTime({super.key, required this.projectID});

  @override
  State<AddWorkTime> createState() => _AddWorkTimeState();
}

class _AddWorkTimeState extends State<AddWorkTime> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _durationEditingController =
      TextEditingController();
  final TextEditingController _toTextEditingController =
      TextEditingController();
  final TextEditingController _fromTextEditingController =
      TextEditingController();

  DateTime selectedDate = DateTime.now();
  Duration _durationTime = const Duration();
  String _description = '';

  @override
  void initState() {
    updateDurationAndTime("00:30");
    _durationEditingController.text = generateTimeList().first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(AppLocalizations.of(context)!.addTime,
            style: Theme.of(context).textTheme.headlineMedium),
        Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  //description textfield
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!
                              .activityDescriptionHint),
                      onSaved: (value) {
                        _description = value!;
                      },
                    ),
                  ),
                  //select date
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: SizedBox(
                      width: 90,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(Icons.calendar_month),
                          Text(
                              "${MaterialLocalizations.of(context).formatMonthYear(selectedDate).substring(0, 3)} ${selectedDate.day}")
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              ////textfield duration
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  MaskTextInputFormatter(
                    initialText: _durationEditingController.text,
                    mask: '#&:*^',
                    filter: filter,
                  )
                ],
                controller: _durationEditingController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.arrow_drop_down),
                    onPressed: () {
                      _showDropdownMenu(context);
                    },
                  ),
                ),
                onChanged: updateDurationAndTime,
                validator: (value) {
                  if (value == null) {
                    return AppLocalizations.of(context)!
                        .pleaseEnterDurationError;
                  }
                  List<String> parts = value.split(":");
                  int hours = int.parse(parts[0]);
                  if (hours >= 24) {
                    return AppLocalizations.of(context)!.durationUpTo24Error;
                  }

                  return null;
                },
              ),
              Row(
                children: [
                  Text(AppLocalizations.of(context)!.workedFrom,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.grey[700])),
                  const SizedBox(width: 16),

                  //textfield worked from
                  Expanded(
                    child: TextFormField(
                      controller: _fromTextEditingController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        MaskTextInputFormatter(
                          initialText: _fromTextEditingController.text,
                          mask: '#&:*^',
                          filter: filter,
                        )
                      ],
                      onChanged: _updateFromTime,
                    ),
                  ),
                  const SizedBox(width: 16),

                  Text(AppLocalizations.of(context)!.workedTo,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.grey[800])),
                  const SizedBox(width: 16),

                  //textfield worked to
                  Expanded(
                    child: TextFormField(
                      controller: _toTextEditingController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        MaskTextInputFormatter(
                            initialText: _toTextEditingController.text,
                            mask: '#&:*^',
                            filter: filter)
                      ],
                      onChanged: _updateToTime,
                      validator: (value) {
                        if (value != null &&
                            isFutureTime(value, selectedDate)) {
                          return AppLocalizations.of(context)!.futureWorkError;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: ConstantSize.defaultSeparatorHeight),

              //Button submit
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      List<String> timeFrom =
                          _fromTextEditingController.text.split(":");
                      int fromHours = int.parse(timeFrom[0]);
                      int fromMinutes = int.parse(timeFrom[1]);
                      List<String> timeTo =
                          _toTextEditingController.text.split(":");
                      int toHours = int.parse(timeTo[0]);
                      int toMinutes = int.parse(timeTo[1]);

                      DateTime startTime = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          fromHours,
                          fromMinutes);

                      DateTime endTime = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day + (fromHours > toHours ? 1 : 0),
                          toHours,
                          toMinutes);

                      BlocProvider.of<DetailProjectBloc>(context).add(
                          AddWorkTimeEvent(
                              description: _description,
                              projectID: widget.projectID,
                              startTime: startTime.toIso8601String(),
                              endTime: endTime.toIso8601String()));
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.submitButtonText))
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showDropdownMenu(BuildContext context) async {
    final selectedValue = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.selectPeriod),
          content: SizedBox(
            height: 250,
            child: SingleChildScrollView(
              child: Column(
                children: generateTimeList().map((item) {
                  return SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, item);
                    },
                    child: Text(item),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );

    if (selectedValue != null) {
      setState(() {
        _durationEditingController.text = selectedValue;
        List<String> parts = selectedValue.split(":");
        int hours = int.parse(parts[0]);
        int minutes = int.parse(parts[1]);
        _durationTime = Duration(
            hours: hours, minutes: minutes); // Обновляем значение времени
        _toTextEditingController.text = DateFormat.Hm().format(DateTime.now());

        final resultDateTime = DateTime.now().subtract(_durationTime);
        String formattedResultTime =
            '${resultDateTime.hour.toString().padLeft(2, '0')}:${resultDateTime.minute.toString().padLeft(2, '0')}';
        _fromTextEditingController.text = formattedResultTime;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _updateFromTime(String value) {
    try {
      List<String> parts = value.split(":");
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);
      final newTime = Duration(hours: hours, minutes: minutes) + _durationTime;
      String formattedTime =
          '${newTime.inHours.toString().padLeft(2, '0')}:${newTime.inMinutes.remainder(60).toString().padLeft(2, '0')}';
      _toTextEditingController.text = formattedTime;
    } catch (e) {}
  }

  void _updateToTime(String value) {
    try {
      List<String> parts = value.split(":");
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);
      final newTime = Duration(hours: hours, minutes: minutes) - _durationTime;
      String formattedTime =
          '${newTime.inHours.toString().padLeft(2, '0')}:${newTime.inMinutes.remainder(60).toString().padLeft(2, '0')}';
      _fromTextEditingController.text = formattedTime;
    } catch (e) {}
  }

  void updateDurationAndTime(String value) {
    try {
      List<String> parts = value.split(":");
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);
      _durationTime = Duration(hours: hours, minutes: minutes);

      _toTextEditingController.text = DateFormat.Hm().format(DateTime.now());

      final resultDateTime = DateTime.now().subtract(_durationTime);
      String formattedResultTime =
          '${resultDateTime.hour.toString().padLeft(2, '0')}:${resultDateTime.minute.toString().padLeft(2, '0')}';
      _fromTextEditingController.text = formattedResultTime;
    } catch (e) {}
  }
}
