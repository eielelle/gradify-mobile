import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scannerv3/helpers/database_helper.dart';
import 'package:scannerv3/helpers/toast_helper.dart';
import 'package:scannerv3/models/school_year.dart';
import 'package:scannerv3/screens/sections_screen.dart';
import 'package:scannerv3/utils/token_manager.dart';
import 'package:scannerv3/values/api_endpoints.dart';
import 'package:sqflite/sqflite.dart';

class SchoolYearScreen extends StatefulWidget {
  final int classId;

  const SchoolYearScreen({super.key, required this.classId});

  @override
  State<SchoolYearScreen> createState() => _SchoolYearScreenState();
}

class _SchoolYearScreenState extends State<SchoolYearScreen> {
  Future<List<SchoolYear>> fetchSYWithFallback() async {
    List<SchoolYear> years = [];

    try {
      years = await fetchSY();
    } on DioException {
      ToastHelper.showToast("You are offline. Local data has been loaded.");
      return fetchSYLocal();
    } catch (error) {
      ToastHelper.showToast("You are offline. Local data has been loaded.");
      return fetchSYLocal();
    }

    return years;
  }

  Future<List<SchoolYear>> fetchSYLocal() async {
    try {
      final db = await DatabaseHelper().database;

      // Query the table for all the exams.
      final List<Map<String, dynamic>> maps = await db.query('sy');

      return List.generate(maps.length, (i) {
        return SchoolYear.fromMap(maps[i]);
      });
    } catch (error) {
      return Future.error("Database fallback failed.");
    }
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
      final db = await DatabaseHelper().database;

      for (var year in years) {
        final attr = year["attributes"];
        final sc = SchoolYear(
            name: attr["name"],
            startDate: attr["start"],
            endDate: attr["end"],
            id: attr["id"]);

        list.add(sc);
      }

      await db.transaction((txn) async {
        // Clear the table
        await txn.delete('sy'); // This will remove all rows
        // Insert new data
        for (var data in list) {
          await txn.insert('sy', data.toMap(),
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
            title: const Text("Select School Year"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: Container(
          padding: EdgeInsets.all(12),
          child: FutureBuilder<List<SchoolYear>>(
              future: fetchSYWithFallback(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
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
                    const Text("No school year assigned.",
                        style: TextStyle(color: Colors.white))
                  ]));
                }

                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return _buildCard(snapshot.data![index]);
                    });
              }),
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
              "${DateFormat('MMMM d, y').format(DateTime.parse(sy.startDate))} - ${DateFormat('MMMM d, y').format(DateTime.parse(sy.endDate))}")),
    );
  }
}
