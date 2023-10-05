import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TimePicker extends StatefulWidget {
  final bool? enabled;
  final DateTime selectedTime;
  final Function(DateTime) updateSelectedTime;

  TimePicker(
      {this.enabled = true,
      required this.selectedTime,
      required this.updateSelectedTime});

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  TimeOfDay currentTime = TimeOfDay.now();

  @override
  void initState() {
    currentTime = TimeOfDay.fromDateTime(widget.selectedTime);
    super.initState();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );

    if (picked != null) {
      final selectedTime = DateTime(
        widget.selectedTime.year,
        widget.selectedTime.month,
        widget.selectedTime.day,
        picked.hour,
        picked.minute,
      );
      setState(() {
        currentTime = picked;
      });
      widget.updateSelectedTime(selectedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Heure de soutenance',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () => widget.enabled ?? true ? _selectTime(context) : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Heure choisi:'),
              Text(
                "${currentTime.hour}:${currentTime.minute.toString().padLeft(2, '0')}",
              ),
            ],
          ),
        ),
      ],
    );
  }
}
