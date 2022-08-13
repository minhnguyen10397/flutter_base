import 'package:flutter/material.dart';
import 'package:gold/common/colors.dart';
import 'package:gold/common/styles.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    Key? key,
    required this.message,
    this.title,
    this.positiveTitle = 'OK',
    this.positiveCallback,
    this.negativeTitle,
    this.negativeCallback,
  }) : super(key: key);

  final String message;
  final String? title;
  final String positiveTitle;
  final String? negativeTitle;
  final VoidCallback? positiveCallback;
  final VoidCallback? negativeCallback;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: Text(
                    title!,
                    style: UITextStyle.bold.copyWith(
                      fontSize: 20,
                      color: UIColors.black,
                    ),
                  ),
                ),
              Text(
                message,
                style: UITextStyle.regular.copyWith(
                  fontSize: 15,
                  color: UIColors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const Divider(height: 1,),
        Row(
          children: [
            if (negativeTitle != null && negativeCallback != null)
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.of(context).pop();
                    negativeCallback?.call();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      negativeTitle!,
                      style: UITextStyle.regular.copyWith(
                        fontSize: 18,
                        color: UIColors.black,
                      ),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.of(context).pop();
                  positiveCallback?.call();
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    positiveTitle,
                    style: UITextStyle.semiBold.copyWith(
                      fontSize: 18,
                      color: UIColors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
