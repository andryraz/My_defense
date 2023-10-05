import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/texts/text_with_icon.dart';
import '../../../models/session_model.dart';
import '../../../models/user_model.dart';
import '../../../providers/user_provider.dart';
import '../../../utils/dates.dart';

class EventItem extends StatelessWidget {
  final SessionModel event;
  final VoidCallback onDelete;

  EventItem({
    required this.event,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAvailable = event.title == null || event.title!.isEmpty;
    final Color bgColor = isAvailable ? Colors.green : Colors.red;

    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    UserModel? user = userProvider.user ?? null;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title?.isEmpty ?? true ? 'Disponible' : 'Réservé',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isAvailable ? Colors.green : Colors.red,
                  ),
                ),
                SizedBox(height: 5),
                TextWithIcon(
                  icon: Icons.access_time,
                  text: DateUtil.parseTimeOnly(date: event.time),
                ),
                SizedBox(height: 4),
                TextWithIcon(
                  icon: Icons.date_range,
                  text: DateUtil.dateOnly(date: event.date),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '${event.duration}h',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Visibility(
                    visible: user != null && user.role == 'admin' ?? false,
                    child: IconButton(
                      onPressed: onDelete,
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
