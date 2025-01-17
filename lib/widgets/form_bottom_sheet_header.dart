import 'package:flutter/material.dart';

class FormBottomSheetHeader extends StatelessWidget {
  const FormBottomSheetHeader({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 15,
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Container(
          height: 4,
          width: MediaQuery.of(context).size.width * 0.1,
          decoration: BoxDecoration(
            color: Colors.grey[500],
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}
