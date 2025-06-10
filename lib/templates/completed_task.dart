import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class CompletedTask extends StatelessWidget {
  final String title;
  final String description;
  final String createdAt;
  final String completedAt;
  final String priority;
  final String status;
  final String imagePath;

  const CompletedTask({
    Key? key,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.createdAt,
    required this.completedAt,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('dd-MMMM-yyyy').format(DateTime.now());
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
              Image(
                image: AssetImage('assets/images/status_completed.png'),
                width: 15,
              ),
              SizedBox(width: 10),
              // TITLE
              Expanded(
                child: Text(
                  '$title',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
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
                    Text('Status: ', style: GoogleFonts.poppins(fontSize: 14)),
                    // USE CONDITION OF PRIORITY
                    Text(
                      '$status',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Color(0xFF05A301),
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
                  'Created on: ',
                  style: GoogleFonts.poppins(color: Color(0xFFA1A3AB)),
                ),
                Text(
                  '$createdAt',
                  style: GoogleFonts.poppins(color: Color(0xFFA1A3AB)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Row(
              children: [
                Text(
                  'Completed on: ',
                  style: GoogleFonts.poppins(color: Color(0xFFA1A3AB)),
                ),
                Text(
                  '$completedAt',
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
