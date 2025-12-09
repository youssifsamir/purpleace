// packages
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class BiometricAttendanceButton extends StatefulWidget {
  const BiometricAttendanceButton({super.key});

  @override
  State<BiometricAttendanceButton> createState() =>
      _BiometricAttendanceButtonState();
}

class _BiometricAttendanceButtonState extends State<BiometricAttendanceButton> {
  final LocalAuthentication auth = LocalAuthentication();
  bool isLoading = false;

  // ✅ TARGET LOCATION (CHANGE THIS)
  final double targetLat = 30.0444; // Example: Cairo
  final double targetLng = 31.2357;
  final double allowedRadiusInMeters = 100; // 100 meters only

  Future<void> markAttendance() async {
    setState(() => isLoading = true);

    try {
      // ✅ 1. Request Location Permission
      if (!await Permission.locationWhenInUse.request().isGranted) {
        showError("Location permission required");
        return;
      }

      // ✅ 2. Get Current Position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // ✅ 3. Calculate Distance
      final distance = Geolocator.distanceBetween(
        targetLat,
        targetLng,
        position.latitude,
        position.longitude,
      );

      if (distance > allowedRadiusInMeters) {
        showError("You must be at the office to mark attendance");
        return;
      }

      // ✅ 4. Check for Biometrics
      final canCheck = await auth.canCheckBiometrics;

      if (!canCheck) {
        showError("Biometric authentication not available");
        return;
      }

      // ✅ 5. Authenticate
      final authenticated = await auth.authenticate(
        localizedReason: "Verify your identity for attendance",
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (!authenticated) {
        showError("Biometric verification failed");
        return;
      }

      // ✅ 6. SUCCESS → SAVE ATTENDANCE
      showSuccess("Attendance marked successfully ✅");

      // TODO: Send attendance to backend or Firebase here
    } catch (e) {
      showError("Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showError(String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  void showSuccess(String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.green));
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isLoading ? null : markAttendance,
      icon: const Icon(Icons.fingerprint),
      label:
          isLoading
              ? const CircularProgressIndicator(strokeWidth: 2)
              : const Text("Mark Attendance"),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
