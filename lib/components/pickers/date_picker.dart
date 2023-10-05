import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  final bool? enabled;
  final DateTime selectedDate;
  final Function(DateTime) updateSelectedDate;

  DatePicker(
      {this.enabled = true,
      required this.selectedDate,
      required this.updateSelectedDate});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    currentDate = widget.selectedDate;
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      currentDate: currentDate,
    );

    if (picked != null && picked != widget.selectedDate) {
      setState(() {
        currentDate = picked;
      });
      widget.updateSelectedDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Date de soutenance',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () => widget.enabled ?? true ? _selectDate(context) : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Date choisi:'),
              Text("${currentDate.toLocal()}".split(' ')[0]),
            ],
          ),
        ),
      ],
    );
  }
}
