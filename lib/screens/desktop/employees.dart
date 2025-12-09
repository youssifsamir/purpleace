// ignore_for_file: deprecated_member_use

// packages
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

// models
import '/models/user.dart';

// providers

// widgets
import '/widgets/employees/datasearch.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({super.key});
  String toArabicDigits(String number) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    String str = number.toString();
    for (int i = 0; i < english.length; i++) {
      str = str.replaceAll(english[i], arabic[i]);
    }
    return str;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 3.w, top: 15.h, right: 3.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: SearchableDataTable<UserModel>(
              title: 'Employees Management',
              titleStyle: TextStyle(fontFamily: 'PoppinsMid', fontSize: 7.sp),
              data: [],
              columns: [
                DataColumnDefinition<UserModel>(
                  label: 'First Name',
                  cellBuilder: (e) => e.personalInfo.firstName,
                ),
                DataColumnDefinition<UserModel>(
                  label: 'Phone Number',
                  cellBuilder: (e) => e.personalInfo.firstName,
                ),
                DataColumnDefinition<UserModel>(
                  label: 'Address',
                  cellBuilder: (e) => e.personalInfo.firstName,
                ),
                DataColumnDefinition<UserModel>(
                  label: 'Balance',
                  cellBuilder: (e) => e.username,
                ),
                DataColumnDefinition<UserModel>(
                  label: 'Notes',
                  cellBuilder: (e) => e.username,
                ),
              ],
              elevation: 0,
              showBorders: false,
              // headerColor: colorScheme.primary.withOpacity(0.35),
              headerColor: Colors.blueGrey.withOpacity(0.3),
              searchBorderRadius: BorderRadius.all(Radius.circular(500.r)),
              searchBackgroundColor: Colors.white,
              searchWidth: 175.w,
              searchBorderColor: Colors.transparent,
              headerStyle: TextStyle(fontFamily: 'PoppinsMid', fontSize: 4.sp),
              cellStyle: TextStyle(fontFamily: 'PoppinsMid', fontSize: 4.sp),
              // borderColor: Colors.white,
              evenRowColor: Colors.white,
              oddRowColor: Colors.blueGrey.withOpacity(0.085),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }
}
