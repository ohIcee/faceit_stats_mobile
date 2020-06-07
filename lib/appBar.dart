import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  final Widget leading;
  final List<Widget> widgets;

  const MainAppBar({Key key, this.appBar, this.widgets, this.leading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromRGBO(255, 85, 0, 1),
      centerTitle: true,
      leading: leading,
      title: Text(
        "FACEIT STATS",
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
