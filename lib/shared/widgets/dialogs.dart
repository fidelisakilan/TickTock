import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';

Future<dynamic> showCustomDialog(context, Widget widget) => showDialog(
    context: context, useSafeArea: true, builder: (context) => widget);

Future<dynamic> showCustomBottomSheet(context, Widget widget) =>
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => widget,
    );

void showCustomToast(
  BuildContext context,
  String message, {
  Widget? actionButton,
}) {
  DelightToastBar(
    position: DelightSnackbarPosition.top,
    builder: (context) => ToastCard(
      leading: const Icon(
        Icons.flutter_dash,
        size: 28,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          if (actionButton != null) actionButton,
        ],
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: GestureDetector(
          onTap: () {
            DelightToastBar.removeAll();
          },
          child: const Icon(Icons.clear_all_outlined),
        ),
      ),
    ),
  ).show(context);
}
