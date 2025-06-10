import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_to_do_apps/templates/todo_task.dart';
import 'package:project_to_do_apps/login_page.dart';
import 'package:project_to_do_apps/templates/completed_task.dart';
import 'package:project_to_do_apps/templates/date_task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_to_do_apps/view_task.dart';

class Tasks extends StatefulWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  Stream<List<QueryDocumentSnapshot>> getUserTasksStream(String uid) {
    return FirebaseFirestore.instance
        .collection('tasks')
        .where('users_id', isEqualTo: uid)
        .where('status', isNotEqualTo: 'Completed')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  Stream<List<QueryDocumentSnapshot>> getUserCompletedTasksStream(String uid) {
    return FirebaseFirestore.instance
        .collection('tasks')
        .where('users_id', isEqualTo: uid)
        .where('status', isEqualTo: 'Completed')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  void viewTask(
    String title,
    String status,
    String priority,
    String objective,
    String imagePath,
    String description,
    String deadline,
    String createdAt,
    String documentID,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ViewTask(
              title: title,
              status: status,
              priority: priority,
              objective: objective,
              imagePath: imagePath,
              description: description,
              deadline: deadline,
              createdAt: createdAt,
              documentID: documentID,
            ),
      ),
    );
  }

  bool showCompleted = false;
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return LoginPage();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 40),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showCompleted = false;
                            });
                          },
                          child: Text(
                            'My Tasks',
                            style: GoogleFonts.poppins(
                              color:
                                  !showCompleted ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                !showCompleted ? Colors.orange : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showCompleted = true;
                            });
                          },
                          child: Text(
                            'Completed',
                            style: GoogleFonts.poppins(
                              color:
                                  showCompleted ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                showCompleted ? Colors.orange : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    showCompleted
                        ? StreamBuilder<List<QueryDocumentSnapshot>>(
                          stream: getUserCompletedTasksStream(uid),
                          builder: (context, snapshot) {
                            final completedDocs = snapshot.data ?? [];

                            if (completedDocs.isEmpty) {
                              return Center(
                                child: Text(
                                  'Hoping on your task to complete it.',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }

                            return Column(
                              children:
                                  completedDocs.map((doc) {
                                    final data =
                                        doc.data() as Map<String, dynamic>;
                                    final docId = doc.id;
                                    final Timestamp timestamp =
                                        data['created_at'];
                                    final String formattedDate = DateFormat(
                                      'dd MMMM',
                                    ).format(timestamp.toDate());

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16,
                                      ),
                                      child: Column(
                                        children: [
                                          DateTask(createdAt: formattedDate),
                                          SizedBox(height: 5),
                                          InkWell(
                                            onTap:
                                                () => viewTask(
                                                  data['title'],
                                                  data['status'],
                                                  data['priority'],
                                                  data['objective'],
                                                  data['image_path'],
                                                  data['description'],
                                                  data['deadline'],
                                                  '$formattedDate',
                                                  '$docId',
                                                ),
                                            child: CompletedTask(
                                              title: data['title'] ?? '',
                                              description:
                                                  data['description'] ?? '',
                                              priority: data['priority'] ?? '',
                                              status: data['status'] ?? '',
                                              createdAt: formattedDate,
                                              completedAt: formattedDate,
                                              imagePath:
                                                  data['image_path'] ?? '',
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                            );
                          },
                        )
                        : StreamBuilder<List<QueryDocumentSnapshot>>(
                          stream: getUserTasksStream(uid),
                          builder: (context, snapshot) {
                            final taskDocs = snapshot.data ?? [];

                            if (taskDocs.isEmpty) {
                              return Center(
                                child: Text(
                                  'There are no tasks available. Add it now!',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }

                            return Column(
                              children:
                                  taskDocs.map((doc) {
                                    final data =
                                        doc.data() as Map<String, dynamic>;
                                    final docId = doc.id;
                                    final Timestamp timestamp =
                                        data['created_at'];
                                    final String formattedDate = DateFormat(
                                      'dd MMMM',
                                    ).format(timestamp.toDate());

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16,
                                      ),
                                      child: Column(
                                        children: [
                                          DateTask(createdAt: formattedDate),
                                          SizedBox(height: 5),
                                          InkWell(
                                            onTap:
                                                () => viewTask(
                                                  data['title'],
                                                  data['status'],
                                                  data['priority'],
                                                  data['objective'],
                                                  data['image_path'],
                                                  data['description'],
                                                  data['deadline'],
                                                  '$formattedDate',
                                                  '$docId',
                                                ),
                                            child: TodoTask(
                                              title: data['title'] ?? '',
                                              description:
                                                  data['description'] ?? '',
                                              priority: data['priority'] ?? '',
                                              status: data['status'] ?? '',
                                              createdAt: formattedDate,
                                              imagePath:
                                                  data['image_path'] ?? '',
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                            );
                          },
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
}
