import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class CustomAppBarWidget extends StatelessWidget {
  const CustomAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromRGBO(101, 188, 80, 1),
      leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Image.asset('assets/images/logo.png', width: 32, height: 32)),
      actions: [
        Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
                onPressed: () {},
                child: const Icon(Iconsax.logout,
                    color: Color.fromRGBO(101, 188, 80, 1))))
      ],
    );
  }
}
