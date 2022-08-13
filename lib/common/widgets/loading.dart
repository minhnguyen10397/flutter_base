import 'package:flutter/material.dart';

import '../colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            color: Colors.transparent,
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(UIColors.primary),
              ),
            ),
          ),
        ),
        SizedBox.expand(
          child: Container(
            color: Colors.transparent,
          ),
        )
      ],
    );
  }
}
