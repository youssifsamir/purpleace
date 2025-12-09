// ignore_for_file: must_be_immutable, deprecated_member_use, avoid_print

// packages
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// widgets
import '/widgets/storyboard/customcard.dart';

class CardDetailsDialog extends StatefulWidget {
  String title, description, bucket, listtitle;
  DateTime? plannedDate;
  List<dynamic> assignees;
  List<CardLabel> labels;
  int attachments;
  Color bucketcolor;

  CardDetailsDialog({
    super.key,
    required this.title,
    required this.listtitle,
    required this.bucket,
    required this.bucketcolor,
    required this.description,
    this.plannedDate,
    this.assignees = const [],
    this.labels = const [],
    this.attachments = 0,
  });

  @override
  State<CardDetailsDialog> createState() => _CardDetailsDialogState();
}

class _CardDetailsDialogState extends State<CardDetailsDialog> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController commentController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    descriptionController = TextEditingController(text: widget.description);
    commentController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    commentController.dispose();
    super.dispose();
  }

  void saveChanges() {
    setState(() {
      widget.title = titleController.text;
      widget.description = descriptionController.text;
    });
    Navigator.pop(context, {
      'title': widget.title,
      'description': widget.description,
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      insetPadding: EdgeInsets.only(top: 20.h, left: 10.w, right: 10.w),
      child: Container(
        width: screenWidth * 0.85,
        height: screenHeight * 0.9,
        padding: EdgeInsets.only(top: 20.h, left: 10.w, right: 10.w),
        child: Column(
          children: [
            // === TOP BAR ===
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${widget.listtitle} List',
                    textScaler: TextScaler.noScaling,
                    style: TextStyle(
                      fontFamily: 'PoppinsMid',
                      fontSize: (12.sp).clamp(12, 30),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_active_outlined),
                  tooltip: "Send Notification",
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert),
                  tooltip: "Menu",
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  tooltip: "Close",
                ),
              ],
            ),

            SizedBox(height: 20.h),
            Divider(color: Colors.black12, height: 1),

            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // === LEFT SIDE: Card Details ===
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20.h),

                          // Title + Checkbox
                          Row(
                            children: [
                              Checkbox(value: false, onChanged: (val) {}),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      '${widget.bucket.toUpperCase()} : ',
                                      textScaler: TextScaler.noScaling,
                                      style: TextStyle(
                                        fontFamily: 'RalewayBold',
                                        color: widget.bucketcolor,
                                        fontSize: (10.sp).clamp(12, 50),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: titleController,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Card Title",
                                          hintStyle: TextStyle(
                                            fontFamily: 'RalewayBold',
                                          ),
                                        ),

                                        style: TextStyle(
                                          fontFamily: 'RalewayBold',
                                          fontSize: (10.sp).clamp(12, 50),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Action buttons
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  foregroundColor: Colors.white,
                                  // minimumSize: Size(
                                  //   120,
                                  //   50,
                                  // ), // Width and height
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5.w,
                                    vertical: 5.h,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.r),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.new_label_rounded,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      "Label",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 4.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 2.w),
                              ElevatedButton(
                                onPressed: () {
                                  print('okkk');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  foregroundColor: Colors.white,
                                  // minimumSize: Size(
                                  //   120,
                                  //   50,
                                  // ), // Width and height
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5.w,
                                    vertical: 5.h,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.r),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.attach_file_rounded,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      "Attach",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 4.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 2.w),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  foregroundColor: Colors.white,
                                  // minimumSize: Size(
                                  //   120,
                                  //   50,
                                  // ), // Width and height
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5.w,
                                    vertical: 5.h,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.r),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.checklist_rounded,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      "Checklist",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 4.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 3.w),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Assignees + Due Date
                          Row(
                            children: [
                              // Assignees Column
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Assignees",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 4.sp,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Wrap(
                                    spacing: 4,
                                    children: [
                                      ...widget.assignees.map(
                                        (assignee) => CircleAvatar(
                                          radius: 16,
                                          child: Text(
                                            assignee[0].toUpperCase(),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: CircleAvatar(
                                          radius: 16,
                                          child: const Icon(Icons.add),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(width: 10.w),
                              // Due Date
                              // if (widget.plannedDate != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Due Date",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 4.sp,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    style: TextStyle(
                                      fontFamily: 'PoppinsSemiBold',
                                      fontSize: 4.sp,
                                    ),
                                    'Nov 4, 12:30 PM',
                                    // DateFormat(
                                    //   'dd MMM yyyy',
                                    // ).format(widget.plannedDate!),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 30.h),

                          // Description
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.description_outlined),
                                      SizedBox(width: 1.w),
                                      Text(
                                        "Description",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 5.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              TextField(
                                controller: descriptionController,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 4.sp,
                                ),
                                maxLines: null,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 5.w),

                  // === RIGHT SIDE: Comments & History ===
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          bottom: 0,
                          left: 0,
                          child: Container(
                            width: 2.w,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Colors.black12, Colors.transparent],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 7.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20.h),

                              Row(
                                children: [
                                  Icon(Icons.message_outlined),
                                  SizedBox(width: 2.w),
                                  Text(
                                    "Comments & Activity",
                                    style: TextStyle(
                                      fontFamily: 'PoppinsMid',
                                      fontSize: 5.sp,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              // Comment input
                              TextField(
                                controller: commentController,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.black,
                                  fontSize: 4.sp,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Write a comment...",
                                  hintStyle: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 4.sp,
                                    color: Colors.black26,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 30.h),
                              // Comment & history scroll section
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      CommentWidget(
                                        username: "jdevelops admin",
                                        avatarUrl: "",
                                        comment:
                                            "This is a sample comment that can extend to multiple lines as needed.",
                                        date: DateTime.now(),
                                      ),
                                      const SizedBox(height: 16),
                                      HistoryWidget(
                                        username: "jdevelops admin",
                                        avatarUrl: "",
                                        action: "Created this card",
                                        date: DateTime.now(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // const SizedBox(height: 16),
            // Align(
            //   alignment: Alignment.bottomRight,
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       TextButton(
            //         onPressed: () => Navigator.pop(context),
            //         child: Text(
            //           "Cancel",

            //           style: TextStyle(
            //             fontFamily: 'PoppinsMid',
            //             fontSize: 6.sp,
            //           ),
            //         ),
            //       ),
            //       SizedBox(width: 10.w),
            //       ElevatedButton(
            //         onPressed: saveChanges,
            //         child: Text(
            //           "Save",
            //           style: TextStyle(
            //             fontFamily: 'PoppinsMid',
            //             fontSize: 6.sp,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

/// === COMMENT WIDGET ===
class CommentWidget extends StatelessWidget {
  final String username;
  final String avatarUrl;
  final String comment;
  final DateTime date;

  const CommentWidget({
    super.key,
    required this.username,
    required this.avatarUrl,
    required this.comment,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage:
                  avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
              child: avatarUrl.isEmpty ? Text(username[0] + username[1]) : null,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        username,
                        style: TextStyle(
                          fontFamily: 'PoppinsSemiBold',
                          fontSize: 4.sp,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        DateFormat('dd MMM yyyy hh:mm a').format(date),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    comment,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 4.sp,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "React",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 4.sp,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Reply",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 4.sp,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Delete",

                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 4.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// === HISTORY WIDGET ===
class HistoryWidget extends StatelessWidget {
  final String username;
  final String avatarUrl;
  final String action;
  final DateTime date;

  const HistoryWidget({
    super.key,
    required this.username,
    required this.avatarUrl,
    required this.action,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundImage:
              avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
          child: avatarUrl.isEmpty ? Text(username[0] + username[1]) : null,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: username,
                      style: TextStyle(
                        fontFamily: 'PoppinsSemiBold',
                        fontSize: 4.sp,
                      ),
                    ),

                    TextSpan(
                      text: " $action",
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 4.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                DateFormat('dd MMM yyyy hh:mm a').format(date),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
