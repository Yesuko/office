import 'package:flutter/material.dart';

class Metrics extends StatelessWidget {
  const Metrics({
    Key? key,
    required this.color,
    required this.widthFactor,
    required this.number,
  }) : super(key: key);
  final Color color;
  final double widthFactor;
  final int number;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Row(
      children: [
        Container(
          height: 15,
          width: size.width * 0.85,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey[50],
          ),
          child: FractionallySizedBox(
            widthFactor: widthFactor,
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: color,
              ),
            ),
          ),
        ),
        SizedBox(
          width: size.width * 0.03,
        ),
        Text(number.toString())
      ],
    );
  }
}
