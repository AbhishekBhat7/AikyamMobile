import 'package:aikyamm/authentication/Libraries/Colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkoutDetailPage extends StatelessWidget {
  final String title;
  final String imagePath;
  final String kcal;
  final String time;
  final String date;

  // Constructor to pass data from the previous screen
  WorkoutDetailPage({
    required this.title,
    required this.imagePath,
    required this.kcal,
    required this.time,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        elevation: 0,
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Image Banner
            Stack(
              children: [
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: MainColors.black,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Gradient Overlay
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Workout Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Workout Details",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blue,
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildDetailRow(Icons.calendar_today, "Date", date),
                  _buildDetailRow(Icons.local_fire_department, "Calories Burn", kcal),
                  _buildDetailRow(Icons.access_time, "Duration", time),
                  SizedBox(height: 20),
                  Text(
                    "About this workout:",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color:MainColors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "This is a specially designed workout to help you achieve your fitness goals effectively. It includes a mix of strength training, cardio, and flexibility exercises tailored for a balanced approach.",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: hint.customGray,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Start Workout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: ElevatedButton(
                onPressed: () {
                  // Add functionality for starting the workout
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Starting $title..."),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: AppColors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Start Workout",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.backgroundColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build a row of icons and details
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.blue, size: 20),
          SizedBox(width: 10),
          Text(
            "$label:",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: MainColors.black,
            ),
          ),
          Spacer(),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
