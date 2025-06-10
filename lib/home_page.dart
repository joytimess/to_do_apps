import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_to_do_apps/login_page.dart';
import 'package:project_to_do_apps/templates/todo_task.dart';
import 'package:project_to_do_apps/templates/completed_task.dart';
import 'package:project_to_do_apps/templates/date_task.dart';
import 'package:project_to_do_apps/view_task.dart';
import 'add_task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return LoginPage();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Text(
                'Priory',
                style: GoogleFonts.ubuntu(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFE6521F),
                ),
              ),
              SizedBox(height: 20),

              // Task Status
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  border: Border.all(color: Color(0xFFA1A3AB)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/icon_tasks_complete.png',
                          width: 25,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Task Status',
                          style: GoogleFonts.poppins(
                            color: Color(0xFFFF6767),
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/image_completed.png',
                          width: 105,
                        ),
                        Image.asset(
                          'assets/images/image_inprogress.png',
                          width: 105,
                        ),
                        Image.asset(
                          'assets/images/image_notstarted.png',
                          width: 105,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // To-Do Section
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/icon_tasks_todo.png',
                              width: 25,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'To-Do',
                              style: GoogleFonts.poppins(
                                color: Color(0xFFFF6767),
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddTask(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(10, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/icon_plus.png',
                                width: 10,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Add Task',
                                style: GoogleFonts.poppins(
                                  color: Color(0xFFA1A3AB),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // FOR TASK NOT COMPLETED
                    StreamBuilder<List<QueryDocumentSnapshot>>(
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
                                final data = doc.data() as Map<String, dynamic>;
                                final docId = doc.id;
                                final Timestamp timestamp = data['created_at'];
                                final String formattedDate = DateFormat(
                                  'dd MMMM',
                                ).format(timestamp.toDate());

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
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
                                          title: data['title'] ?? 'Tanpa Judul',
                                          description:
                                              data['description'] ?? '',
                                          priority: data['priority'] ?? '',
                                          status: data['status'] ?? '',
                                          createdAt: formattedDate,
                                          imagePath: data['image_path'] ?? '',
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

              SizedBox(height: 10),

              // Completed Task Section
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/icon_tasks_completed.png',
                          width: 25,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Completed Task',
                          style: GoogleFonts.poppins(
                            color: Color(0xFFFF6767),
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // FOR COMPLETED TASKS
                    StreamBuilder<List<QueryDocumentSnapshot>>(
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
                                final data = doc.data() as Map<String, dynamic>;
                                final Timestamp timestamp = data['created_at'];
                                final docId = doc.id;
                                final String formattedDate = DateFormat(
                                  'dd MMMM',
                                ).format(timestamp.toDate());

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
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
                                          title: data['title'] ?? 'Tanpa Judul',
                                          description:
                                              data['description'] ?? '',
                                          priority: data['priority'] ?? '',
                                          status: data['status'] ?? '',
                                          createdAt: formattedDate,
                                          completedAt: formattedDate,
                                          imagePath: data['image_path'] ?? '',
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
            ],
          ),
        ),
      ),
    );
  }
}
