// // lib/models/user_model.dart
// class UserModel {
//   final String uid,
//       firstName,
//       lastName,
//       profileImage,
//       nationalID,
//       phoneNumber,
//       additionalPhoneNo,
//       gender,
//       dob,
//       religion,
//       // cv,
//       employeeID,
//       position,
//       branch,
//       department,
//       location,
//       shiftType,
//       schedule,
//       parentManager,
//       fingerprintID,
//       vacationStartDate,
//       username,
//       email,
//       joinDate,
//       effectiveSalaryDate,
//       currency,
//       contractType,
//       paymentMethod,
//       bankAccoutnNumber,
//       bankName,
//       startContractDate,
//       endContractDate,
//       accessRole;

//   final double unpaidVacationBalace, advancePaymentLimit;
//   final int normalVacation,
//       urgentVacation,
//       grossSalary,
//       newGrossSalary,
//       insuranceSalary,
//       otherExemption,
//       shiftHours;
//   final bool isTaxable,
//       medicalInsurance,
//       overridePermissionDepartmentSettings,
//       sickVacationPermission,
//       urgentVacationPermission,
//       unpaidVacationPermission,
//       missionPermission,
//       overtimePermission,
//       advancedPaymentPermission,
//       upaidExcusePermission,
//       checkinApprovalPermission,
//       excusePermission,
//       allowancePermission,
//       workFromHomePermission,
//       payslipSettings,
//       showPayslipPermission,
//       showPayslipDetailsPermission,
//       excuseLimitSettings,
//       overrideExcuseDepartmentSettings;

//   UserModel(
//     this.nationalID,
//     this.additionalPhoneNo,
//     this.gender,
//     this.dob,
//     this.religion,
//     this.employeeID,
//     this.position,
//     this.branch,
//     this.location,
//     this.shiftType,
//     this.schedule,
//     this.parentManager,
//     this.fingerprintID,
//     this.vacationStartDate,
//     this.joinDate,
//     this.effectiveSalaryDate,
//     this.currency,
//     this.contractType,
//     this.paymentMethod,
//     this.bankAccoutnNumber,
//     this.bankName,
//     this.startContractDate,
//     this.endContractDate,
//     this.accessRole,
//     this.unpaidVacationBalace,
//     this.advancePaymentLimit,
//     this.normalVacation,
//     this.urgentVacation,
//     this.grossSalary,
//     this.newGrossSalary,
//     this.insuranceSalary,
//     this.otherExemption,
//     this.shiftHours,
//     this.isTaxable,
//     this.medicalInsurance,
//     this.overridePermissionDepartmentSettings,
//     this.sickVacationPermission,
//     this.urgentVacationPermission,
//     this.unpaidVacationPermission,
//     this.missionPermission,
//     this.overtimePermission,
//     this.advancedPaymentPermission,
//     this.upaidExcusePermission,
//     this.checkinApprovalPermission,
//     this.excusePermission,
//     this.allowancePermission,
//     this.workFromHomePermission,
//     this.payslipSettings,
//     this.showPayslipPermission,
//     this.showPayslipDetailsPermission,
//     this.excuseLimitSettings,
//     this.overrideExcuseDepartmentSettings, {
//     required this.uid,
//     required this.username,
//     required this.email,
//     required this.firstName,
//     required this.lastName,
//     required this.department,
//     this.profileImage = '',
//     this.phoneNumber = '',
//   });

//   factory UserModel.fromMap(Map<String, dynamic> map) {
//     return UserModel(
//       firstName: map['firstName'],
//       lastName: map['lastName'],
//       uid: map['uid'] ?? '',
//       username: map['username'] ?? '',
//       email: map['email'] ?? '',
//       department: map['department'] ?? '',
//       profileImage: map['profileImage'] ?? '',
//       phoneNumber: map['phoneNumber'] ?? '',
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'uid': uid,
//       'username': username,
//       'firstName': firstName,
//       'address': address,
//       'lastName': lastName,
//       'email': email,
//       'role': role,
//       'department': department,
//       'profileImage': profileImage,
//       'phoneNumber': phoneNumber,
//     };
//   }
// }

// personal_info.dart
class PersonalInfo {
  final String firstName;
  final String lastName;
  final String profileImage;
  final String nationalID;
  final String phoneNumber;
  final String additionalPhoneNo;
  final String gender;
  final DateTime? dob;
  final String religion;

  PersonalInfo({
    required this.firstName,
    required this.lastName,
    this.profileImage = '',
    this.nationalID = '',
    this.phoneNumber = '',
    this.additionalPhoneNo = '',
    this.gender = '',
    this.dob,
    this.religion = '',
  });

  factory PersonalInfo.fromMap(Map<String, dynamic> map) {
    return PersonalInfo(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      profileImage: map['profileImage'] ?? '',
      nationalID: map['nationalID'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      additionalPhoneNo: map['additionalPhoneNo'] ?? '',
      gender: map['gender'] ?? '',
      dob: map['dob'] != null ? DateTime.parse(map['dob']) : null,
      religion: map['religion'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'firstName': firstName,
    'lastName': lastName,
    'profileImage': profileImage,
    'nationalID': nationalID,
    'phoneNumber': phoneNumber,
    'additionalPhoneNo': additionalPhoneNo,
    'gender': gender,
    'dob': dob?.toIso8601String(),
    'religion': religion,
  };
}

// work_info.dart
class WorkInfo {
  final String employeeID;
  final String position;
  final String branch;
  final String department;
  final String location;
  final String shiftType;
  final String schedule;
  final String parentManager;
  final String fingerprintID;
  final DateTime? vacationStartDate;
  final double unpaidVacationBalance;
  final int normalVacation;
  final int urgentVacation;

  WorkInfo({
    this.employeeID = '',
    this.position = '',
    this.branch = '',
    this.department = '',
    this.location = '',
    this.shiftType = '',
    this.schedule = '',
    this.parentManager = '',
    this.fingerprintID = '',
    this.vacationStartDate,
    this.unpaidVacationBalance = 0.0,
    this.normalVacation = 0,
    this.urgentVacation = 0,
  });

  factory WorkInfo.fromMap(Map<String, dynamic> map) {
    return WorkInfo(
      employeeID: map['employeeID'] ?? '',
      position: map['position'] ?? '',
      branch: map['branch'] ?? '',
      department: map['department'] ?? '',
      location: map['location'] ?? '',
      shiftType: map['shiftType'] ?? '',
      schedule: map['schedule'] ?? '',
      parentManager: map['parentManager'] ?? '',
      fingerprintID: map['fingerprintID'] ?? '',
      vacationStartDate:
          map['vacationStartDate'] != null
              ? DateTime.parse(map['vacationStartDate'])
              : null,
      unpaidVacationBalance: map['unpaidVacationBalance']?.toDouble() ?? 0.0,
      normalVacation: map['normalVacation'] ?? 0,
      urgentVacation: map['urgentVacation'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'employeeID': employeeID,
    'position': position,
    'branch': branch,
    'department': department,
    'location': location,
    'shiftType': shiftType,
    'schedule': schedule,
    'parentManager': parentManager,
    'fingerprintID': fingerprintID,
    'vacationStartDate': vacationStartDate?.toIso8601String(),
    'unpaidVacationBalance': unpaidVacationBalance,
    'normalVacation': normalVacation,
    'urgentVacation': urgentVacation,
  };
}

// contact_info.dart
class ContactInfo {
  final DateTime? joinDate;
  final double grossSalary;
  final double newGrossSalary;
  final double insuranceSalary;
  final double otherExemption;
  final int shiftHours;
  final DateTime? effectiveSalaryDate;
  final String currency;
  final String contractType;
  final String paymentMethod;
  final String bankAccountNumber;
  final String bankName;
  final DateTime? startContractDate;
  final DateTime? endContractDate;

  ContactInfo({
    this.joinDate,
    this.grossSalary = 0,
    this.newGrossSalary = 0,
    this.insuranceSalary = 0,
    this.otherExemption = 0,
    this.shiftHours = 0,
    this.effectiveSalaryDate,
    this.currency = '',
    this.contractType = '',
    this.paymentMethod = '',
    this.bankAccountNumber = '',
    this.bankName = '',
    this.startContractDate,
    this.endContractDate,
  });

  factory ContactInfo.fromMap(Map<String, dynamic> map) {
    return ContactInfo(
      joinDate:
          map['joinDate'] != null ? DateTime.parse(map['joinDate']) : null,
      grossSalary: map['grossSalary']?.toDouble() ?? 0,
      newGrossSalary: map['newGrossSalary']?.toDouble() ?? 0,
      insuranceSalary: map['insuranceSalary']?.toDouble() ?? 0,
      otherExemption: map['otherExemption']?.toDouble() ?? 0,
      shiftHours: map['shiftHours'] ?? 0,
      effectiveSalaryDate:
          map['effectiveSalaryDate'] != null
              ? DateTime.parse(map['effectiveSalaryDate'])
              : null,
      currency: map['currency'] ?? '',
      contractType: map['contractType'] ?? '',
      paymentMethod: map['paymentMethod'] ?? '',
      bankAccountNumber: map['bankAccountNumber'] ?? '',
      bankName: map['bankName'] ?? '',
      startContractDate:
          map['startContractDate'] != null
              ? DateTime.parse(map['startContractDate'])
              : null,
      endContractDate:
          map['endContractDate'] != null
              ? DateTime.parse(map['endContractDate'])
              : null,
    );
  }

  Map<String, dynamic> toMap() => {
    'joinDate': joinDate?.toIso8601String(),
    'grossSalary': grossSalary,
    'newGrossSalary': newGrossSalary,
    'insuranceSalary': insuranceSalary,
    'otherExemption': otherExemption,
    'shiftHours': shiftHours,
    'effectiveSalaryDate': effectiveSalaryDate?.toIso8601String(),
    'currency': currency,
    'contractType': contractType,
    'paymentMethod': paymentMethod,
    'bankAccountNumber': bankAccountNumber,
    'bankName': bankName,
    'startContractDate': startContractDate?.toIso8601String(),
    'endContractDate': endContractDate?.toIso8601String(),
  };
}

// user_account.dart
class UserAccount {
  final String role;
  final String email;
  final bool medicalInsurance;
  final bool isTaxable;

  UserAccount({
    this.role = '',
    this.email = '',
    this.medicalInsurance = false,
    this.isTaxable = false,
  });

  factory UserAccount.fromMap(Map<String, dynamic> map) {
    return UserAccount(
      role: map['role'] ?? '',
      email: map['email'] ?? '',
      medicalInsurance: map['medicalInsurance'] ?? false,
      isTaxable: map['isTaxable'] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
    'role': role,
    'email': email,
    'medicalInsurance': medicalInsurance,
    'isTaxable': isTaxable,
  };
}

// permissions.dart
class Permissions {
  final bool overridePermissionDepartmentSettings;
  final bool sickVacationPermission;
  final bool urgentVacationPermission;
  final bool unpaidVacationPermission;
  final bool missionPermission;
  final bool overtimePermission;
  final bool advancedPaymentPermission;
  final bool unpaidExcusePermission;
  final bool checkinApprovalPermission;
  final bool excusePermission;
  final bool allowancePermission;
  final bool workFromHomePermission;
  final bool payslipSettings;
  final bool showPayslipPermission;
  final bool showPayslipDetailsPermission;
  final bool excuseLimitSettings;
  final bool overrideExcuseDepartmentSettings;

  Permissions({
    this.overridePermissionDepartmentSettings = false,
    this.sickVacationPermission = false,
    this.urgentVacationPermission = false,
    this.unpaidVacationPermission = false,
    this.missionPermission = false,
    this.overtimePermission = false,
    this.advancedPaymentPermission = false,
    this.unpaidExcusePermission = false,
    this.checkinApprovalPermission = false,
    this.excusePermission = false,
    this.allowancePermission = false,
    this.workFromHomePermission = false,
    this.payslipSettings = false,
    this.showPayslipPermission = false,
    this.showPayslipDetailsPermission = false,
    this.excuseLimitSettings = false,
    this.overrideExcuseDepartmentSettings = false,
  });

  factory Permissions.fromMap(Map<String, dynamic> map) {
    return Permissions(
      overridePermissionDepartmentSettings:
          map['overridePermissionDepartmentSettings'] ?? false,
      sickVacationPermission: map['sickVacationPermission'] ?? false,
      urgentVacationPermission: map['urgentVacationPermission'] ?? false,
      unpaidVacationPermission: map['unpaidVacationPermission'] ?? false,
      missionPermission: map['missionPermission'] ?? false,
      overtimePermission: map['overtimePermission'] ?? false,
      advancedPaymentPermission: map['advancedPaymentPermission'] ?? false,
      unpaidExcusePermission: map['unpaidExcusePermission'] ?? false,
      checkinApprovalPermission: map['checkinApprovalPermission'] ?? false,
      excusePermission: map['excusePermission'] ?? false,
      allowancePermission: map['allowancePermission'] ?? false,
      workFromHomePermission: map['workFromHomePermission'] ?? false,
      payslipSettings: map['payslipSettings'] ?? false,
      showPayslipPermission: map['showPayslipPermission'] ?? false,
      showPayslipDetailsPermission:
          map['showPayslipDetailsPermission'] ?? false,
      excuseLimitSettings: map['excuseLimitSettings'] ?? false,
      overrideExcuseDepartmentSettings:
          map['overrideExcuseDepartmentSettings'] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
    'overridePermissionDepartmentSettings':
        overridePermissionDepartmentSettings,
    'sickVacationPermission': sickVacationPermission,
    'urgentVacationPermission': urgentVacationPermission,
    'unpaidVacationPermission': unpaidVacationPermission,
    'missionPermission': missionPermission,
    'overtimePermission': overtimePermission,
    'advancedPaymentPermission': advancedPaymentPermission,
    'unpaidExcusePermission': unpaidExcusePermission,
    'checkinApprovalPermission': checkinApprovalPermission,
    'excusePermission': excusePermission,
    'allowancePermission': allowancePermission,
    'workFromHomePermission': workFromHomePermission,
    'payslipSettings': payslipSettings,
    'showPayslipPermission': showPayslipPermission,
    'showPayslipDetailsPermission': showPayslipDetailsPermission,
    'excuseLimitSettings': excuseLimitSettings,
    'overrideExcuseDepartmentSettings': overrideExcuseDepartmentSettings,
  };
}

class UserModel {
  final String uid;
  final String username;

  final PersonalInfo personalInfo;
  final WorkInfo workInfo;
  final ContactInfo contactInfo;
  final UserAccount userAccount;
  final Permissions permissions;

  UserModel({
    required this.uid,
    required this.username,
    required this.personalInfo,
    required this.workInfo,
    required this.contactInfo,
    required this.userAccount,
    required this.permissions,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      personalInfo: PersonalInfo.fromMap(map),
      workInfo: WorkInfo.fromMap(map),
      contactInfo: ContactInfo.fromMap(map),
      userAccount: UserAccount.fromMap(map),
      permissions: Permissions.fromMap(map),
    );
  }

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'username': username,
    ...personalInfo.toMap(),
    ...workInfo.toMap(),
    ...contactInfo.toMap(),
    ...userAccount.toMap(),
    ...permissions.toMap(),
  };
}
