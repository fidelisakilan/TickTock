import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:tick_tock/app/config.dart';

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
    autoDismiss: true,
    snackbarDuration: const Duration(milliseconds: 1500),
    position: DelightSnackbarPosition.top,
    builder: (context) => ToastCard(
      color: context.colorScheme.onPrimary,
      leading: const Icon(
        Icons.flutter_dash,
        size: 28,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: context.colorScheme.primary,
                fontSize: 14,
              ),
            ),
          ),
          if (actionButton != null) actionButton,
        ],
      ),
    ),
  ).show(context);
}
