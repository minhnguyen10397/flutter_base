import 'package:flutter/material.dart';
import 'package:gold/common/colors.dart';
import 'package:gold/common/widgets/buttons.dart';

class CustomDropdown<T> extends StatefulWidget {
  final Widget child;
  final void Function(T?, int)? onChange;
  final List<DropdownItem<T>> items;
  final int currentIndex;
  final DropdownStyle dropdownStyle;

  /// dropdownButtonStyles passes styles to OutlineButton.styleFrom()
  final DropdownButtonStyle dropdownButtonStyle;

  /// dropdown button icon defaults to caret
  final Widget? icon;
  final bool hideIcon;

  /// if true the dropdown icon will as a leading icon, default to false
  final bool leadingIcon;

  const CustomDropdown({
    Key? key,
    this.hideIcon = false,
    required this.child,
    required this.items,
    required this.currentIndex,
    this.dropdownStyle = const DropdownStyle(),
    this.dropdownButtonStyle = const DropdownButtonStyle(),
    this.icon,
    this.leadingIcon = false,
    this.onChange,
  }) : super(key: key);

  @override
  _CustomDropdownState<T> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>>
    with TickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  late OverlayEntry _overlayEntry;
  bool _isOpen = false;

  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _rotateAnimation = Tween(begin: 0.0, end: 0.5).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linearToEaseOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    var style = widget.dropdownButtonStyle;
    // link the overlay to the button
    return CompositedTransformTarget(
      link: _layerLink,
      child: SplashButton(
        borderRadius: BorderRadius.circular(style.radius),
        onTap: () {
          if (WidgetsBinding.instance.window.viewInsets.bottom != 0) {
            FocusManager.instance.primaryFocus?.unfocus();
          } else {
            _toggleDropdown();
          }
        },
        child: Container(
          padding: style.padding,
          width: style.width,
          height: style.height,
          decoration: BoxDecoration(
            color: style.backgroundColor,
            borderRadius: BorderRadius.circular(style.radius),
          ),
          child: Row(
            children: [
              const SizedBox(width: 12,),
              if (widget.currentIndex == -1) ...[
                widget.child,
              ] else ...[
                widget.items[widget.currentIndex],
              ],
              const Spacer(),
              if (!widget.hideIcon)
                RotationTransition(
                  turns: _rotateAnimation,
                  child: widget.icon ??
                      const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: Colors.white,
                      ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    final screenSize = MediaQuery.of(context).size;
    // find the size and position of the current widget
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    var size = renderBox?.size;

    var offset = renderBox?.localToGlobal(Offset.zero);
    var topOffset = offset!.dy + size!.height + 5;

    bool showUnder = true;
    if (topOffset > screenSize.height / 1.5) {
      showUnder = false;
    }

    final marginOffset = showUnder ? size.height + 5 : -size.height - 5;
    final anchor = showUnder ? Alignment.topCenter : Alignment.bottomCenter;
    final maxHeight =
        showUnder ? screenSize.height - topOffset - 5 : screenSize.height / 2;

    return OverlayEntry(
      // full screen GestureDetector to register when a
      // user has clicked away from the dropdown
      builder: (context) => GestureDetector(
        onTap: () => _toggleDropdown(close: true),
        behavior: HitTestBehavior.translucent,
        // full screen container to register taps anywhere and close drop down
        child: WillPopScope(
          onWillPop: () async {
            if (_isOpen) {
              _toggleDropdown(close: true);
              return false;
            }
            return true;
          },
          child: SizedBox(
            height: screenSize.height,
            width: screenSize.width,
            child: Stack(
              children: [
                if (widget.items.isNotEmpty)
                  Positioned(
                    left: offset.dx,
                    top: topOffset,
                    width: widget.dropdownStyle.width ?? size.width,
                    child: CompositedTransformFollower(
                      offset: Offset(0, marginOffset),
                      link: _layerLink,
                      targetAnchor: anchor,
                      followerAnchor: anchor,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: widget.dropdownStyle.borderRadius ??
                              BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: showUnder ? const Offset(0, 1.0) : const Offset(0, -1.0),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                        child: Material(
                          borderRadius: widget.dropdownStyle.borderRadius ??
                              BorderRadius.circular(6),
                          color: widget.dropdownStyle.color,
                          child: SizeTransition(
                            axisAlignment: 1,
                            sizeFactor: _expandAnimation,
                            axis: Axis.vertical,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: maxHeight,
                              ),
                              child: ListView(
                                padding: widget.dropdownStyle.padding,
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                children: widget.items.asMap().entries.map(
                                      (item) {
                                    return InkWell(
                                      onTap: () {
                                        widget.onChange?.call(
                                          item.value.value,
                                          item.key,
                                        );
                                        _toggleDropdown();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        alignment: Alignment.center,
                                        child: item.value,
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleDropdown({bool close = false}) async {
    if (_isOpen || close) {
      await _animationController.reverse();
      _overlayEntry.remove();
      setState(() {
        _isOpen = false;
      });
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context)?.insert(_overlayEntry);
      setState(() => _isOpen = true);
      _animationController.forward();
    }
  }
}

/// DropdownItem is just a wrapper for each child in the dropdown list.\n
/// It holds the value of the item.
class DropdownItem<T> extends StatelessWidget {
  final T? value;
  final Widget child;

  const DropdownItem({Key? key, this.value, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class DropdownButtonStyle {
  final double radius;
  final double? elevation;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final Color? primaryColor;

  const DropdownButtonStyle({
    this.backgroundColor = UIColors.itemBackground,
    this.primaryColor,
    this.height,
    this.width,
    this.elevation,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
    this.radius = 6,
  });
}

class DropdownStyle {
  final BorderRadius? borderRadius;
  final Color? color;
  final EdgeInsets? padding;

  ///button width must be set for this to take effect
  final double? width;

  //TODO set default depend on project
  const DropdownStyle({
    this.width,
    this.color = UIColors.itemBackground,
    this.padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 20),
    this.borderRadius,
  });
}
