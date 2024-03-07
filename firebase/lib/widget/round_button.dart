import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({
    super.key,
    this.buttonColor = Colors.indigo,
    this.textColor = Colors.white,
    required this.title,
    required this.onPress,
    this.widgth = 200,
    this.hight = 50,
    this.loading = false,
  });

  final bool loading;
  final String title;
  final double hight, widgth;
  final VoidCallback onPress;
  final Color textColor, buttonColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        height: hight,
        width: widgth,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: loading
            ? Center(child: CircularProgressIndicator())
            : Center(child: Text(title)),
      ),
    );
  }
}
