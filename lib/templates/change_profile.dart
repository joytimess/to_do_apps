import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

class ChangeProfile extends StatefulWidget {
  final String docID;
  final String imageProfile;
  final String username;

  ChangeProfile({
    Key? key,
    required this.docID,
    required this.imageProfile,
    required this.username,
  }) : super(key: key);
  @override
  State<ChangeProfile> createState() => _ChangeProfileState();
}

class _ChangeProfileState extends State<ChangeProfile> {
  late TextEditingController userController;

  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    userController = TextEditingController(text: widget.username);
    // print('${widget.docID}, ${widget.imageProfile}, ${widget.username}');
  }

  PlatformFile? pickedFile;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future editProfile() async {
    String username = userController.text;

    if (username.isEmpty) {
      errorMessage = "Username tidak boleh kosong!";
      return;
    }

    try {
      String imagePath = '';

      if (pickedFile != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final localPath = '${appDir.path}/${pickedFile!.name}';
        final newFile = await File(pickedFile!.path!).copy(localPath);
        imagePath = newFile.path;
      }

      final usersData = {
        'username': userController.text,
        'image_profile': imagePath.isNotEmpty ? imagePath : widget.imageProfile,
        'updated_at': DateTime.now(),
        'created_at': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.docID)
          .update(usersData);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Profile berhasil diubah!")));

      Navigator.pop(context);
    } catch (e) {
      print('Error pembaruan data: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal menyimpan task")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Text(
              'Change Profile',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5),
            Container(width: 100, height: 3, color: Color(0xFFE6521F)),
            SizedBox(height: 20),
            InputUsername(),
            SizedBox(height: 10),
            if (widget.imageProfile.isNotEmpty)
              alreadyImage(widget.imageProfile),
            SizedBox(height: 10),
            (pickedFile != null) ? showImage() : selectImage(),
            SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: editProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE6521F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Edit',
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
    );
  }

  Widget InputUsername() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Title',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 5),
        TextField(
          controller: userController,
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

  Widget alreadyImage(String imagePath) {
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
            'Selected Image Before',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 5),
          Image.file(
            File(imagePath),
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ],
      ),
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
            'Selected Image New',
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
}
