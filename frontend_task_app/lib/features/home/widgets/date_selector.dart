import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_task_app/core/utils.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onTap;
  const DateSelector(
      {super.key, required this.selectedDate, required this.onTap});

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  int weekOffset = 0;

  @override
  Widget build(BuildContext context) {
    final weekDays = generateWeekDays(weekOffset);
    String monthName = DateFormat('MMMM').format(weekDays.first);
    return Column(
      children: [
        // change date
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  weekOffset--;
                });
              },
              icon: const Icon(CupertinoIcons.back),
            ),
            Text(
              monthName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  weekOffset++;
                });
              },
              icon: const Icon(CupertinoIcons.forward),
            )
          ],
        ),
        // select dates
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SizedBox(
            height: 80,
            width: double.infinity,
            child: ListView.builder(
              itemCount: weekDays.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final date = weekDays[index];
                bool isSelected = DateFormat('d').format(widget.selectedDate) ==
                        DateFormat('d').format(date) &&
                    widget.selectedDate.month == date.month &&
                    widget.selectedDate.year == date.year;
                return GestureDetector(
                  onTap: () => widget.onTap(date),
                  child: Container(
                    width: 70,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                        color: isSelected ? Colors.orange : null,
                        border: Border.all(
                            color: isSelected
                                ? Colors.orange
                                : Colors.grey.shade300,
                            width: 2),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('d').format(date),
                          style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          DateFormat('E').format(date),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
