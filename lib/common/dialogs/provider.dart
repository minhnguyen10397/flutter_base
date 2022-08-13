import 'package:gold/common/colors.dart';
import 'package:gold/common/dialogs/dialog_view/confirm_dialog.dart';
import 'package:flutter/material.dart';

class DialogProvider {
  DialogProvider._();
  static final DialogProvider instance = DialogProvider._();

  Widget _mainDialog({Widget? child}) {
    return Dialog(
      insetPadding: const EdgeInsets.all(15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  showConfirmDialog(
    BuildContext context, {
    required String message,
    String? title,
    String positiveTitle = 'OK',
    String? negativeTitle,
    VoidCallback? positiveCallback,
    VoidCallback? negativeCallback,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return _mainDialog(
          child: ConfirmDialog(
            message: message,
            title: title,
            positiveTitle: positiveTitle,
            positiveCallback: positiveCallback,
            negativeTitle: negativeTitle,
            negativeCallback: negativeCallback,
          ),
        );
      },
    );
  }
}
