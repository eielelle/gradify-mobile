class ApiEndpoints {
  // static const String baseUrl = "http://10.0.2.2:3000/api/v1/";
  // static const String baseUrl = "http://localhost:3000/api/v1/";
  static const String baseUrl = "https://gradify.onrender.com/api/v1/";

  static const String signIn = "${baseUrl}teacher/sign_in";
  static const String getExams = "${baseUrl}teacher/exams";
  static const String responses = "${baseUrl}teacher/responses";
  static const String classes = "${baseUrl}teacher/classes";
  static const String sy = "${baseUrl}teacher/class/years";
  static const String sections = "${baseUrl}teacher/class/year/sections";
  static const String students = "${baseUrl}teacher/section/students";
  static const String syncResponse = "${baseUrl}teacher/responses/sync";
  static const String studentName = "${baseUrl}teacher/exams/student";
}
