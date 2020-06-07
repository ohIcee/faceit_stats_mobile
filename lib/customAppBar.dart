import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final bool backButton;

  const CustomAppBar({Key key, @required this.backButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(255, 85, 0, 1),
      alignment: Alignment.center,
      height: 50.0,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Center(
            child: Text(
              "FACEIT STATS",
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          backButton
              ? Positioned(
                  left: 20,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
