import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAddFile extends StatefulWidget {
  final Function(File) onFilePicked;

  const CustomAddFile({
    super.key,
    required this.onFilePicked,
  });

  @override
  State<CustomAddFile> createState() => _CustomAddFileState();
}

class _CustomAddFileState extends State<CustomAddFile> {
  File? selectedFile;

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final pickedFile = File(result.files.single.path!);
      setState(() {
        selectedFile = pickedFile;
      });
      widget.onFilePicked(pickedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      padding: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            selectedFile != null ? selectedFile!.path.split('/').last : 'No file selected',
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
          const Spacer(),
          SizedBox(
            width: 100.w,
            child: ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Color(0xffBF964A)),
              ),
              onPressed: pickFile,
              child: const Text(
                'إرفاق الملف',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
