import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:scannerv3/models/school_exam.dart';

class ExamsFragment extends StatefulWidget {
  const ExamsFragment({super.key});

  @override
  State<ExamsFragment> createState() => _ExamsFragmentState();
}

class _ExamsFragmentState extends State<ExamsFragment> {
  final List<SchoolExam> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      list.add(SchoolExam("QUIZ 1", 12, 7));
      list.add(SchoolExam("PRELIM EXAM 2", 2, 12));
      list.add(SchoolExam("02 Act 01", 16, 3));
      list.add(SchoolExam("Quiz 1", 19, 9));
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

  Widget _buildCard(SchoolExam sc) {
    return Card(
      child: ListTile(
        title: Text(sc.name),
        subtitle: Row(
          children: [
            Row(children: [Text("Classes: "), Text(sc.classes.toString())]),
            SizedBox(width: 12),
            Row(children: [Icon(Iconsax.book), Text(sc.subjects.toString())])
          ],
        ),
      ),
    );
  }
}
