import 'package:flutter/material.dart';
import 'package:gradify/config/themes/theme.dart';
import 'package:gradify/config/values/sizes.dart';
import 'package:iconsax/iconsax.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Expanded(child: TextField()),
        const SizedBox(width: AppSizes.mediumMargin),
        Container(
          height: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(AppColorsLight.accent)),
            child: const Icon(Iconsax.search_normal),
          ),
        )
      ],
    );
  }
}
