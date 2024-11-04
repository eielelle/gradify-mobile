import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scannerv3/models/school_year.dart';
import 'package:scannerv3/screens/sections_screen.dart';
import 'package:scannerv3/utils/token_manager.dart';
import 'package:scannerv3/values/api_endpoints.dart';

class SchoolYearScreen extends StatefulWidget {
  final int classId;

  const SchoolYearScreen({super.key, required this.classId});

  @override
  State<SchoolYearScreen> createState() => _SchoolYearScreenState();
}

class _SchoolYearScreenState extends State<SchoolYearScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<List<SchoolYear>> fetchSY() async {
    final List<SchoolYear> list = [];
    final dio = Dio();
    final token = await TokenManager().getAuthToken();
    final res = await dio.get(ApiEndpoints.sy,
        data: {"class_id": widget.classId},
        options: Options(headers: {'Authorization': token}));

    if (res.statusCode == 200) {
      final years = res.data["years"] ?? [];

      for (var year in years) {
        final attr = year["attributes"];
        final sc = SchoolYear(attr["name"], DateTime.parse(attr["start"]),
            DateTime.parse(attr["end"]), attr["id"]);

        list.add(sc);
      }

      return list;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(41, 46, 50, 1),
        appBar: AppBar(
            backgroundColor: const Color.fromRGBO(101, 188, 80, 1),
            title: const Text("Select School Year"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: Container(
          padding: EdgeInsets.all(12),
          child: Expanded(
              child: FutureBuilder<List<SchoolYear>>(
                  future: fetchSY(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      // if error has seen
                      print(snapshot.error);
                    }

                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return _buildCard(snapshot.data![index]);
                        });
                  })),
        ));
  }

  Widget _buildCard(SchoolYear sy) {
    return Card(
      child: ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SectionsScreen(syId: sy.id, classId: widget.classId)));
          },
          title: Text(
            sy.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
              "${DateFormat('MMMM d, y').format(sy.startDate)} - ${DateFormat('MMMM d, y').format(sy.endDate)}")),
    );
  }
}
