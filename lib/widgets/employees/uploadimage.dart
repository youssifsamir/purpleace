// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages, unused_field

// packages
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

// widgets
// import '/widgets/components/snackbar.dart';

class DesktopImageUploader extends StatefulWidget {
  final String folderName;
  const DesktopImageUploader({super.key, required this.folderName});

  @override
  State<DesktopImageUploader> createState() => DesktopImageUploaderState();
}

class DesktopImageUploaderState extends State<DesktopImageUploader> {
  File? _selectedImage;
  File? _compressedImage;
  String? _uploadedUrl;
  bool _isProcessing = false;
  bool _isUploading = false;

  Future<void> _pickAndCompressImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
      );

      if (result == null || result.files.single.path == null) return;

      final file = File(result.files.single.path!);
      setState(() {
        _isProcessing = true;
        _selectedImage = file;
      });

      final dir = await getTemporaryDirectory();
      final targetPath = path.join(
        dir.path,
        "${DateTime.now().millisecondsSinceEpoch}.png",
      );

      // Compress image
      final xCompressedFile = await FlutterImageCompress.compressAndGetFile(
        _selectedImage!.path,
        targetPath,
        format: CompressFormat.png,
        quality: 100,
        // quality: 15,
        minWidth: 800,
        minHeight: 800,
      );

      if (xCompressedFile == null) return;

      _compressedImage = File(xCompressedFile.path);
    } catch (e) {
      // showTopSnackbar(
      //   context,
      //   widget.isArabic
      //       ? "فشل في تحميل الصورة : $e"
      //       : "Failed to select image : $e",
      //   2,
      // );
      // print("Error picking/compressing image: $e");
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<String?> uploadImage(String name) async {
    if (_compressedImage == null) return null;

    try {
      setState(() => _isUploading = true);

      final fileName = path.basename(_compressedImage!.path);
      final ref = FirebaseStorage.instance
          .ref()
          .child(widget.folderName)
          .child(fileName);

      await ref.putFile(_compressedImage!);

      final url = await ref.getDownloadURL();
      setState(() => _uploadedUrl = url);

      return url;
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,

      child: GestureDetector(
        onTap: _isProcessing ? null : _pickAndCompressImage,
        child:
            _isProcessing
                ? const CircularProgressIndicator(
                  color: Colors.purple,
                  strokeWidth: 3,
                )
                : SizedBox(
                  width: double.infinity,
                  child: DottedBorder(
                    options: RectDottedBorderOptions(
                      dashPattern: [6, 3], // 6px line, 3px space
                      strokeWidth: 1.2,
                      color: Colors.black12,
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(height: 10.h),

                          if (_compressedImage != null)
                            Image.file(
                              _compressedImage!,
                              width: 35.w,
                              height: 35.w,
                              fit: BoxFit.contain,
                            )
                          else if (_selectedImage != null)
                            Image.file(
                              _selectedImage!,
                              width: 35.w,
                              height: 35.w,
                              fit: BoxFit.contain,
                            )
                          else
                            Column(
                              children: [
                                Center(
                                  child: Icon(
                                    Icons.image,
                                    color: Colors.black12,
                                    size: 25.sp,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  'Upload Employee Profile Image',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.black26,
                                    fontSize: 3.5.sp,
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                  ),
                ),
      ),
    );
  }
}
