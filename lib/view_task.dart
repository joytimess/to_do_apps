import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_to_do_apps/edit_task.dart';
import 'package:project_to_do_apps/navigations/main_navigation.dart';

class ViewTask extends StatelessWidget {
  final String title;
  final String status;
  final String priority;
  final String objective;
  final String imagePath;
  final String description;
  final String deadline;
  final String createdAt;
  final String documentID;

  const ViewTask({
    Key? key,
    required this.title,
    required this.status,
    required this.priority,
    required this.objective,
    required this.imagePath,
    required this.description,
    required this.deadline,
    required this.createdAt,
    required this.documentID,
  }) : super(key: key);

  void back(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainNavigation()),
    );
  }

  Future<void> deleteTask(BuildContext context, String documentId) async {
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(documentId)
        .delete();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Task berhasil dihapus!")));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => back(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                    ),
                    child: Icon(
                      Icons.chevron_left_outlined,
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFFA1A3AB)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 100,
                              height: 135,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(
                                  File(imagePath),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 160,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          title,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    Text(
                                      'Priority: ',
                                      style: GoogleFonts.poppins(fontSize: 14),
                                    ),
                                    if (priority == 'Extreme')
                                      Text(
                                        '$priority',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.red,
                                        ),
                                      ),
                                    if (priority == 'Moderate')
                                      Text(
                                        '$priority',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Color(0xFF42ADE2),
                                        ),
                                      ),
                                    if (priority == 'Low')
                                      Text(
                                        '$priority',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.green,
                                        ),
                                      ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Status: ',
                                      style: GoogleFonts.poppins(fontSize: 14),
                                    ),
                                    if (status == 'Progress')
                                      Text(
                                        '$status',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Color(0xFF0224FF),
                                        ),
                                      ),
                                    if (status == 'Not Started')
                                      Text(
                                        '$status',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.red,
                                        ),
                                      ),
                                    if (status == 'Completed')
                                      Text(
                                        '$priority',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.green,
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Created on: $createdAt',
                                  style: GoogleFonts.poppins(
                                    color: Color(0xFFA1A3AB),
                                  ),
                                ),
                              ],
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                String documentId = documentID;
                                if (value == 'edit') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => EditTask(
                                            docId: documentId,
                                            title: title,
                                            status: status,
                                            priority: priority,
                                            objective: objective,
                                            imagePath: imagePath,
                                            description: description,
                                            deadline: deadline,
                                          ),
                                    ),
                                  );
                                } else if (value == 'delete') {
                                  deleteTask(context, documentId);
                                }
                              },
                              color: Colors.white,
                              itemBuilder:
                                  (
                                    BuildContext context,
                                  ) => <PopupMenuEntry<String>>[
                                    PopupMenuItem<String>(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit, color: Colors.black),
                                          SizedBox(width: 10),
                                          Text('Edit'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete, color: Colors.red),
                                          SizedBox(width: 10),
                                          Text('Delete'),
                                        ],
                                      ),
                                    ),
                                  ],
                              icon: Icon(Icons.more_vert),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 105,
                              child: Text(
                                'Task Title: ',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Color(0xFF747474),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                title,
                                style: GoogleFonts.poppins(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 105,
                              child: Text(
                                'Objective: ',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Color(0xFF747474),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                objective,
                                style: GoogleFonts.poppins(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description: ',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Color(0xFF747474),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                description,
                                style: GoogleFonts.poppins(fontSize: 16),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 105,
                              child: Text(
                                'Deadline: ',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                deadline,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w700,
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
            ),
          ],
        ),
      ),
    );
  }
}
