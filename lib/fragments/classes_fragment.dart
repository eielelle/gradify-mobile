import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:scannerv3/models/school_class.dart';

class ClassesFragment extends StatefulWidget {
  const ClassesFragment({super.key});

  @override
  State<ClassesFragment> createState() => _ClassesFragmentState();
}

class _ClassesFragmentState extends State<ClassesFragment> {
  final List<SchoolClass> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      list.add(SchoolClass("ABM", "", 12, 7));
      list.add(SchoolClass("STEM", "", 2, 12));
      list.add(SchoolClass("ICT", "", 16, 3));
      list.add(SchoolClass("GAS", "", 19, 9));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                  child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintStyle:
                        TextStyle(color: Color.fromRGBO(187, 187, 187, 1)),
                    hintText: "Search",
                    fillColor: Color.fromRGBO(50, 57, 62, 1),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.green), // Border when enabled
                    ),
                    filled: true),
              ))
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
              child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return _buildCard(list[index]);
                  }))
        ],
      ),
    );
  }

  Widget _buildCard(SchoolClass sc) {
    return Card(
      child: ListTile(
        title: Text(sc.name),
        subtitle: Row(
          children: [
            Row(children: [Icon(Iconsax.people), Text(sc.students.toString())]),
            SizedBox(width: 12),
            Row(children: [Icon(Iconsax.book), Text(sc.subjects.toString())])
          ],
        ),
      ),
    );
  }
}
