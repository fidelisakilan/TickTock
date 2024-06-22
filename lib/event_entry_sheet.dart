import 'package:flutter/material.dart';

class EventEntrySheet extends StatefulWidget {
  const EventEntrySheet({super.key});

  @override
  State<EventEntrySheet> createState() => _EventEntrySheetState();
}

class _EventEntrySheetState extends State<EventEntrySheet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
          ],
        )
      ],
    );
  }
}

Future<dynamic> showAppBottomSheet(BuildContext context, Widget child) async =>
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: child,
      ),
    );
