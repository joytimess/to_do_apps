import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TodoTask extends StatelessWidget {
  final String title;
  final String description;
  final String createdAt;
  final String priority;
  final String status;
  final String imagePath;

  const TodoTask({
    Key? key,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.createdAt,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFA1A3AB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // STATUS USE IF
              if (status == 'Progress')
                Image(
                  image: AssetImage('assets/images/status_inprogress.png'),
                  width: 15,
                ),
              if (status == 'Not Started')
                Image(
                  image: AssetImage('assets/images/status_notstarted.png'),
                  width: 15,
                ),
              SizedBox(width: 10),
              // TITLE
              Expanded(
                child: Text(
                  '$title',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          Container(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 200,
                child: Row(
                  children: [
                    SizedBox(width: 25),
                    Expanded(
                      child: Text(
                        '$description',
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.poppins(color: Color(0xFF747474)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 25),
              Expanded(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child:
                      (imagePath.isNotEmpty)
                          ? Image.file(File(imagePath), fit: BoxFit.cover)
                          : Container(),
                ),
              ),
            ],
          ),
          Container(height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Priority: ',
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    // USE CONDITION OF PRIORITY
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
                    Text('Status: ', style: GoogleFonts.poppins(fontSize: 14)),
                    // USE CONDITION ON STATUS
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
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Row(
              children: [
                Text(
                  'Created on: $createdAt',
                  style: GoogleFonts.poppins(color: Color(0xFFA1A3AB)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
