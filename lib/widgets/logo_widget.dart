import 'package:flutter/material.dart';
import '../theme/colors.dart';

class LogoWidget extends StatelessWidget {
  final double size;
  final bool showText;
  final TextStyle? textStyle;

  const LogoWidget({
    super.key,
    this.size = 40,
    this.showText = true,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.25),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/icon.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.black,
                alignment: Alignment.center,
                child: Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: size * 0.6,
                ),
              );
            },
          ),
        ),
        if (showText) ...[
          const SizedBox(width: 10),
          Text(
            'growthBox',
            style: textStyle ??
                TextStyle(
                  fontSize: size * 0.55,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
          ),
        ],
      ],
    );
  }
}
