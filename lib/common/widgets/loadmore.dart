import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../colors.dart';

class LoadMoreWidget extends StatelessWidget {
  final Widget child;
  final RefreshController refreshController;
  final Function() onRefresh;
  final Function()? onLoadMore;
  final bool enablePullDown;
  final bool enablePullUp;
  final bool showBottomLoading;

  const LoadMoreWidget({
    Key? key,
    required this.child,
    required this.refreshController,
    required this.onRefresh,
    this.onLoadMore,
    this.enablePullDown = true,
    this.enablePullUp = true,
    this.showBottomLoading = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: enablePullDown,
      enablePullUp: enablePullUp,
      controller: refreshController,
      onRefresh: onRefresh,
      onLoading: onLoadMore,
      header: const MaterialClassicHeader(
        color: UIColors.primary,
      ),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          if (mode == LoadStatus.loading && showBottomLoading) {
            Widget body = const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(UIColors.primary),
              ),
            );
            return SizedBox(
              height: 32,
              child: Center(
                child: body,
              ),
            );
          }
          return const SizedBox();
        },
      ),
      child: child,
    );
  }
}
