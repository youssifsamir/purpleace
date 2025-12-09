// ignore_for_file: deprecated_member_use, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, unused_element

// packages
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:purpleace/widgets/employees/checkboxes.dart';
import 'package:purpleace/widgets/employees/uploadimage.dart';

// providers
import '/providers/auth.dart';

// widgets
import '/widgets/employees/button.dart';
import '/widgets/employees/clickabledata.dart';

/// Generic data column definition
class DataColumnDefinition<T> {
  final String label;
  final TextAlign? alignment;
  final dynamic Function(T item) cellBuilder;
  final int Function(T a, T b)? comparator; // optional custom comparator

  DataColumnDefinition({
    this.alignment,
    this.comparator,
    required this.label,
    required this.cellBuilder,
  });
}

/// The main Searchable Custom Data Table
class SearchableDataTable<T> extends StatefulWidget {
  // Data
  final List<T> data;
  final List<DataColumnDefinition<T>> columns;

  // Optional search logic
  final bool Function(T item, String query)? searchFilter;

  // Search bar customization
  final String searchHint;
  final TextStyle? searchTextStyle;
  final double searchHeight, searchWidth;
  final EdgeInsetsGeometry? searchPadding;
  final Color? searchBackgroundColor;
  final Color? searchBorderColor;
  final BorderRadius? searchBorderRadius;
  final IconData searchIcon;
  final Color? searchIconColor;
  final double searchIconSize;

  // Table customization
  final String? title;
  final TextStyle? titleStyle;
  final double? rowHeight;
  final TextStyle? headerStyle;
  final TextStyle? cellStyle;
  final Color? headerColor;
  final Color? evenRowColor;
  final Color? oddRowColor;
  final double? borderWidth;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final double elevation;
  final EdgeInsetsGeometry? padding;
  final bool showBorders;
  final double? columnSpacing;

  const SearchableDataTable({
    super.key,
    required this.data,

    required this.columns,
    this.searchFilter,
    this.searchHint = '',
    this.searchTextStyle,
    this.searchHeight = 48,
    this.searchWidth = 100,
    this.searchPadding,
    this.searchBackgroundColor,
    this.searchBorderColor,
    this.searchBorderRadius,
    this.searchIcon = Icons.search,
    this.searchIconColor,
    this.searchIconSize = 22,
    this.title,
    this.titleStyle,
    this.rowHeight,
    this.headerStyle,
    this.cellStyle,
    this.headerColor,
    this.evenRowColor,
    this.oddRowColor,
    this.borderWidth,
    this.borderColor,
    this.borderRadius,
    this.elevation = 2,
    this.padding,
    this.showBorders = true,
    this.columnSpacing,
  });

  @override
  State<SearchableDataTable<T>> createState() => _SearchableDataTableState<T>();
}

class _SearchableDataTableState<T> extends State<SearchableDataTable<T>> {
  String _searchQuery = '';
  final _personalInfoFormKey = GlobalKey<FormState>();
  final _workInfoFormKey = GlobalKey<FormState>();
  final _contactFormKey = GlobalKey<FormState>();
  final _useraccountFormKey = GlobalKey<FormState>();
  final _permissionFormKey = GlobalKey<FormState>();

  final ScrollController _scrollController = ScrollController();
  Future<void> _saveEmployee({
    required BuildContext dialogContext,
    required BuildContext parentContext,
    required TextEditingController nationalIDController,
    required TextEditingController firstNameController,
    required TextEditingController lastNameController,
    required TextEditingController mobileController,
    required TextEditingController additionalMobileController,
    required String genderr,
    required String dobb,
    required String religionn,

    required TextEditingController employeeID,
    required TextEditingController employeePosition,
    required String department,
    required String branch,
    required String location,
    required String shiftType,
    required String schedule,
    required String vacationStartDate,
    required TextEditingController normalVacation,
    required TextEditingController urgentVacation,
    required TextEditingController unpaidVacationBalance,

    required void Function(void Function()) setDialogState,
  }) async {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final mobile = mobileController.text.trim();
    final additionalMobile = additionalMobileController.text.trim();
    final nationalID = nationalIDController.text.trim();

    if ((index == 0 && !_personalInfoFormKey.currentState!.validate()) &&
        (index == 1 && !_workInfoFormKey.currentState!.validate()) &&
        (index == 2 && !_contactFormKey.currentState!.validate()) &&
        (index == 3 && !_useraccountFormKey.currentState!.validate()) &&
        (index == 4 && !_permissionFormKey.currentState!.validate())) {
      return;
    }

    // ✅ START LOADING
    setDialogState(() {});

    final result = await Provider.of<AuthProvider>(
      parentContext,
      listen: false,
    ).signup(
      username: 'wohoooo working',
      email: 'emailsss@gmail.com',
      password: 'password',
      gender: genderr,
      mobileNumber: mobile,
      additionalMobileNumber: additionalMobile,
      dob: dobb,
      religon: religionn,
      firstName: firstName,
      lastName: lastName,
      nationalID: nationalID,

      employeeID: employeeID.text.trim(),
      employeePosition: employeePosition.text.trim(),
      department: department,
      location: location,
      branch: branch,
      shiftType: shiftType,
      schedule: schedule,
      vacationStartDate: vacationStartDate,
      normalVacation: normalVacation.text.trim(),
      urgentVacation: urgentVacation.text.trim(),
      unpaidVacationBalance: unpaidVacationBalance.text.trim(),
    );

    // ✅ CLOSE DIALOG FIRST
    if (result) {
      if (Navigator.canPop(dialogContext)) {
        Navigator.pop(dialogContext);
      }
    } else {
      // Optionally show error message from AuthProvider
      final error =
          Provider.of<AuthProvider>(parentContext, listen: false).errorMessage;
      print(error);
      // ScaffoldMessenger.of(parentContext).showSnackBar(
      //   SnackBar(content: Text(error ?? 'Failed to add employee')),
      // );
    }

    // ✅ STOP LOADING
    setDialogState(() {});
  }

  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _nationalIDFocus = FocusNode();
  final FocusNode _mobileNumberFocus = FocusNode();
  final FocusNode _additionalMobileNumberFocus = FocusNode();
  final FocusNode _genderFocus = FocusNode();
  final FocusNode _employeeIDFocus = FocusNode();
  final FocusNode _positionFocus = FocusNode();
  final FocusNode _branchFocus = FocusNode();
  final FocusNode _locationFocus = FocusNode();
  final FocusNode _departmentFocus = FocusNode();
  final FocusNode _shiftFocus = FocusNode();
  final FocusNode _scheduleFocus = FocusNode();
  final FocusNode _urgentVacationFocus = FocusNode();
  final FocusNode _vacationStartFocus = FocusNode();
  final FocusNode _unpaidVacationBalanceFocus = FocusNode();
  final FocusNode _normalVacationFocus = FocusNode();
  final FocusNode _dobFocusNode = FocusNode();

  final FocusNode _joinDateNode = FocusNode();
  final FocusNode _grossSalaryNode = FocusNode();
  final FocusNode _newGrossSalaryNode = FocusNode();
  final FocusNode _insuranceSalaryNode = FocusNode();
  final FocusNode _effectiveSalaryDateNode = FocusNode();
  final FocusNode _contractTypeNode = FocusNode();
  final FocusNode _shiftHoursNode = FocusNode();
  final FocusNode _paymentMethodNode = FocusNode();
  final FocusNode _currencyNode = FocusNode();
  final FocusNode _otherExemptionNode = FocusNode();
  final FocusNode _advancedPaymentNode = FocusNode();
  final FocusNode _bankAccountNumberNode = FocusNode();
  final FocusNode _bankNameNode = FocusNode();
  final FocusNode _startContractDate = FocusNode();
  final FocusNode _endContractDate = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _medicalNode = FocusNode();
  final FocusNode _taxableNode = FocusNode();
  final FocusNode _accessRoleNode = FocusNode();
  // final FocusNode _payslipPermissionsNode = FocusNode();
  // final FocusNode _permissionRequestsNode = FocusNode();
  // final FocusNode _excuseLimitNode = FocusNode();

  @override
  void dispose() {
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _nationalIDFocus.dispose();
    _mobileNumberFocus.dispose();
    _additionalMobileNumberFocus.dispose();
    _genderFocus.dispose();
    _employeeIDFocus.dispose();
    _positionFocus.dispose();
    _branchFocus.dispose();
    _locationFocus.dispose();
    _scheduleFocus.dispose();
    _shiftFocus.dispose();
    _departmentFocus.dispose();
    _unpaidVacationBalanceFocus.dispose();
    _vacationStartFocus.dispose();
    _normalVacationFocus.dispose();
    _urgentVacationFocus.dispose();
    _dobFocusNode.dispose();
    _additionalMobileNumberFocus.dispose();
    _advancedPaymentNode.dispose();
    _bankAccountNumberNode.dispose();
    _bankNameNode.dispose();
    _paymentMethodNode.dispose();
    _taxableNode.dispose();
    _emailNode.dispose();
    _accessRoleNode.dispose();
    _medicalNode.dispose();
    super.dispose();
  }

  int index = 0;
  final uploaderKey = GlobalKey<DesktopImageUploaderState>();

  void showAddEmployeeDialog({
    required BuildContext context,
    required AuthProvider provider,
  }) {
    final parentContext = context;
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final nationalIDController = TextEditingController();
    final mobileController = TextEditingController();
    final additionalMobileController = TextEditingController();

    final employeeIDController = TextEditingController();
    final positionController = TextEditingController();
    final normalVacationController = TextEditingController();
    final urgentVacationController = TextEditingController();
    final unpaidVacationBalanceController = TextEditingController();

    final grossSalaryController = TextEditingController();
    final newGrossSalaryController = TextEditingController();
    final insuranceSalaryController = TextEditingController();
    final otherExemptionController = TextEditingController();
    final shiftHoursController = TextEditingController();
    final advancedPaymentLimitController = TextEditingController();
    final banckAccountNumberController = TextEditingController();
    final bankNameController = TextEditingController();

    final emailController = TextEditingController();
    // final usernameController = TextEditingController();

    String? selectedGender;
    String? selectedReligion;
    String? selectedLocation;
    String? selectedDepartment;
    String? selectedBranch;
    String? selectedShift;
    String? selectedSchedule;

    DateTime? selectedDob;
    DateTime? selectedVacationStartDate;

    DateTime? selectedJoinDate;
    DateTime? effectiveSalaryDate;
    DateTime? startContractDate;
    DateTime? endContractDate;

    String? paymentMethod;
    String? contractType;
    String? currency;

    String? accessRole;

    bool medicaleInsurance = false;
    bool isTaxable = false;
    bool permissionRequests = false;
    bool paylsipPermissions = false;
    bool excuseLimit = false;

    InputDecoration _dropdownDecoration(String label) {
      return InputDecoration(
        isDense: true, // ✅ VERY IMPORTANT
        labelText: label,
        labelStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 3.5.sp,
          color: Colors.black26,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black12, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.purple, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 10.5.h, // ✅ MATCHES TEXT FIELD HEIGHT
          horizontal: 5.w,
        ),
      );
    }

    Widget _departmentDropdown() {
      return Padding(
        padding: EdgeInsets.only(bottom: 15.h),
        child: SizedBox(
          width: double.infinity,
          height: 50.h,
          child: Theme(
            data: Theme.of(context).copyWith(
              hoverColor: Colors.purple.withOpacity(0.15), // ✅ Hover color
              focusColor: Colors.transparent,
            ),
            child: DropdownButtonFormField<String>(
              value: selectedDepartment,
              decoration: _dropdownDecoration("Department"), // ✅ Rounded border
              dropdownColor: Colors.white,
              items: [
                DropdownMenuItem(
                  value: "Video Editing Intern",
                  child: Text(
                    "Video Editing Intern",
                    style: TextStyle(
                      fontSize: 3.5.sp,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: "Content & Strategy",
                  child: Text(
                    "Content & Strategy",
                    style: TextStyle(
                      fontSize: 3.5.sp,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() => selectedDepartment = value);
              },
              validator:
                  (value) =>
                      value == null ? "Please select a Department" : null,
            ),
          ),
        ),
      );
    }

    Widget _genderDropdown() {
      return Padding(
        padding: EdgeInsets.only(bottom: 15.h),
        child: SizedBox(
          width: 75.w,
          height: 50.h,
          child: Theme(
            data: Theme.of(context).copyWith(
              hoverColor: Colors.purple.withOpacity(0.15), // ✅ Hover color
              focusColor: Colors.transparent,
            ),
            child: DropdownButtonFormField<String>(
              value: selectedGender,
              decoration: _dropdownDecoration("Gender"), // ✅ Rounded border
              dropdownColor: Colors.white, // ✅ Clean dropdown background
              items: [
                DropdownMenuItem(
                  value: "Male",
                  child: Text(
                    "Male",
                    style: TextStyle(
                      fontSize: 3.5.sp,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: "Female",
                  child: Text(
                    "Female",
                    style: TextStyle(
                      fontSize: 3.5.sp,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() => selectedGender = value);
              },
              validator:
                  (value) => value == null ? "Please select a Gender" : null,
            ),
          ),
        ),
      );
    }

    Widget _branchDropdown() {
      return Padding(
        padding: EdgeInsets.only(bottom: 15.h),
        child: SizedBox(
          width: 75.w,
          height: 50.h,
          child: Theme(
            data: Theme.of(context).copyWith(
              hoverColor: Colors.purple.withOpacity(0.15), // ✅ Hover color
              focusColor: Colors.transparent,
            ),
            child: DropdownButtonFormField<String>(
              value: selectedBranch,
              decoration: _dropdownDecoration("Branch"), // ✅ Rounded border
              dropdownColor: Colors.white,
              items: [
                DropdownMenuItem(
                  value: "Egypt",
                  child: Text(
                    "Egypt",
                    style: TextStyle(
                      fontSize: 3.5.sp,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: "Saudia Arabia",
                  child: Text(
                    "Saudia Arabia",
                    style: TextStyle(
                      fontSize: 3.5.sp,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() => selectedBranch = value);
              },
              validator:
                  (value) => value == null ? "Please select a Branch" : null,
            ),
          ),
        ),
      );
    }

    Widget _locationDropdown() {
      return Padding(
        padding: EdgeInsets.only(bottom: 15.h),
        child: SizedBox(
          width: 75.w,
          height: 50.h,
          child: Theme(
            data: Theme.of(context).copyWith(
              hoverColor: Colors.purple.withOpacity(0.15), // ✅ Hover color
              focusColor: Colors.transparent,
            ),
            child: DropdownButtonFormField<String>(
              value: selectedLocation,
              decoration: _dropdownDecoration("Location"), // ✅ Rounded border
              dropdownColor: Colors.white,
              items: [
                DropdownMenuItem(
                  value: "Sporting Branch",
                  child: Text(
                    "Sporting Branch",
                    style: TextStyle(
                      fontSize: 3.5.sp,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: "Cairo Branch",
                  child: Text(
                    "Cairo Branch",
                    style: TextStyle(
                      fontSize: 3.5.sp,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() => selectedLocation = value);
              },
              validator:
                  (value) => value == null ? "Please select a Location" : null,
            ),
          ),
        ),
      );
    }

    Widget _currencyDropdown() {
      return Padding(
        padding: EdgeInsets.only(bottom: 15.h),
        child: SizedBox(
          width: 75.w,
          height: 50.h,
          child: Theme(
            data: Theme.of(context).copyWith(
              hoverColor: Colors.purple.withOpacity(0.15), // ✅ Hover color
              focusColor: Colors.transparent,
            ),
            child: DropdownButtonFormField<String>(
              value: currency,
              decoration: _dropdownDecoration("Currency"), // ✅ Rounded border
              dropdownColor: Colors.white,
              items: [
                DropdownMenuItem(
                  value: "Egyptian Geneh Pound (EGP)",
                  child: Text(
                    "Egyptian Geneh Pound (EGP)",
                    style: TextStyle(
                      fontSize: 3.5.sp,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: "United States Dollars (USD)",
                  child: Text(
                    "United States Dollars (USD)",
                    style: TextStyle(
                      fontSize: 3.5.sp,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() => currency = value);
              },
              validator:
                  (value) => value == null ? "Please select a Currency" : null,
            ),
          ),
        ),
      );
    }

    Widget _accessRoleDropdown() {
      return Padding(
        padding: EdgeInsets.only(bottom: 15.h),
        child: SizedBox(
          width: 75.w,
          height: 50.h,
          child: Theme(
            data: Theme.of(context).copyWith(
              hoverColor: Colors.purple.withOpacity(0.15), // ✅ Hover color
              focusColor: Colors.transparent,
            ),
            child: DropdownButtonFormField<String>(
              value: accessRole,
              decoration: _dropdownDecoration(
                "Access Role",
              ), // ✅ Rounded border
              dropdownColor: Colors.white,
              items: [
                DropdownMenuItem(
                  value: "Employee",
                  child: Text(
                    "Employee",
                    style: TextStyle(
                      fontSize: 3.5.sp,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: "Super Admin",
                  child: Text(
                    "Super Admin",
                    style: TextStyle(
                      fontSize: 3.5.sp,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() => accessRole = value);
              },
              validator:
                  (value) =>
                      value == null ? "Please select an Access Role" : null,
            ),
          ),
        ),
      );
    }

    Widget _paymentMethodDropdown() {
      return Padding(
        padding: EdgeInsets.only(bottom: 15.h),
        child: SizedBox(
          width: 75.w,
          height: 50.h,
          child: Theme(
            data: Theme.of(context).copyWith(
              hoverColor: Colors.purple.withOpacity(0.15), // ✅ Hover color
              focusColor: Colors.transparent,
            ),
            child: DropdownButtonFormField<String>(
              value: paymentMethod,
              decoration: _dropdownDecoration(
                "Payment Method",
              ), // ✅ Rounded border
              dropdownColor: Colors.white,
              items: [
                DropdownMenuItem(
                  value: "Instapay",
                  child: Text(
                    "Instapay",
                    style: TextStyle(
                      fontSize: 3.5.sp,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: "Bank Account",
                  child: Text(
                    "Bank Account",
                    style: TextStyle(
                      fontSize: 3.5.sp,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: "Cash",
                  child: Text(
                    "Cash",
                    style: TextStyle(
                      fontSize: 3.5.sp,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() => paymentMethod = value);
              },
              validator:
                  (value) =>
                      value == null ? "Please select a Payment Method" : null,
            ),
          ),
        ),
      );
    }

    Widget _contractTypeDropdown() {
      return Padding(
        padding: EdgeInsets.only(bottom: 15.h),
        child: SizedBox(
          width: 75.w,
          height: 50.h,
          child: Theme(
            data: Theme.of(context).copyWith(
              hoverColor: Colors.purple.withOpacity(0.15), // ✅ Hover color
              focusColor: Colors.transparent,
            ),
            child: DropdownButtonFormField<String>(
              value: contractType,
              decoration: _dropdownDecoration(
                "Contract Type",
              ), // ✅ Rounded border
              dropdownColor: Colors.white,
              items: [
                DropdownMenuItem(
                  value: "From Home",
                  child: Text(
                    "From Home",
                    style: TextStyle(
                      fontSize: 3.5.sp,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: "Remote",
                  child: Text(
                    "Remote",
                    style: TextStyle(
                      fontSize: 3.5.sp,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: "Fixed",
                  child: Text(
                    "Fixed",
                    style: TextStyle(
                      fontSize: 3.5.sp,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() => contractType = value);
              },
              validator:
                  (value) =>
                      value == null ? "Please select a Contract Type" : null,
            ),
          ),
        ),
      );
    }

    Widget _shiftDropdown() {
      return Padding(
        padding: EdgeInsets.only(bottom: 15.h),
        child: SizedBox(
          width: 75.w,
          height: 50.h,
          child: Theme(
            data: Theme.of(context).copyWith(
              hoverColor: Colors.purple.withOpacity(0.15), // ✅ Hover color
              focusColor: Colors.transparent,
            ),
            child: DropdownButtonFormField<String>(
              value: selectedShift,
              decoration: _dropdownDecoration("Shift Type"), // ✅ Rounded border
              dropdownColor: Colors.white,
              items: [
                DropdownMenuItem(
                  value: "Fixed",
                  child: Text(
                    "Fixed",
                    style: TextStyle(
                      fontSize: 3.5.sp,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: "Flexible",
                  child: Text(
                    "Flexible",
                    style: TextStyle(
                      fontSize: 3.5.sp,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() => selectedShift = value);
              },
              validator:
                  (value) =>
                      value == null ? "Please select a Shift Type" : null,
            ),
          ),
        ),
      );
    }

    Widget _scheduleDropdown() {
      return Padding(
        padding: EdgeInsets.only(bottom: 15.h),
        child: SizedBox(
          width: 75.w,
          height: 50.h,
          child: Theme(
            data: Theme.of(context).copyWith(
              hoverColor: Colors.purple.withOpacity(0.15), // ✅ Hover color
              focusColor: Colors.transparent,
            ),
            child: DropdownButtonFormField<String>(
              value: selectedSchedule,
              decoration: _dropdownDecoration("Schedule"), // ✅ Rounded border
              dropdownColor: Colors.white,
              items: [
                DropdownMenuItem(
                  value: "Fixed",
                  child: Text(
                    "Fixed",
                    style: TextStyle(
                      fontSize: 3.5.sp,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: "Double Schedule",
                  child: Text(
                    "Double Schedule",
                    style: TextStyle(
                      fontSize: 3.5.sp,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() => selectedSchedule = value);
              },
              validator:
                  (value) => value == null ? "Please select a Schedule" : null,
            ),
          ),
        ),
      );
    }

    Widget _religionDropdown() {
      return Padding(
        padding: EdgeInsets.only(bottom: 15.h),
        child: SizedBox(
          width: 75.w,
          height: 50.h,
          child: Theme(
            data: Theme.of(context).copyWith(
              hoverColor: Colors.purple.withOpacity(0.15),
              focusColor: Colors.transparent,
            ),
            child: DropdownButtonFormField<String>(
              value: selectedReligion,
              decoration: _dropdownDecoration("Religion"),
              dropdownColor: Colors.white,
              items: [
                DropdownMenuItem(
                  value: "Muslim",
                  child: Text(
                    "Muslim",
                    style: TextStyle(
                      fontSize: 3.5.sp,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: "Christian",
                  child: Text(
                    "Christian",
                    style: TextStyle(
                      fontSize: 3.5.sp,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: "Other",
                  child: Text(
                    "Other",
                    style: TextStyle(
                      fontSize: 3.5.sp,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() => selectedReligion = value);
              },
              validator:
                  (value) => value == null ? "Please select a Religion" : null,
            ),
          ),
        ),
      );
    }

    Widget _dobPicker(BuildContext context, dynamic setDialogState) {
      return Padding(
        padding: EdgeInsets.only(bottom: 15.h),
        child: SizedBox(
          width: 75.w,
          height: 50.h,
          child: TextFormField(
            focusNode: _dobFocusNode,
            textInputAction: TextInputAction.next,
            readOnly: true,
            // ✅ VALUE TEXT STYLE
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 3.5.sp,
              color: Colors.black87,
            ),

            // ✅ DECORATION (TITLE STYLE APPLIED)
            decoration: _dropdownDecoration("Date of Birth").copyWith(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 5.w,
                vertical: 0,
              ),
              labelStyle: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 3.5.sp,
                color: Colors.black26,
              ),
              prefixIcon: Icon(
                Icons.calendar_today,
                color:
                    selectedDob == null
                        ? Colors.purple.shade100
                        : Colors.purple.shade500,
                size: 5.sp,
              ),
            ),

            controller: TextEditingController(
              text:
                  selectedDob == null
                      ? ""
                      : "${selectedDob!.day}/${selectedDob!.month}/${selectedDob!.year}",
            ),

            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime(2000),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
                confirmText: "Select",

                // ✅ FULL DATE PICKER TYPOGRAPHY THEME
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Colors.purple, // ✅ Header + active date
                        onPrimary: Colors.white, // ✅ Header text
                        onSurface: Colors.black87, // ✅ Body text
                      ),

                      textTheme: TextTheme(
                        titleLarge: TextStyle(
                          fontFamily: 'PoppinsSemiBold',
                          fontSize: 5.sp,
                          color: Colors.black87,
                        ),
                        bodyMedium: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 4.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (picked != null) {
                setDialogState(() {
                  selectedDob = picked;
                });
              }
            },

            onFieldSubmitted: (_) {
              FocusScope.of(
                _dobFocusNode.context!,
              ).requestFocus(_mobileNumberFocus);
            },

            validator:
                (value) =>
                    selectedDob == null ? "Please select Date of Birth" : null,
          ),
        ),
      );
    }

    Widget _joinDatePicker(BuildContext context, dynamic setDialogState) {
      return Padding(
        padding: EdgeInsets.only(bottom: 15.h),
        child: SizedBox(
          width: double.infinity,
          height: 50.h,
          child: TextFormField(
            focusNode: _joinDateNode,
            readOnly: true,
            // ✅ VALUE TEXT STYLE
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 3.5.sp,
              color: Colors.black87,
            ),

            // ✅ DECORATION (TITLE STYLE APPLIED)
            decoration: _dropdownDecoration("Join Date").copyWith(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 5.w,
                vertical: 0,
              ),
              labelStyle: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 3.5.sp,
                color: Colors.black26,
              ),
              prefixIcon: Icon(
                Icons.calendar_today,
                color:
                    selectedJoinDate == null
                        ? Colors.purple.shade100
                        : Colors.purple.shade500,
                size: 5.sp,
              ),
            ),

            controller: TextEditingController(
              text:
                  selectedJoinDate == null
                      ? ""
                      : "${selectedJoinDate!.day}/${selectedJoinDate!.month}/${selectedJoinDate!.year}",
            ),

            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime(2000),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
                confirmText: "Select",

                // ✅ FULL DATE PICKER TYPOGRAPHY THEME
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Colors.purple, // ✅ Header + active date
                        onPrimary: Colors.white, // ✅ Header text
                        onSurface: Colors.black87, // ✅ Body text
                      ),

                      textTheme: TextTheme(
                        titleLarge: TextStyle(
                          fontFamily: 'PoppinsSemiBold',
                          fontSize: 5.sp,
                          color: Colors.black87,
                        ),
                        bodyMedium: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 4.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (picked != null) {
                setDialogState(() {
                  selectedJoinDate = picked;
                });
              }
            },
            onFieldSubmitted: (_) {
              FocusScope.of(
                _joinDateNode.context!,
              ).requestFocus(_grossSalaryNode);
            },

            validator:
                (value) =>
                    selectedJoinDate == null ? "Please select Join Date" : null,
          ),
        ),
      );
    }

    Widget _startContractDatePicker(
      BuildContext context,
      dynamic setDialogState,
    ) {
      return Padding(
        padding: EdgeInsets.only(bottom: 15.h),
        child: SizedBox(
          width: double.infinity,
          height: 50.h,
          child: TextFormField(
            focusNode: _startContractDate,
            readOnly: true,
            // ✅ VALUE TEXT STYLE
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 3.5.sp,
              color: Colors.black87,
            ),

            // ✅ DECORATION (TITLE STYLE APPLIED)
            decoration: _dropdownDecoration("Start Contract Date").copyWith(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 5.w,
                vertical: 0,
              ),
              labelStyle: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 3.5.sp,
                color: Colors.black26,
              ),
              prefixIcon: Icon(
                Icons.calendar_today,
                color:
                    startContractDate == null
                        ? Colors.purple.shade100
                        : Colors.purple.shade500,
                size: 5.sp,
              ),
            ),

            controller: TextEditingController(
              text:
                  startContractDate == null
                      ? ""
                      : "${startContractDate!.day}/${startContractDate!.month}/${startContractDate!.year}",
            ),

            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime(2000),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
                confirmText: "Select",

                // ✅ FULL DATE PICKER TYPOGRAPHY THEME
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Colors.purple, // ✅ Header + active date
                        onPrimary: Colors.white, // ✅ Header text
                        onSurface: Colors.black87, // ✅ Body text
                      ),

                      textTheme: TextTheme(
                        titleLarge: TextStyle(
                          fontFamily: 'PoppinsSemiBold',
                          fontSize: 5.sp,
                          color: Colors.black87,
                        ),
                        bodyMedium: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 4.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (picked != null) {
                setDialogState(() {
                  startContractDate = picked;
                });
              }
            },

            onFieldSubmitted: (_) {
              FocusScope.of(
                _startContractDate.context!,
              ).requestFocus(_endContractDate);
            },

            validator:
                (value) =>
                    startContractDate == null
                        ? "Please select Start Contract Date"
                        : null,
          ),
        ),
      );
    }

    Widget _endContractDatePicker(
      BuildContext context,
      dynamic setDialogState,
    ) {
      return Padding(
        padding: EdgeInsets.only(bottom: 15.h),
        child: SizedBox(
          width: double.infinity,
          height: 50.h,
          child: TextFormField(
            focusNode: _endContractDate,
            readOnly: true,
            // ✅ VALUE TEXT STYLE
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 3.5.sp,
              color: Colors.black87,
            ),

            // ✅ DECORATION (TITLE STYLE APPLIED)
            decoration: _dropdownDecoration("End Contract Date").copyWith(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 5.w,
                vertical: 0,
              ),
              labelStyle: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 3.5.sp,
                color: Colors.black26,
              ),
              prefixIcon: Icon(
                Icons.calendar_today,
                color:
                    endContractDate == null
                        ? Colors.purple.shade100
                        : Colors.purple.shade500,
                size: 5.sp,
              ),
            ),

            controller: TextEditingController(
              text:
                  endContractDate == null
                      ? ""
                      : "${endContractDate!.day}/${endContractDate!.month}/${endContractDate!.year}",
            ),

            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime(2000),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
                confirmText: "Select",

                // ✅ FULL DATE PICKER TYPOGRAPHY THEME
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Colors.purple, // ✅ Header + active date
                        onPrimary: Colors.white, // ✅ Header text
                        onSurface: Colors.black87, // ✅ Body text
                      ),

                      textTheme: TextTheme(
                        titleLarge: TextStyle(
                          fontFamily: 'PoppinsSemiBold',
                          fontSize: 5.sp,
                          color: Colors.black87,
                        ),
                        bodyMedium: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 4.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (picked != null) {
                setDialogState(() {
                  endContractDate = picked;
                });
              }
            },

            validator:
                (value) =>
                    endContractDate == null
                        ? "Please select End Contract Date"
                        : null,
          ),
        ),
      );
    }

    Widget _startVacationDatePicker(
      BuildContext context,
      dynamic setDialogState,
    ) {
      return Padding(
        padding: EdgeInsets.only(bottom: 15.h),
        child: SizedBox(
          width: 75.w,
          height: 50.h,
          child: TextFormField(
            readOnly: true,
            // ✅ VALUE TEXT STYLE
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 3.5.sp,
              color: Colors.black87,
            ),

            // ✅ DECORATION (TITLE STYLE APPLIED)
            decoration: _dropdownDecoration("Vacation Start Date").copyWith(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 5.w,
                vertical: 0,
              ),
              labelStyle: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 3.5.sp,
                color: Colors.black26,
              ),
              prefixIcon: Icon(
                Icons.calendar_today,
                color:
                    selectedVacationStartDate == null
                        ? Colors.purple.shade100
                        : Colors.purple.shade500,
                size: 5.sp,
              ),
            ),

            controller: TextEditingController(
              text:
                  selectedVacationStartDate == null
                      ? ""
                      : "${selectedVacationStartDate!.day}/${selectedVacationStartDate!.month}/${selectedVacationStartDate!.year}",
            ),

            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime(2000),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
                confirmText: "Select",

                // ✅ FULL DATE PICKER TYPOGRAPHY THEME
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Colors.purple, // ✅ Header + active date
                        onPrimary: Colors.white, // ✅ Header text
                        onSurface: Colors.black87, // ✅ Body text
                      ),

                      textTheme: TextTheme(
                        titleLarge: TextStyle(
                          fontFamily: 'PoppinsSemiBold',
                          fontSize: 5.sp,
                          color: Colors.black87,
                        ),
                        bodyMedium: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 4.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (picked != null) {
                setDialogState(() {
                  selectedVacationStartDate = picked;
                });
              }
            },

            validator:
                (value) =>
                    selectedVacationStartDate == null
                        ? "Please select Start of Vacation Date"
                        : null,
          ),
        ),
      );
    }

    Widget _effectiveSalaryDatePicker(
      BuildContext context,
      dynamic setDialogState,
    ) {
      return Padding(
        padding: EdgeInsets.only(bottom: 15.h),
        child: SizedBox(
          width: 75.w,
          height: 50.h,
          child: TextFormField(
            readOnly: true,
            // ✅ VALUE TEXT STYLE
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 3.5.sp,
              color: Colors.black87,
            ),

            // ✅ DECORATION (TITLE STYLE APPLIED)
            decoration: _dropdownDecoration("Effective Salary Date").copyWith(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 5.w,
                vertical: 0,
              ),
              labelStyle: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 3.5.sp,
                color: Colors.black26,
              ),
              prefixIcon: Icon(
                Icons.calendar_today,
                color:
                    effectiveSalaryDate == null
                        ? Colors.purple.shade100
                        : Colors.purple.shade500,
                size: 5.sp,
              ),
            ),

            controller: TextEditingController(
              text:
                  effectiveSalaryDate == null
                      ? ""
                      : "${effectiveSalaryDate!.day}/${effectiveSalaryDate!.month}/${effectiveSalaryDate!.year}",
            ),

            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime(2000),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
                confirmText: "Select",

                // ✅ FULL DATE PICKER TYPOGRAPHY THEME
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Colors.purple, // ✅ Header + active date
                        onPrimary: Colors.white, // ✅ Header text
                        onSurface: Colors.black87, // ✅ Body text
                      ),

                      textTheme: TextTheme(
                        titleLarge: TextStyle(
                          fontFamily: 'PoppinsSemiBold',
                          fontSize: 5.sp,
                          color: Colors.black87,
                        ),
                        bodyMedium: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 4.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (picked != null) {
                setDialogState(() {
                  effectiveSalaryDate = picked;
                });
              }
            },

            validator:
                (value) =>
                    effectiveSalaryDate == null
                        ? "Please select an Effective Salary Date"
                        : null,
          ),
        ),
      );
    }

    showDialog(
      context: parentContext,
      barrierDismissible: true,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: Text(
                "Create New Employee",
                style: TextStyle(fontFamily: 'Poppins', fontSize: 6.sp),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade200,
                        // color: Colors.purple,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: stepProgressRow(
                        steps: [
                          'Personal Info',
                          'Work Info',
                          'Contract Info',
                          'User Account',
                          'Permissions',
                        ],
                        currentStep: index,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    index == 0
                        ? Form(
                          key: _personalInfoFormKey,
                          child: Column(
                            children: [
                              DesktopImageUploader(
                                key: uploaderKey,
                                folderName: 'folderName',
                              ),
                              SizedBox(height: 37.h),
                              Row(
                                children: [
                                  _dialogField(
                                    "First Name",
                                    firstNameController,
                                    focusNode: _firstNameFocus,
                                    nextFocus: _lastNameFocus,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a First Name';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(width: 5.w),
                                  _dialogField(
                                    "Last Name",
                                    lastNameController,
                                    focusNode: _lastNameFocus,
                                    nextFocus: _nationalIDFocus,

                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a Last Name';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  _dialogField(
                                    "National ID",
                                    nationalIDController,
                                    focusNode: _nationalIDFocus,
                                    nextFocus: _mobileNumberFocus,
                                    prefix: Icon(
                                      FontAwesomeIcons.idCard,
                                      color:
                                          nationalIDController.text
                                                      .trim()
                                                      .length ==
                                                  14
                                              ? Colors.purple.shade500
                                              : Colors.purple.shade100,
                                      size: 5.sp,
                                    ),
                                    onChanged:
                                        (nid) =>
                                            nationalIDController.text
                                                        .trim()
                                                        .length ==
                                                    14
                                                ? setDialogState(() {})
                                                : null,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(14),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a National ID number';
                                      }
                                      if (!RegExp(
                                        r'^\d{14}$',
                                      ).hasMatch(value)) {
                                        return 'National ID number must be 14 digits';
                                      }
                                      return null; // valid
                                    },
                                  ),
                                  SizedBox(width: 5.w),
                                  Expanded(
                                    child: _dobPicker(context, setDialogState),
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  _dialogField(
                                    "Mobile Number",
                                    mobileController,
                                    focusNode: _mobileNumberFocus,
                                    nextFocus: _additionalMobileNumberFocus,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(11),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a Mobile Number';
                                      }
                                      if (!RegExp(
                                        r'^\d{11}$',
                                      ).hasMatch(value)) {
                                        return 'Mobile Number must be 11 digits';
                                      }
                                      return null; // valid
                                    },
                                  ),
                                  SizedBox(width: 5.w),
                                  _dialogField(
                                    "Additional Mobile Number",
                                    additionalMobileController,
                                    focusNode: _additionalMobileNumberFocus,
                                    nextFocus: _genderFocus,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(11),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    validator: (value) {
                                      // if (value == null || value.isEmpty) {
                                      //   return 'Please enter a phone number';
                                      // }
                                      if (!RegExp(
                                        r'^\d{11}$',
                                      ).hasMatch(value!)) {
                                        return 'Mobile number must be 11 digits';
                                      }
                                      return null; // valid
                                    },
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Expanded(child: _genderDropdown()),
                                  SizedBox(width: 5.w),
                                  Expanded(child: _religionDropdown()),
                                ],
                              ),
                            ],
                          ),
                        )
                        : index == 1
                        ? Form(
                          key: _workInfoFormKey,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  _dialogField(
                                    "Employee ID",
                                    employeeIDController,
                                    focusNode: _employeeIDFocus,
                                    nextFocus: _positionFocus,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter an Employee ID';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(width: 5.w),
                                  _dialogField(
                                    "Employee Position",
                                    positionController,
                                    focusNode: _positionFocus,
                                    nextFocus: _branchFocus,

                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a Position';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                              _departmentDropdown(),

                              Row(
                                children: [
                                  Expanded(child: _branchDropdown()),
                                  SizedBox(width: 5.w),
                                  Expanded(child: _locationDropdown()),
                                ],
                              ),

                              Row(
                                children: [
                                  Expanded(child: _shiftDropdown()),
                                  SizedBox(width: 5.w),
                                  Expanded(child: _scheduleDropdown()),
                                ],
                              ),

                              Padding(
                                padding: EdgeInsets.only(
                                  left: 5.w,
                                  right: 5.w,
                                  bottom: 30.h,
                                ),
                                child: Divider(),
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    child: _startVacationDatePicker(
                                      context,
                                      setDialogState,
                                    ),
                                  ),
                                  SizedBox(width: 5.w),

                                  _dialogField(
                                    "Normal Vacation",
                                    normalVacationController,
                                    focusNode: _normalVacationFocus,
                                    nextFocus: _urgentVacationFocus,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(5),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  _dialogField(
                                    "Urgent Vacation",
                                    urgentVacationController,
                                    focusNode: _urgentVacationFocus,
                                    nextFocus: _unpaidVacationBalanceFocus,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(5),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                  SizedBox(width: 5.w),
                                  _dialogField(
                                    "Unpaid Vacation Balance",
                                    unpaidVacationBalanceController,
                                    focusNode: _unpaidVacationBalanceFocus,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(5),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                        : index == 2
                        ? Form(
                          key: _contactFormKey,
                          child: Column(
                            children: [
                              _joinDatePicker(context, setDialogState),
                              Row(
                                children: [
                                  _dialogField(
                                    "Gross Salary",
                                    grossSalaryController,
                                    focusNode: _grossSalaryNode,
                                    nextFocus: _unpaidVacationBalanceFocus,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(5),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                  SizedBox(width: 5.w),
                                  _dialogField(
                                    "New Gross Salary",
                                    newGrossSalaryController,
                                    focusNode: _newGrossSalaryNode,
                                    nextFocus: _effectiveSalaryDateNode,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(5),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: _effectiveSalaryDatePicker(
                                      context,
                                      setDialogState,
                                    ),
                                  ),
                                  SizedBox(width: 5.w),
                                  _dialogField(
                                    "Insurance Salary",
                                    insuranceSalaryController,
                                    focusNode: _insuranceSalaryNode,
                                    nextFocus: _otherExemptionNode,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(5),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  _dialogField(
                                    "Other Exemption",
                                    otherExemptionController,
                                    focusNode: _otherExemptionNode,
                                    nextFocus: _currencyNode,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(5),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                  SizedBox(width: 5.w),
                                  Expanded(child: _currencyDropdown()),
                                ],
                              ),
                              Row(
                                children: [
                                  _dialogField(
                                    "Shift Hours",
                                    shiftHoursController,
                                    focusNode: _shiftHoursNode,
                                    nextFocus: _contractTypeNode,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(5),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                  SizedBox(width: 5.w),
                                  Expanded(child: _contractTypeDropdown()),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(child: _paymentMethodDropdown()),
                                  SizedBox(width: 5.w),
                                  _dialogField(
                                    "Advanced Payment Limit",
                                    advancedPaymentLimitController,
                                    focusNode: _advancedPaymentNode,
                                    nextFocus: _bankAccountNumberNode,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(5),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  _dialogField(
                                    "Bank Account Number",
                                    banckAccountNumberController,
                                    focusNode: _bankAccountNumberNode,
                                    nextFocus: _bankNameNode,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(16),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                  SizedBox(width: 5.w),
                                  _dialogField(
                                    "Bank Name",
                                    bankNameController,
                                    focusNode: _bankNameNode,
                                    nextFocus: _startContractDate,
                                  ),
                                ],
                              ),

                              Padding(
                                padding: EdgeInsets.only(
                                  left: 5.w,
                                  right: 5.w,
                                  bottom: 30.h,
                                ),
                                child: Divider(),
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    child: _startContractDatePicker(
                                      context,
                                      setDialogState,
                                    ),
                                  ),
                                  SizedBox(width: 5.w),
                                  Expanded(
                                    child: _endContractDatePicker(
                                      context,
                                      setDialogState,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                        : index == 3
                        ? Form(
                          key: _useraccountFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: _dialogField(
                                  "Email",
                                  emailController,
                                  focusNode: _emailNode,
                                  nextFocus: _accessRoleNode,
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: _accessRoleDropdown(),
                              ),
                              Row(
                                children: [
                                  Switch(
                                    value: medicaleInsurance,
                                    onChanged: (val) {
                                      setDialogState(() {
                                        medicaleInsurance = val;
                                      });
                                    },
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    'Medical Insurance',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 4.25.sp,
                                      color:
                                          medicaleInsurance
                                              ? Colors.purple
                                              : Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                'Enable this option if you want to include medical insurance.',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 3.5.sp,
                                  color: Colors.black26,
                                ),
                              ),
                              SizedBox(height: 15.h),
                              Row(
                                children: [
                                  Switch(
                                    value: isTaxable,
                                    onChanged: (val) {
                                      setDialogState(() {
                                        isTaxable = val;
                                      });
                                    },
                                  ),
                                  SizedBox(width: 1.w),

                                  Text(
                                    'Is Taxable',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 4.25.sp,
                                      color:
                                          isTaxable
                                              ? Colors.purple
                                              : Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.h),

                              Text(
                                'Enable this option if the account is subject to taxes.',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 3.5.sp,
                                  color: Colors.black26,
                                ),
                              ),
                            ],
                          ),
                        )
                        : Form(
                          key: _permissionFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Permisson Requests',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 4.25.sp,
                                  color: Colors.black45,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  Switch(
                                    value: permissionRequests,
                                    onChanged: (val) {
                                      setDialogState(() {
                                        permissionRequests = val;
                                      });
                                    },
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    'Override Department Settings',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 4.sp,
                                      color:
                                          medicaleInsurance
                                              ? Colors.purple
                                              : Colors.black26,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.h),
                              SizedBox(
                                width: 145.w,
                                height: 200.h,
                                child: CheckboxGrid3x3(
                                  permission: permissionRequests,
                                  values: [
                                    {'value': false, 'name': 'Sick Vacation'},
                                    {'value': false, 'name': 'Normal Vacation'},
                                    {'value': false, 'name': 'Unpaid Vacation'},
                                    {'value': false, 'name': 'Urgent Vacation'},
                                    {'value': false, 'name': 'Excuse'},
                                    {'value': false, 'name': 'Mission'},
                                    {'value': false, 'name': 'Work from Home'},
                                    {
                                      'value': false,
                                      'name': 'Checkin Approval',
                                    },
                                    {'value': false, 'name': 'Overtime'},
                                    {'value': false, 'name': 'Loan'},
                                    {'value': false, 'name': 'Unpaid Excuse'},
                                    {
                                      'value': false,
                                      'name': 'Advanced Payment',
                                    },
                                    {'value': false, 'name': 'Allowance'},
                                  ],
                                  onChanged: (values) {
                                    print(values);
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5.w,
                                  vertical: 15.h,
                                ),
                                child: Divider(),
                              ),

                              Text(
                                'Payslip Permissions',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 4.25.sp,
                                  color: Colors.black45,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  Switch(
                                    value: paylsipPermissions,
                                    onChanged: (val) {
                                      setDialogState(() {
                                        paylsipPermissions = val;
                                      });
                                    },
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    'Override Department Settings',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 4.sp,
                                      color:
                                          medicaleInsurance
                                              ? Colors.purple
                                              : Colors.black26,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.h),
                              SizedBox(
                                width: 145.w,
                                height: 35.h,
                                child: CheckboxGrid3x3(
                                  permission: paylsipPermissions,
                                  values: [
                                    {'value': false, 'name': 'Show Payslip'},
                                    {
                                      'value': false,
                                      'name': 'Show Payslip Details',
                                    },
                                  ],
                                  onChanged: (values) {
                                    print(values);
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5.w,
                                  vertical: 10.h,
                                ),
                                child: Divider(),
                              ),
                              Text(
                                'Excuse Limit',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 4.25.sp,
                                  color: Colors.black45,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  Switch(
                                    value: excuseLimit,
                                    onChanged: (val) {
                                      setDialogState(() {
                                        excuseLimit = val;
                                      });
                                    },
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    'Override Department Settings',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 4.sp,
                                      color:
                                          medicaleInsurance
                                              ? Colors.purple
                                              : Colors.black26,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 4.sp,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                if (index != 0)
                  ElevatedButton(
                    onPressed: () {
                      setDialogState(() {
                        if (index != 0) {
                          index--;
                        }
                      });
                    },
                    child: Text(
                      "Back",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 4.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),

                // ✅ SAVE BUTTON
                ElevatedButton(
                  onPressed: () {
                    setDialogState(() {
                      if (index != 4) {
                        index++;
                      }
                    });
                    if (index == 4) {
                      _saveEmployee(
                        dialogContext: dialogContext,
                        parentContext: parentContext,
                        setDialogState: setDialogState,
                        firstNameController: firstNameController,
                        lastNameController: lastNameController,
                        nationalIDController: nationalIDController,
                        dobb: selectedDob?.toIso8601String() ?? 'Undefined',
                        mobileController: mobileController,
                        additionalMobileController: additionalMobileController,
                        genderr: selectedGender ?? 'Undefined',
                        religionn: selectedReligion ?? 'Undefined',

                        employeeID: employeeIDController,
                        employeePosition: positionController,
                        department: selectedDepartment ?? 'Undefined',
                        branch: selectedBranch ?? 'Undefined',
                        location: selectedLocation ?? 'Undefined',
                        shiftType: selectedShift ?? 'Undefined',
                        schedule: selectedSchedule ?? "Undefined",
                        vacationStartDate:
                            selectedVacationStartDate?.toIso8601String() ??
                            'Undefined',
                        normalVacation: normalVacationController,
                        urgentVacation: urgentVacationController,
                        unpaidVacationBalance: unpaidVacationBalanceController,
                      );
                    }
                  },
                  child: Text(
                    index == 4 ? "Save" : "Next",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 4.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  int? _sortColumnIndex;
  bool _isAscending = true;
  // final GlobalKey<DesktopRefreshWrapperState> refreshKey2 =
  //     GlobalKey<DesktopRefreshWrapperState>();
  @override
  Widget build(BuildContext context) {
    final authprovider = context.watch<AuthProvider>();

    List<T> filteredData =
        _searchQuery.isEmpty
            ? [...widget.data]
            : widget.data.where((item) {
              if (widget.searchFilter != null) {
                return widget.searchFilter!(item, _searchQuery);
              } else {
                final values = widget.columns.map(
                  (col) => col.cellBuilder(item).toString().toLowerCase(),
                );
                return values.any(
                  (v) => v.contains(_searchQuery.toLowerCase()),
                );
              }
            }).toList();

    // 🔹 Apply sorting if active
    if (_sortColumnIndex != null) {
      final col = widget.columns[_sortColumnIndex!];
      filteredData.sort((a, b) {
        if (col.comparator != null) {
          return _isAscending ? col.comparator!(a, b) : -col.comparator!(a, b);
        } else {
          final va = col.cellBuilder(a);
          final vb = col.cellBuilder(b);
          return _isAscending
              ? va.toString().compareTo(vb.toString())
              : vb.toString().compareTo(va.toString());
        }
      });
    }

    return
    // DesktopRefreshWrapper(
    //   key: refreshKey2,
    //   onRefresh: () async {
    //     if (!mounted) return; // ensures widget still in tree
    //     await customer.refresh();
    //   },
    //   child:
    LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: widget.padding ?? const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: widget.elevation,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.title != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.title!,
                            style:
                                widget.titleStyle ??
                                Theme.of(context).textTheme.titleMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          EditButton(
                            onPressed: () {
                              // refreshKey2.currentState?.triggerRefresh();
                            },
                            icon: Icon(
                              Icons.refresh,
                              color: Colors.white,
                              size: 4.sp,
                            ),
                            text: "Refresh",
                            width: 60.w, // Adjust width as you like
                            height: 25.h, //
                          ),
                          SizedBox(width: 3.w),
                          EditButton(
                            onPressed: () {
                              setState(() {
                                index = 0;
                              });
                              showAddEmployeeDialog(
                                provider: authprovider,
                                context: context,
                              );
                            },
                            icon: Icon(
                              Icons.person_add,
                              color: Colors.white,
                              size: 4.sp,
                            ),
                            text: 'Create New Employee',
                            width: 60.w, // Adjust width as you like
                            height: 25.h, //
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 10),
              // customer.refreshing
              // ? SizedBox()
              // :
              // 🔍 Search bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Neumorphic(
                    padding: EdgeInsets.all(0),
                    margin: EdgeInsets.all(0),
                    style: NeumorphicStyle(
                      color: Colors.white,
                      depth: -6,
                      boxShape: NeumorphicBoxShape.roundRect(
                        BorderRadius.circular(500),
                      ),
                      intensity: 0.8,
                    ),
                    child: _buildSearchBar(),
                  ),

                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: ClickableDataWidget(
                      id: 0,
                      text: "Total Employees :",
                      // index: customer.index,
                      index: 0,
                      // role: role,
                      // count: customer.customers!.data!.length,
                      count: 0,
                      // onTap: () => customer.setIndex(0),
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: ClickableDataWidget(
                      id: 1,
                      text: "Total Due Balance :",
                      // index: customer.index,
                      index: 0,
                      // count: customer.getTotalBalance(),
                      count: 0,
                      // onTap: () => customer.setIndex(1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // customer.refreshing
              //     ? SizedBox()
              //     :
              // 📊 Table
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Table(
                        border:
                            widget.showBorders
                                ? TableBorder.all(
                                  color:
                                      widget.borderColor ??
                                      Colors.grey.shade300,
                                  width: widget.borderWidth ?? 1,
                                )
                                : TableBorder.symmetric(),
                        columnWidths: {
                          for (int i = 0; i < widget.columns.length; i++)
                            i: const IntrinsicColumnWidth(),
                        },
                        children: [
                          // 🔹 Header Row (sortable)
                          TableRow(
                            decoration: BoxDecoration(
                              color: widget.headerColor ?? Colors.grey.shade200,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15.r),
                                topRight: Radius.circular(15.r),
                              ),
                            ),
                            children: [
                              for (int i = 0; i < widget.columns.length; i++)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (_sortColumnIndex == i) {
                                        _isAscending = !_isAscending;
                                      } else {
                                        _sortColumnIndex = i;
                                        _isAscending = true;
                                      }
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                      widget.columnSpacing ?? 12,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            widget.columns[i].label,
                                            textAlign:
                                                widget.columns[i].alignment ??
                                                TextAlign.left,
                                            style:
                                                widget.headerStyle ??
                                                const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                        if (_sortColumnIndex == i)
                                          Icon(
                                            _isAscending
                                                ? Icons.arrow_upward
                                                : Icons.arrow_downward,
                                            size: 16,
                                            color: Colors.black54,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          // 🔹 Rows
                          ...List.generate(filteredData.length, (index) {
                            final item = filteredData[index];
                            final isEven = index.isEven;
                            return TableRow(
                              decoration: BoxDecoration(
                                color:
                                    isEven
                                        ? (widget.evenRowColor ??
                                            Colors.grey.shade50)
                                        : (widget.oddRowColor ?? Colors.white),
                              ),
                              children:
                                  widget.columns.map((col) {
                                    final value = col.cellBuilder(item);
                                    return MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        onTap: () {
                                          // _foundCustomer = customer
                                          //     .toJson(item as Customer);
                                          // showUpdateCustomerDialog(
                                          //   context: context,
                                          //   provider: customer,
                                          //   customer: _foundCustomer!,
                                          //   isArabic: widget.isArabic,
                                          // );
                                          // setState(() {});
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                            widget.columnSpacing ?? 12,
                                          ),
                                          child:
                                              value is Widget
                                                  ? value
                                                  : Text(
                                                    value.toString(),
                                                    textAlign:
                                                        col.alignment ??
                                                        TextAlign.left,
                                                    style:
                                                        widget.cellStyle ??
                                                        const TextStyle(
                                                          color: Colors.black87,
                                                        ),
                                                  ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    // );
  }

  Widget _buildSearchBar() {
    return Container(
      height: widget.searchHeight,
      width: widget.searchWidth,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        color: widget.searchBackgroundColor ?? Colors.grey[100],
        borderRadius: widget.searchBorderRadius ?? BorderRadius.circular(10),
        border: Border.all(
          color: widget.searchBorderColor ?? Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            widget.searchIcon,
            color: widget.searchIconColor ?? Colors.grey[700],
            size: widget.searchIconSize,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              style: widget.searchTextStyle ?? const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(fontFamily: "Poppins", fontSize: 4.sp),
                border: InputBorder.none,
                isDense: true,
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _dialogField(
  String label,
  TextEditingController controller, {
  FocusNode? focusNode,
  FocusNode? nextFocus,
  Widget? prefix,
  Function(String)? onChanged,
  void Function()? onSubmittedLast,
  String? Function(String?)? validator,
  List<TextInputFormatter>? inputFormatters,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 15.h),
    child: SizedBox(
      width: 75.w,
      height: 50.h,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 3.5.sp,
          color: Colors.black,
        ),

        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 3.5.sp,
            color: Colors.black26,
          ),
          prefixIcon: prefix,
          // ✅ Normal Border
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.black12, // ✅ default color
              width: 1.2, // ✅ thickness
            ),
          ),

          // ✅ Focused Border (when typing)
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Colors.purple, // ✅ focus color
              width: 1.2, // ✅ thicker on focus
            ),
          ),

          // ✅ Error Border (validation error)
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),

          // ✅ Focused Error Border
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 5.w),
        ),
        onChanged: onChanged,
        textInputAction:
            nextFocus != null ? TextInputAction.next : TextInputAction.done,
        onFieldSubmitted: (_) {
          if (nextFocus != null) {
            FocusScope.of(focusNode!.context!).requestFocus(nextFocus);
          } else {
            if (onSubmittedLast != null) onSubmittedLast();
          }
        },
        validator: validator,
        inputFormatters: inputFormatters,
      ),
    ),
  );
}

Widget stepProgressRow({
  required List<String> steps,
  required int currentStep, // 0-based index of the active step
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: List.generate(steps.length * 2 - 1, (index) {
      if (index.isEven) {
        final stepIndex = index ~/ 2;
        final isActive = stepIndex == currentStep;
        final isCompleted = stepIndex < currentStep;

        return Container(
          // margin: EdgeInsets.only(right: index == 5 ? 0 : 1.w),
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 8.h),
          decoration: BoxDecoration(
            color:
                isCompleted
                    ? Colors.purple
                    : isActive
                    ? Colors.white
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            steps[stepIndex],
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 3.5.sp,
              fontWeight:
                  isActive || isCompleted ? FontWeight.w600 : FontWeight.normal,
              color:
                  isCompleted
                      ? Colors.white
                      : isActive
                      ? Colors.purple
                      : Colors.white30,
            ),
          ),
        );
      } else {
        // Line between steps
        // final prevStep = index ~/ 2;
        // final isCompleted = prevStep < currentStep;

        return SizedBox.shrink();
        // Expanded(
        //   child: Container(
        //     height: 2.h,
        //     margin: EdgeInsets.symmetric(horizontal: 1.w),
        //     color: isCompleted ? Colors.purple : Colors.white30,
        //   ),
        // );
      }
    }),
  );
}
