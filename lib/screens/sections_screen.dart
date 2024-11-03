import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scannerv3/models/school_year.dart';
import 'package:scannerv3/models/section.dart';
import 'package:scannerv3/screens/student_screen.dart';

class SectionsScreen extends StatefulWidget {
  const SectionsScreen({super.key});

  @override
  State<SectionsScreen> createState() => _SectionsScreenState();
}

class _SectionsScreenState extends State<SectionsScreen> {
  final List<Section> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchSection();
  }

  void fetchSection() {
    setState(() {
      list.add(Section("Narra"));
      list.add(Section("Acacia"));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Select Section")),
        body: Expanded(
            child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return _buildCard(list[index]);
                })));
  }

  Widget _buildCard(Section section) {
    return Card(
        child: ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => StudentScreen()));
            },
            title: Text(section.name)));
  }
}
