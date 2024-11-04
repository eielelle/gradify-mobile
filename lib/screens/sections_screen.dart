import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scannerv3/models/school_year.dart';
import 'package:scannerv3/models/section.dart';
import 'package:scannerv3/screens/student_screen.dart';
import 'package:scannerv3/utils/token_manager.dart';
import 'package:scannerv3/values/api_endpoints.dart';

class SectionsScreen extends StatefulWidget {
  final int classId;
  final int syId;

  const SectionsScreen({super.key, required this.classId, required this.syId});

  @override
  State<SectionsScreen> createState() => _SectionsScreenState();
}

class _SectionsScreenState extends State<SectionsScreen> {
  Future<List<Section>> fetchSection() async {
    final List<Section> list = [];
    final dio = Dio();
    final token = await TokenManager().getAuthToken();
    final res = await dio.get(ApiEndpoints.sections,
        data: {"class_id": widget.classId, "sy_id": widget.syId},
        options: Options(headers: {'Authorization': token}));

    if (res.statusCode == 200) {
      final sections = res.data["sections"] ?? [];

      for (var section in sections) {
        final attr = section["attributes"];
        final sc = Section(attr["name"], attr["id"]);

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
            title: const Text("Select Section"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: Container(
          padding: EdgeInsets.all(12),
          child: Expanded(
              child: FutureBuilder<List<Section>>(
                  future: fetchSection(),
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

  Widget _buildCard(Section section) {
    return Card(
        child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          StudentScreen(sectionId: section.id)));
            },
            title: Text(section.name)));
  }
}
