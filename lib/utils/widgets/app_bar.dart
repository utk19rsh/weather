import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather/utils/constants.dart';

class ZeroAppBar extends StatelessWidget implements PreferredSizeWidget {
  final SystemUiOverlayStyle? systemOverlayStyle;
  const ZeroAppBar({super.key, this.systemOverlayStyle});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 0,
      elevation: 0,
      automaticallyImplyLeading: false,
      systemOverlayStyle: systemOverlayStyle ??
          const SystemUiOverlayStyle(
            statusBarColor: theme,
            statusBarIconBrightness: Brightness.light,
          ),
    );
  }

  @override
  Size get preferredSize => Size.zero;
}
