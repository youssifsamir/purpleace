// ignore_for_file: no_leading_underscores_for_local_identifiers, deprecated_member_use

// packages
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showUpdateBranchDialog({
  required BuildContext context,
  required List<String> roles,
  required List<Map<String, dynamic>> branches,
  required String? branchname,
  required String? phonenumber,
  required num? servicerate,
  required num? deliveryrate,
  required String? branchaddress,
  String? notes,
  required void Function({
    required String branchname,
    required String phonenumber,
    required num servicerate,
    required num deliveryrate,
    required String branchaddress,
    required int resturantID,
    String? notes,
  })
  onSubmit,
}) async {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController branchnameController = TextEditingController();
  final TextEditingController servicerateController = TextEditingController();
  final TextEditingController deliveryrateController = TextEditingController();
  final TextEditingController branchaddressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  branchnameController.text = branchname ?? '';
  servicerateController.text = servicerate.toString();
  deliveryrateController.text = deliveryrate.toString();
  branchaddressController.text = branchaddress ?? '';
  phoneController.text = phonenumber ?? '';
  notesController.text = notes ?? '';

  await showDialog(
    context: context,
    builder: (context) {
      final colorScheme = Theme.of(context).colorScheme;

      InputDecoration _buildInputDecoration(String label) {
        return InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontFamily: 'Poppins',
            // color: colorScheme.primary,
            color: Colors.black26,
            fontSize: 4.sp,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
        );
      }

      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Update Branch Details',
          style: TextStyle(
            fontFamily: 'PoppinsSemiBold',
            color: Colors.black,
            fontSize: 7.sp,
          ),
        ),
        content: SizedBox(
          width: 150.w,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// 🧍‍♂️ Name + 📱 Phone side by side
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50.h,
                          child: TextFormField(
                            controller: branchnameController,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                              fontSize: 4.sp,
                            ),
                            maxLines: 1,
                            decoration: _buildInputDecoration('Branch Name'),
                            validator:
                                (v) =>
                                    v == null || v.isEmpty
                                        ? 'Please enter a name'
                                        : null,
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: SizedBox(
                          height: 50.h,
                          // width: 100.w,
                          child: TextFormField(
                            controller: phoneController,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                              fontSize: 4.sp,
                            ),
                            decoration: _buildInputDecoration('Phone Number'),
                            keyboardType: TextInputType.phone,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Please enter a phone number';
                              } else if (!RegExp(r'^\d{11}$').hasMatch(v)) {
                                return 'Phone number must be 11 digits';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 15.h),
                  SizedBox(
                    height: 50.h,
                    child: TextFormField(
                      controller: branchaddressController,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        fontSize: 4.sp,
                      ),
                      maxLines: 1,
                      decoration: _buildInputDecoration('Branch Address'),
                      validator:
                          (v) =>
                              v == null || v.isEmpty
                                  ? 'Please enter an address'
                                  : null,
                    ),
                  ),

                  SizedBox(height: 15.h),

                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50.h,
                          // width: 100.w,
                          child: TextFormField(
                            controller: servicerateController,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                              fontSize: 4.sp,
                            ),
                            decoration: _buildInputDecoration('Service Rate'),
                            keyboardType: TextInputType.phone,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Please enter a phone number';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: SizedBox(
                          height: 50.h,
                          // width: 100.w,
                          child: TextFormField(
                            controller: deliveryrateController,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                              fontSize: 4.sp,
                            ),
                            decoration: _buildInputDecoration('Delivery Rate'),
                            keyboardType: TextInputType.phone,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Please enter a phone number';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 15.h),

                  /// 📝 Notes (Optional)
                  SizedBox(
                    height: 85.h,
                    child: TextFormField(
                      controller: notesController,
                      maxLines: null,
                      expands: true,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        fontSize: 4.sp,
                      ),
                      decoration: _buildInputDecoration('Notes (optional)'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actionsPadding: EdgeInsets.only(
          left: 12.w,
          right: 12.w,
          bottom: 20.h,
          top: 10.h,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 6.sp,
                    fontFamily: 'RalewayMid',
                    color: Colors.grey[700],
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 15.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    onSubmit(
                      resturantID: 1,
                      branchname: branchnameController.text.trim(),
                      phonenumber: phoneController.text.trim(),
                      branchaddress: branchaddressController.text.trim(),
                      servicerate: double.parse(
                        servicerateController.text.trim(),
                      ),
                      deliveryrate: double.parse(
                        deliveryrateController.text.trim(),
                      ),
                      notes:
                          notesController.text.trim().isEmpty
                              ? null
                              : notesController.text.trim(),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'Update',
                  style: TextStyle(
                    fontSize: 6.sp,
                    fontFamily: 'RalewayMid',
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
