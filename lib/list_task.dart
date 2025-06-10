import 'package:flutter/material.dart';
import 'package:project_to_do_apps/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_to_do_apps/templates/date_task.dart';
import 'package:project_to_do_apps/templates/view_task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ListTask extends StatefulWidget {
  const ListTask({Key? key}) : super(key: key);

  @override
  State<ListTask> createState() => _ListTaskState();
}

class _ListTaskState extends State<ListTask> {
  Stream<List<QueryDocumentSnapshot>> getUserTasksStream(String uid) {
    return FirebaseFirestore.instance
        .collection('tasks')
        .where('users_id', isEqualTo: uid)
        .where('status', isNotEqualTo: 'Completed')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs);
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
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Text(
                'List Tasks',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(width: 100, height: 3, color: Color(0xFFE6521F)),
              SizedBox(height: 20),

              StreamBuilder<List<QueryDocumentSnapshot>>(
                stream: getUserTasksStream(uid),
                builder: (context, snapshot) {
                  final viewDocs = snapshot.data ?? [];

                  if (viewDocs.isEmpty) {
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        viewDocs.map((doc) {
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
                                ViewTask(
                                  title: data['title'],
                                  status: data['status'],
                                  priority: data['priority'],
                                  objective: data['objective'],
                                  imagePath: data['image_path'],
                                  documentID: docId,
                                  description: data['description'],
                                  deadline: data['deadline'],
                                  createdAt: formattedDate,
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
  }
}
