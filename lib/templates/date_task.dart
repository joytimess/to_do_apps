import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DateTask extends StatelessWidget {
  final String createdAt;
  const DateTask({Key? key, required this.createdAt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String currentDate = createdAt;
    String nowDate = DateFormat('dd MMMM').format(DateTime.now());

    String statusDate = (currentDate == nowDate) ? 'Now' : 'Yesterday';

    return Row(
      children: [
        Text(
          "$createdAt • $statusDate",
          style: GoogleFonts.poppins(fontSize: 12),
        ),
      ],
    );
  }
}
