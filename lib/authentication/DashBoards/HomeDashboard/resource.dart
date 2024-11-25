import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResourceDetailPage extends StatelessWidget {
  final String title;
  final String imagePath;
  final String kcal;
  final String time;
  final String description;

  ResourceDetailPage({
    required this.title,
    required this.imagePath,
    required this.kcal,
    required this.time,
    required this.description, // Description passed as a parameter
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: Text('Resource Details'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Large Image Section with animation
              AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.easeInOut,
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Resource Info Section with Details and Animation
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with animation
                    AnimatedOpacity(
                      opacity: 1.0,
                      duration: Duration(seconds: 1),
                      child: Text(
                        title,
                        style: GoogleFonts.lato(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Kcal and Time info with icons and animation
                    AnimatedCrossFade(
                      firstChild: Container(),
                      secondChild: Row(
                        children: [
                          Icon(Icons.local_fire_department,
                              color: Colors.orangeAccent, size: 28),
                          SizedBox(width: 10),
                          Text(
                            kcal,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(width: 20),
                          Icon(Icons.access_time,
                              color: Colors.lightBlueAccent, size: 28),
                          SizedBox(width: 10),
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      crossFadeState: CrossFadeState.showSecond,
                      duration: Duration(seconds: 1),
                    ),
                    SizedBox(height: 20),

                    // Description Section with animation
                    AnimatedSwitcher(
                      duration: Duration(seconds: 1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Action Button (Example: Start/Join button) with hover effect
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Action on button press (like starting the resource)
                        },
                        child: Text(
                          "Start Now",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        ),
                      ),
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
