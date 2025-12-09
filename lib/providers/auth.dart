// ignore_for_file: avoid_print

// packages
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

// models
import '/models/user.dart';

// services
import '/services/auth.dart';

class AuthProvider extends ChangeNotifier {
  String? errorMessage;
  UserModel? currentUser;

  bool isLoading = false;
  bool isLoading2 = false;
  bool allFilled = false;

  String username = '';
  String password = '';

  void setUsername(String value) {
    username = value;
    checkFilled();
  }

  void setPassword(String value) {
    password = value;
    checkFilled();
  }

  void resetFilled() {
    allFilled = false;
    notifyListeners();
  }

  void checkFilled() {
    allFilled = username.isNotEmpty && password.isNotEmpty;
    notifyListeners();
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  final FirebaseAuthService _authService = FirebaseAuthService();

  Future<String?> getEmailByUsername(String username) async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('username', isEqualTo: username)
              .limit(1)
              .get();

      if (querySnapshot.docs.isEmpty) return null;

      final userDoc = querySnapshot.docs.first.data();
      return userDoc['email'];
    } catch (e) {
      print('Error fetching email: $e');
      return null;
    }
  }

  // ========================= LOGIN =========================
  Future<bool> login() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // 1️⃣ Get email from username
      final email = await getEmailByUsername(username);

      if (email == null) {
        throw "User not found";
      }

      // 2️⃣ Firebase Email/Password Sign In
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final uid = credential.user!.uid;

      // 3️⃣ Fetch Firestore User Data
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        throw "User data not found";
      }

      currentUser = UserModel.fromMap(userDoc.data()!);

      // 4️⃣ Save Session Locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', uid);
      await prefs.setString('email', email);

      isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      print(errorMessage);
      isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ========================= SIGNUP =========================
  Future<bool> signup({
    required String username,
    required String email,
    required String password,
    required String gender,
    required String mobileNumber,
    required String additionalMobileNumber,
    required String dob,
    required String religon,
    required String firstName,
    required String lastName,
    required String nationalID,

    required String employeeID,
    required String employeePosition,
    required String department,
    required String branch,
    required String location,
    required String shiftType,
    required String schedule,
    required String vacationStartDate,
    required String normalVacation,
    required String urgentVacation,
    required String unpaidVacationBalance,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.signup(
        username: username,
        email: email,
        password: password,
        mobileNumber: mobileNumber,
        additionalMobileNumber: additionalMobileNumber,
        firstName: firstName,
        lastName: lastName,
        nationalID: nationalID,
        dob: dob,
        gender: gender,
        religon: religon,

        employeeID: employeeID,
        employeePosition: employeePosition,
        department: department,
        location: location,
        branch: branch,
        shiftType: shiftType,
        schedule: schedule,
        vacationStartDate: vacationStartDate,
        normalVacation: normalVacation,
        urgentVacation: urgentVacation,
        unpaidVacationBalance: unpaidVacationBalance,
      );

      currentUser = user;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', user.uid);
      await prefs.setString('email', user.userAccount.email);

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ========================= LOGOUT =========================
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('uid');
    await prefs.remove('email');
    currentUser = null;
    notifyListeners();
  }

  Future<bool> forgotPassword({required String email}) async {
    String? getEmail;
    isLoading2 = true;
    errorMessage = null;
    notifyListeners();

    try {
      if (!email.contains("@")) {
        getEmail = await getEmailByUsername(email);
        print(getEmail);
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: getEmail.toString(),
        );
      } else {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      }

      isLoading2 = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message ?? "Failed to send reset email";
      isLoading2 = false;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Something went wrong. Try again.";
      isLoading2 = false;
      notifyListeners();
      return false;
    }
  }
}
