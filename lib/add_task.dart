import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController objectiveController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final uid = FirebaseAuth.instance.currentUser?.uid;

  String selectedPriority = '';
  String selectedStatus = '';
  String errorInput = '';

  PlatformFile? pickedFile;
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future save() async {
    String title = titleController.text;
    String objective = objectiveController.text;
    String date = dateController.text;
    String description = descriptionController.text;

    if (title.isEmpty ||
        objective.isEmpty ||
        date.isEmpty ||
        selectedPriority.isEmpty ||
        selectedStatus.isEmpty ||
        date.isEmpty ||
        description.isEmpty) {
      errorInput = 'Kolom input tidak boleh kosong!';
      return;
    } else if (pickedFile == null) {
      errorInput = "Kolom Input gambar tidak boleh kosong!";
      return;
    }
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final localPath = '${appDir.path}/${pickedFile!.name}';
      final newFile = await File(pickedFile!.path!).copy(localPath);

      final taskData = {
        'title': titleController.text,
        'objective': objectiveController.text,
        'deadline': dateController.text,
        'priority': selectedPriority,
        'status': selectedStatus,
        'description': descriptionController.text,
        'image_path': newFile.path,
        'users_id': uid,
        'completed_at': '',
        'created_at': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('tasks').add(taskData);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Task berhasil disimpan")));

      Navigator.pop(context);
    } catch (e) {
      print('Error saat menyimpan: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal menyimpan task")));
    }

    // print("$uid");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    // HEAD TITLE ADD TASK
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add New Task',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 3,
                          color: Color(0xFFE6521F),
                        ),
                      ],
                    ),
                    // FOR TITLE INPUT
                    SizedBox(height: 10),
                    InputTitle(),

                    // FOR OBJECTIVE INPUT
                    SizedBox(height: 10),
                    InputObjective(),

                    // FOR DATE INPUT
                    SizedBox(height: 10),
                    inputDate(),

                    // FOR MENU OPTIONS
                    SizedBox(height: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Priority',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildPriorityOption('Extreme', Colors.red),
                            buildPriorityOption('Moderate', Colors.blue),
                            buildPriorityOption('Low', Colors.green),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Task Status',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildTaskStatus('Completed', Colors.green),
                            buildTaskStatus('Progress', Color(0xFF3211FF)),
                            buildTaskStatus('Not Started', Colors.red),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // FOR INPUT DESCRIPTION
                    inputDescription(),
                    SizedBox(height: 10),
                    // FOR SELECT IMAGE
                    (pickedFile != null) ? showImage() : selectImage(),
                    errorInputMessage(errorInput),
                    // FOR SAVE ALL
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFE6521F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Simpan',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget InputTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Title',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 5),
        TextField(
          controller: titleController,
          style: TextStyle(color: Colors.black, fontFamily: 'poppins'),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            labelStyle: TextStyle(color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF565454)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF565454)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFFE6521F)),
            ),
          ),
        ),
      ],
    );
  }

  Widget InputObjective() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Objective',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 5),
        TextField(
          controller: objectiveController,
          style: TextStyle(color: Colors.black, fontFamily: 'poppins'),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelStyle: TextStyle(color: Colors.black),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF565454)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF565454)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFFE6521F)),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPriorityOption(String label, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPriority = label;
        });
      },
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.circle, size: 10, color: color),
                SizedBox(width: 5),
                Text(label),
              ],
            ),
            Checkbox(
              value: selectedPriority == label,
              activeColor: Color(0xFFE6521F),
              onChanged: (_) {
                setState(() {
                  selectedPriority = label;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTaskStatus(String label, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedStatus = label;
        });
      },
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.circle, size: 10, color: color),
                SizedBox(width: 5),
                (label == 'Not Started')
                    ? Container(width: 50, child: Text(label))
                    : Text(label),
              ],
            ),
            Checkbox(
              value: selectedStatus == label,
              activeColor: Color(0xFFE6521F),
              onChanged: (_) {
                setState(() {
                  selectedStatus = label;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  DateTime? selectedDate;

  String formatDate(DateTime date) {
    // return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
    String formatted = DateFormat("dd-MMMM-yyyy").format(date);
    return "$formatted";
  }

  Widget inputDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date Deadline',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),
        TextField(
          controller: dateController,
          readOnly: true,
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Colors.deepOrange,
                      onPrimary: Colors.white,
                      onSurface: Colors.black,
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.deepOrange,
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (picked != null) {
              selectedDate = picked;
              dateController.text = formatDate(picked);
            }
          },
          decoration: InputDecoration(
            hintText: 'Day-Month-Year',
            filled: true,
            fillColor: Colors.white,
            labelStyle: TextStyle(color: Colors.black),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF565454)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF565454)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFFE6521F)),
            ),
          ),
        ),
      ],
    );
  }

  Widget inputDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Task Description',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        SizedBox(height: 10),
        TextField(
          controller: descriptionController,
          style: TextStyle(color: Colors.black, fontFamily: 'poppins'),
          keyboardType: TextInputType.multiline,
          minLines: 4,
          maxLines: 6,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelStyle: TextStyle(color: Colors.black),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF565454)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF565454)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFFE6521F)),
            ),
          ),
        ),
      ],
    );
  }

  Widget selectImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Upload Image',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        SizedBox(height: 5),
        ElevatedButton(
          onPressed: selectFile,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            padding: EdgeInsets.zero,
            surfaceTintColor: Colors.transparent,
          ).copyWith(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFA1A3AB), width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Image(
                  image: AssetImage('assets/images/icon_image.png'),
                  width: 50,
                ),
                SizedBox(width: 10),
                Text(
                  'Upload your images',
                  style: GoogleFonts.poppins(color: Color(0xFFA1A3AB)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget showImage() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFA1A3AB), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected Image',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 5),
          Image.file(
            File(pickedFile!.path!),
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  Widget errorInputMessage(String errorInput) {
    return Column(
      children: [
        SizedBox(height: 10),
        Text(
          errorInput,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
