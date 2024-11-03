import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scannerv3/models/school_year.dart';
import 'package:scannerv3/screens/sections_screen.dart';

class SchoolYearScreen extends StatefulWidget {
  const SchoolYearScreen({super.key});

  @override
  State<SchoolYearScreen> createState() => _SchoolYearScreenState();
}

class _SchoolYearScreenState extends State<SchoolYearScreen> {
  final List<SchoolYear> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchSY();
  }

  void fetchSY() {
    setState(() {
      list.add(SchoolYear("2023 - 2024", DateTime.parse("2024-09-29"),
          DateTime.parse("2024-10-26")));
      list.add(SchoolYear("SY 2025", DateTime.parse("2024-09-29"),
          DateTime.parse("2024-10-26")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Select School Year")),
        body: Expanded(
            child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return _buildCard(list[index]);
                })));
  }

  Widget _buildCard(SchoolYear sy) {
    return Card(
      child: ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SectionsScreen()));
          },
          title: Text(sy.name),
          subtitle: Text(
              "${DateFormat('MMMM d, y').format(sy.startDate)} - ${DateFormat('MMMM d, y').format(sy.endDate)}")),
    );
  }
}
