import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scannerv3/helpers/database_helper.dart';
import 'package:scannerv3/helpers/toast_helper.dart';
import 'package:scannerv3/models/section.dart';
import 'package:scannerv3/screens/student_screen.dart';
import 'package:scannerv3/utils/token_manager.dart';
import 'package:scannerv3/values/api_endpoints.dart';
import 'package:sqflite/sqflite.dart';

class SectionsScreen extends StatefulWidget {
  final int classId;
  final int syId;

  const SectionsScreen({super.key, required this.classId, required this.syId});

  @override
  State<SectionsScreen> createState() => _SectionsScreenState();
}

class _SectionsScreenState extends State<SectionsScreen> {
  Future<List<Section>> fetchSectionLocal() async {
    try {
      final db = await DatabaseHelper().database;

      // Query the table for all the exams.
      final List<Map<String, dynamic>> maps = await db.query('sections');

      return List.generate(maps.length, (i) {
        return Section.fromMap(maps[i]);
      });
    } catch (error) {
      return Future.error("Database fallback failed.");
    }
  }

  Future<List<Section>> fetchSectionsWithFallback() async {
    List<Section> sections = [];

    try {
      sections = await fetchSection();
    } on DioException {
      ToastHelper.showToast("You are offline. Local data has been loaded.");
      return fetchSectionLocal();
    } catch (error) {
      ToastHelper.showToast("You are offline. Local data has been loaded.");
      return fetchSectionLocal();
    }

    return sections;
  }

  Future<List<Section>> fetchSection() async {
    final List<Section> list = [];
    final dio = Dio();
    final db = await DatabaseHelper().database;
    final token = await TokenManager().getAuthToken();
    final res = await dio.get(ApiEndpoints.sections,
        data: {"class_id": widget.classId, "sy_id": widget.syId},
        options: Options(headers: {'Authorization': token}));

    if (res.statusCode == 200) {
      final sections = res.data["sections"] ?? [];

      for (var section in sections) {
        final attr = section["attributes"];
        final sc = Section(name: attr["name"], id: attr["id"]);

        list.add(sc);
      }

      await db.transaction((txn) async {
        // Clear the table
        await txn.delete('sections'); // This will remove all rows
        // Insert new data
        for (var data in list) {
          await txn.insert('sections', data.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      });
    } else {
      return Future.error("Something went wrong");
    }

    return list;
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
                  future: fetchSectionsWithFallback(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(
                          child: Text("Something went wrong.",
                              style: TextStyle(color: Colors.white)));
                    }

                      if (snapshot.data!.isEmpty) {
                        return Center(
                            child: Column(children: [
                          Image.asset('assets/images/empty.gif',
                              width: 300, height: 300),
                          const Text("No sections assigned yet.",
                              style: TextStyle(color: Colors.white))
                        ]));
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
            title: Text(section.name,
                style: const TextStyle(fontWeight: FontWeight.bold))));
  }
}
