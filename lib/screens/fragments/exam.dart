import 'package:flutter/material.dart';
import 'package:gradify/config/values/sizes.dart';
import 'package:gradify/views/widgets/exam_card.dart';
import 'package:gradify/views/widgets/searchbar.dart';

class ExamFragment extends StatelessWidget {
  const ExamFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.all(AppSizes.mediumPadding),
        child: Column(
          children: [SearchBarWidget(), ExamCardWidget()],
        ));
  }
}
