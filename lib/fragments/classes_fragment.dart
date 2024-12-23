import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scannerv3/helpers/database_helper.dart';
import 'package:scannerv3/helpers/toast_helper.dart';
import 'package:scannerv3/models/school_class.dart';
import 'package:scannerv3/screens/school_year_screen.dart';
import 'package:scannerv3/utils/token_manager.dart';
import 'package:scannerv3/values/api_endpoints.dart';
import 'package:sqflite/sqflite.dart';

class ClassesFragment extends StatefulWidget {
  const ClassesFragment({super.key});

  @override
  State<ClassesFragment> createState() => _ClassesFragmentState();
}

class _ClassesFragmentState extends State<ClassesFragment> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<List<SchoolClass>> fetchClassesWithFallback() async {
    List<SchoolClass> classes = [];

    try {
      classes = await fetchClasses();
    } on DioException {
      ToastHelper.showToast("You are offline. Local data has been loaded.");
      return fetchClassesLocal();
    } catch (error) {
      ToastHelper.showToast("You are offline. Local data has been loaded.");
      return fetchClassesLocal();
    }

    return classes;
  }

  Future<List<SchoolClass>> fetchClassesLocal() async {
    try {
      final db = await DatabaseHelper().database;

      // Query the table for all the exams.
      final List<Map<String, dynamic>> maps = await db.query('classes');

      return List.generate(maps.length, (i) {
        return SchoolClass.fromMap(maps[i]);
      });
    } catch (error) {
      return Future.error("Database fallback failed.");
    }
  }

  Future<List<SchoolClass>> fetchClasses() async {
    final List<SchoolClass> list = [];
    final dio = Dio();
    final token = await TokenManager().getAuthToken();

    final res = await dio.get(ApiEndpoints.classes,
        options: Options(headers: {'Authorization': token}));

    if (res.statusCode == 200) {
      final classes = res.data["classes"] ?? [];
      final db = await DatabaseHelper().database;

      for (var schoolClass in classes) {
        final attr = schoolClass["attributes"];
        final sc = SchoolClass(
            name: attr["name"],
            description: attr["description"],
            id: attr["id"]);

        list.add(sc);
      }

      await db.transaction((txn) async {
        // Clear the table
        await txn.delete('classes'); // This will remove all rows
        // Insert new data
        for (var data in list) {
          await txn.insert('classes', data.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      });
    } else {
      return Future.error('Something went wrong');
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Your Classes",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Expanded(
            child: FutureBuilder<List<SchoolClass>>(
                future: fetchClassesWithFallback(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Center(
                          child: Text("Something went wrong.",
                              style: TextStyle(color: Colors.white)));
                    } else if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return Center(
                            child: Column(children: [
                          Image.asset('assets/images/empty.gif',
                              width: 300, height: 300),
                          const Text("No classes assigned yet.",
                              style: TextStyle(color: Colors.white))
                        ]));
                      }

                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return _buildCard(snapshot.data![index]);
                          });
                    }
                  }

                  return const Center(child: CircularProgressIndicator());
                }),
          )
        ],
      ),
    );
  }

  Widget _buildCard(SchoolClass sc) {
    return Card(
      child: ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SchoolYearScreen(
                          classId: sc.id,
                        )));
          },
          title: Text(
            sc.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Text(
              sc.description.isEmpty ? "No description yet" : sc.description)),
    );
  }
}
