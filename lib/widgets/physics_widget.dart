import 'package:flutter/material.dart';

class PhysicsWidget extends StatefulWidget {
  const PhysicsWidget({super.key});

  @override
  State<PhysicsWidget> createState() => _PhysicsWidgetState();
}

class _PhysicsWidgetState extends State<PhysicsWidget> {
  Color caughtColor = Colors.grey;

  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
  ];

  late Map<Color, bool> matched;

  @override
  void initState() {
    super.initState();
    matched = {for (var c in colors) c: false};
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: colors
              .map(
                (color) => Draggable<Color>(
                  data: color,
                  feedback: _buildBall(color: color),
                  childWhenDragging: _buildBall(
                    color: color.withValues(alpha: 0.7),
                  ),
                  child: _buildBall(color: color),
                ),
              )
              .toList(),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: colors
              .map(
                (color) => DragTarget<Color>(
                  onWillAcceptWithDetails: (color) => true,
                  onAcceptWithDetails: (details) {
                    if (details.data == color) {
                      matched[color] = true;
                    } else {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text("Wrong!")));
                    }
                  },
                  builder: (context, candidateData, rejectedData) {
                    final isMatched = matched[color] ?? false;
                    return _buildSquare(
                      color: isMatched ? color : color.withValues(alpha: 0.5),
                    );
                  },
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildBall({required Color color}) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      width: MediaQuery.of(context).size.width / 8,
      height: 70,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildSquare({required Color color}) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      width: MediaQuery.of(context).size.width / 7,
      height: 70,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.rectangle,
        border: Border.all(color: color, width: 3),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
    );
  }
}
