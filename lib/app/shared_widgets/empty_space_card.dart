import 'package:flutter/material.dart';

class EmptySpaceCard extends StatelessWidget {
  const EmptySpaceCard({Key? key, this.size, this.child}) : super(key: key);

  final double? size;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black54),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: size,
          child: child ?? Center(child: Text("coming soon")),
        ),
      ),
    );
  }
}
