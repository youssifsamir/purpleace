// packages
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'sessions.dart';
import '/models/user.dart';

class FirebaseAuthService {
  // ✅ CORRECT BASE URL
  final String baseUrl =
      'https://us-central1-purpleace.cloudfunctions.net/api/auth';

  // ✅ FORMAT PHONE TO E.164
  String formatPhone(String phone) {
    if (phone.startsWith('+')) return phone;
    return '+20${phone.replaceFirst(RegExp(r'^0'), '')}';
  }

  // ========================= SIGNUP =========================
  Future<UserModel> signup({
    required String username,
    required String email,
    required String password,
    required String gender,
    required String religon,
    required String dob,
    required String firstName,
    required String lastName,
    required String additionalMobileNumber,
    required String mobileNumber,
    required String nationalID,

    required String employeeID,
    required String employeePosition,
    required String department,
    required String branch,
    required String location,
    required String shiftType,
    required String schedule,
    required String urgentVacation,
    required String unpaidVacationBalance,
    required String normalVacation,
    required String vacationStartDate,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'mobileNumber': formatPhone(mobileNumber), // ✅ SAFE FORMAT
        'additionalMobileNumber': additionalMobileNumber,
        'DOB': dob, // ✅ MATCHES BACKEND
        'nationalID': nationalID,
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender,
        'religon': religon,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Signup failedsss: ${response.body}');
    }

    final data = jsonDecode(response.body);

    // ✅ CORRECT NESTED PARSING
    final user = UserModel(
      uid: data['uid'],
      username: data['username'],
      personalInfo: PersonalInfo.fromMap(data['personalInfo']),
      workInfo: WorkInfo.fromMap(data['workInfo']),
      contactInfo: ContactInfo.fromMap(data['contactInfo']),
      userAccount: UserAccount.fromMap(data['userAccount']),
      permissions: Permissions.fromMap(data['permissions']),
    );

    await SessionManager.saveUser(user);
    return user;
  }
}
