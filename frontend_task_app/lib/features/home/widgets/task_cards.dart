import 'package:flutter/widgets.dart';
import 'package:frontend_task_app/core/utils.dart';
import 'package:intl/intl.dart';

class TaskCards extends StatelessWidget {
  final Color color;
  final String titleText;
  final String descriptionText;
  final DateTime dueAt;
  const TaskCards(
      {super.key,
      required this.color,
      required this.titleText,
      required this.descriptionText,
      required this.dueAt});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  descriptionText,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: strenghtenColor(color, 0.6),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                DateFormat.jm().format(dueAt),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            )
          ],
        )
      ],
    );
  }
}
