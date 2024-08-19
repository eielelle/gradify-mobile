import 'package:flutter/material.dart';
import 'package:gradify/config/values/sizes.dart';
import 'package:gradify/views/widgets/searchbar.dart';
import 'package:iconsax/iconsax.dart';

class StudentFragment extends StatelessWidget {
  const StudentFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSizes.mediumPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Your Students",
            style: TextStyle(
                fontSize: AppSizes.largeFontSize, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: AppSizes.smallMargin,
          ),
          SearchBar(
            leading: Icon(Iconsax.search_normal),
            hintText: "Search Student",
            trailing: [
              IconButton(onPressed: () {}, icon: Icon(Iconsax.close_circle))
            ],
          ),
          const SizedBox(
            height: AppSizes.mediumMargin,
          ),
          const Card(
              child: Column(
            children: [
              ListTile(
                title: Text("John Doe"),
                subtitle: Text("johndoe@gmail.com"),
              ),
              Padding(
                padding: EdgeInsets.all(AppSizes.mediumPadding),
                child: Row(
                  children: [
                    Row(
                      children: [Icon(Iconsax.people), Text("12")],
                    ),
                    SizedBox(
                      width: AppSizes.mediumMargin,
                    ),
                    Row(
                      children: [Icon(Iconsax.document), Text("12")],
                    )
                  ],
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
