// import 'package:aikyamm/authentication/DashBoards/HomeDashboard/resource.dart';
// import 'package:aikyamm/authentication/DashBoards/HomeDashboard/resource1.dart';
// import 'package:flutter/material.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';
// import 'package:google_fonts/google_fonts.dart';

// void main() {
//   runApp(FitnessApp());
// }

// class FitnessApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: FitnessDashboard(),
//     );
//   }
// }

// class FitnessDashboard extends StatelessWidget {
//   // final PageController _pageController = PageController(viewportFraction: 0.85);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFF4F6FA),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // My Plans for Today Card
//               _buildMyPlansCard(),

//               // Top Resources Section
//               _buildSectionHeader("Top Resources"),
//               _buildTopResourcesSlider(),

//               // Top Workout Plan Section
//               _buildSectionHeader("Top Workout Plan"),
//               _buildTopWorkoutPlanSlider(),

//               //Fitness Blogs
//               _buildSectionHeader("Fitness Blogs"),
//               _buildTopWorkoutPlanSlider(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }


// // Widget _buildMyPlansCard() {
// //   return Container(
// //     height: 200,
// //     margin: EdgeInsets.all(16),
// //     decoration: BoxDecoration(
// //       image: DecorationImage(
// //         image: AssetImage("assets/HomeDash/myplanfor.jpeg"), // Replace with your background image
// //         fit: BoxFit.cover,
// //       ),
// //       borderRadius: BorderRadius.circular(16),
// //       boxShadow: [
// //         BoxShadow(
// //           color: Colors.black26,
// //           blurRadius: 8,
// //           offset: Offset(0, 4),
// //         ),
// //       ],
// //     ),
// //     child: Stack(
// //       children: [
// //         // Gradient overlay for better text visibility
// //         Container(
// //           decoration: BoxDecoration(
// //             borderRadius: BorderRadius.circular(16),
// //             gradient: LinearGradient(
// //               colors: [
// //                 Colors.black.withOpacity(0.4),
// //                 Colors.black.withOpacity(0.2),
// //               ],
// //               begin: Alignment.topCenter,
// //               end: Alignment.bottomCenter,
// //             ),
// //           ),
// //         ),
// //         Padding(
// //           padding: const EdgeInsets.all(12.0),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 "My Plan for the Day",
// //                 style: TextStyle(
// //                   color: Colors.white,
// //                   fontSize: 20,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //               SizedBox(height: 20),
// //                SizedBox(width: 180),
// //               // Aligning progress bar to start from the same position as the text
// //               Row(
// //                 children: [
// //                   // This will make the progress bar start exactly where the "M" in My Plan starts
// //                       SizedBox(width: 10),
// //                   Container(
// //                     width: 160.0, // Set width for the progress bar
// //                     child: LinearPercentIndicator(
// //                       lineHeight: 17.0,
// //                       percent: 0.36,
// //                       center: Text(
// //                         "36%",
// //                         style: TextStyle(
// //                           color: Colors.black,
// //                           fontWeight: FontWeight.bold,
// //                           fontSize: 12,
// //                         ),
// //                       ),
// //                       backgroundColor: Colors.grey.shade300,
// //                       progressColor: const Color.fromRGBO(143, 0, 0, 1),
// //                       barRadius: Radius.circular(8),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               SizedBox(height: 25),

// //               // Summary details with icons
// //               Row(
// //                 children: [
// //                   Icon(Icons.check_circle, color: Colors.white70, size: 20),
// //                   SizedBox(width: 8),
// //                   Text(
// //                     "12 Done of 18",
// //                     style: TextStyle(
// //                       color: Colors.white,
// //                       fontSize: 14,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               SizedBox(height: 30),
// //               Row(
// //                 children: [
// //                   Icon(Icons.local_fire_department, color: Colors.white70, size: 20),
// //                   SizedBox(width: 2),
// //                   Text(
// //                     "125 kcal",
// //                     style: TextStyle(
// //                       color: Colors.white,
// //                       fontSize: 13,
// //                     ),
// //                   ),
// //                   SizedBox(width: 8),
// //                   Icon(Icons.access_time, color: Colors.white70, size: 20),
// //                   SizedBox(width: 2),
// //                   Text(
// //                     "50 min",
// //                     style: TextStyle(
// //                       color: Colors.white,
// //                       fontSize: 13,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ],
// //     ),
// //   );
// // }
// Widget _buildMyPlansCard() {
//   return Container(
//     height: 200,
//     margin: EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       image: DecorationImage(
//         image: AssetImage("assets/HomeDash/myplanfor.jpeg"), // Replace with your background image
//         fit: BoxFit.cover,
//       ),
//       borderRadius: BorderRadius.circular(16),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black26,
//           blurRadius: 8,
//           offset: Offset(0, 4),
//         ),
//       ],
//     ),
//     child: Stack(
//       children: [
//         // Gradient overlay for better text visibility
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             gradient: LinearGradient(
//               colors: [
//                 Colors.black.withOpacity(0.4),
//                 Colors.black.withOpacity(0.2),
//               ],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(0.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Adding a left margin to the title
//               Padding(
//                 padding: const EdgeInsets.only(left: 10.0, top:10 ), // Adjust the value for more or less space
//                 child: Text(
//                   "My Plan for the Day",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//                SizedBox(width: 180),
//               // Aligning progress bar to start from the same position as the text
//               Row(
//                 children: [
//                   // This will make the progress bar start exactly where the "M" in My Plan starts
//                       // SizedBox(width: 10),
//                   Container(
//                     width: 160.0, // Set width for the progress bar
//                     child: LinearPercentIndicator(
//                       lineHeight: 17.0,
//                       percent: 0.36,
//                       center: Text(
//                         "36%",
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 12,
//                         ),
//                       ),
//                       backgroundColor: Colors.grey.shade300,
//                       progressColor: const Color.fromRGBO(143, 0, 0, 1),
//                       barRadius: Radius.circular(8),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 25),

//               // Summary details with icons
//               Row(
//                 children: [
//                   SizedBox(width: 10),
//                   Icon(Icons.check_circle, color: Colors.white70, size: 20),
//                   SizedBox(width: 8),
//                   Text(
//                     "12 Done of 18",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 30),
//               Row(
//                 children: [
//                   SizedBox(width: 10),
//                   Icon(Icons.local_fire_department, color: Colors.white70, size: 20),
//                   SizedBox(width: 2),
//                   Text(
//                     "125 kcal",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 13,
//                     ),
//                   ),
//                   SizedBox(width: 8),
//                   Icon(Icons.access_time, color: Colors.white70, size: 20),
//                   SizedBox(width: 2),
//                   Text(
//                     "50 min",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 13,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

//   Widget _buildSectionHeader(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
//         ],
//       ),
//     );
//   }

// // top resource card 
//   // Widget _buildTopResourcesSlider() {
//   //   final resources = [
//   //     {
//   //       'title': 'Resource 1',
//   //       'imagePath': 'assets/HomeDash/image1.jpeg',
//   //       'kcal': '35 kcal',
//   //       'time': '15 min',
//   //       'description': 'A great resource to help you burn calories quickly!',
//   //     },
//   //     {
//   //       'title': 'Resource 2',
//   //       'imagePath': 'assets/HomeDash/img2.jpeg',
//   //       'kcal': '45 kcal',
//   //       'time': '20 min',
//   //       'description': 'Boost your fitness with this powerful workout routine.',
//   //     },
//   //     {
//   //       'title': 'Resource 3',
//   //       'imagePath': 'assets/HomeDash/img3.jpeg',
//   //       'kcal': '50 kcal',
//   //       'time': '25 min',
//   //       'description': 'An intense exercise plan for muscle gain.',
//   //     },
//   //   ];

//   //   return Container(
//   //     height: 220,
//   //     child: ListView.builder(
        
//   //       controller: PageController(viewportFraction: 0.8),
//   //       scrollDirection: Axis.horizontal,
//   //       itemCount: resources.length,
//   //       itemBuilder: (context, index) {
//   //         return GestureDetector(
//   //           onTap: () {
//   //             // Navigate to resource detail page with animation
//   //             Navigator.push(
//   //               context,
//   //               MaterialPageRoute(
//   //                 builder: (context) => ResourceDetailPage(
//   //                   title: resources[index]['title']!,
//   //                   imagePath: resources[index]['imagePath']!,
//   //                   kcal: resources[index]['kcal']!,
//   //                   time: resources[index]['time']!,
//   //                   description: resources[index]
//   //                       ['description']!, // Send description here
//   //                 ),
//   //               ),
//   //             );
//   //           },
//   //           child: _buildResourceCard(
//   //             resources[index]['title']!,
//   //             resources[index]['imagePath']!,
//   //             resources[index]['kcal']!,
//   //             resources[index]['time']!,
//   //           ),
//   //         );
//   //       },
//   //     ),
//   //   );
//   // }
// Widget _buildTopResourcesSlider() {
//   final resources = [
//     {
//       'title': 'Resource 1',
//       'imagePath': 'assets/HomeDash/image1.jpeg',
//       'kcal': '35 kcal',
//       'time': '15 min',
//       'description': 'A great resource to help you burn calories quickly!',
//     },
//     {
//       'title': 'Resource 2',
//       'imagePath': 'assets/HomeDash/img2.jpeg',
//       'kcal': '45 kcal',
//       'time': '20 min',
//       'description': 'Boost your fitness with this powerful workout routine.',
//     },
//     {
//       'title': 'Resource 3',
//       'imagePath': 'assets/HomeDash/img3.jpeg',
//       'kcal': '50 kcal',
//       'time': '25 min',
//       'description': 'An intense exercise plan for muscle gain.',
//     },
//   ];

//   return Container(
//     height: 220,
//     child: ListView.builder(
//       controller: PageController(viewportFraction: 0.8),
//       scrollDirection: Axis.horizontal,
//       itemCount: resources.length,
//       itemBuilder: (context, index) {
//         // Add left margin for the first item
//         double leftMargin = 0.0;
//         if (index == 0) {
//           leftMargin = 10.0; // Adjust as necessary to match the desired space
//         }

//         return GestureDetector(
//           onTap: () {
//             // Navigate to resource detail page with animation
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ResourceDetailPage(
//                   title: resources[index]['title']!,
//                   imagePath: resources[index]['imagePath']!,
//                   kcal: resources[index]['kcal']!,
//                   time: resources[index]['time']!,
//                   description: resources[index]['description']!, // Send description here
//                 ),
//               ),
//             );
//           },
//           child: Container(
//             margin: EdgeInsets.only(
//               left: leftMargin, // Apply left margin conditionally
//               right: 0.0,
//               top: 0.0,
//               bottom: 0.0,
//             ),
//             child: _buildResourceCard(
//               resources[index]['title']!,
//               resources[index]['imagePath']!,
//               resources[index]['kcal']!,
//               resources[index]['time']!,
//             ),
//           ),
//         );
//       },
//     ),
//   );
// }

//   Widget _buildResourceCard(
//       String title, String imagePath, String kcal, String time) {
//     return Container(
//       width: 180, 
//       margin: EdgeInsets.symmetric(
//           horizontal: 6.0, vertical: 12.0), 
//       decoration: BoxDecoration(
//         borderRadius:
//             BorderRadius.circular(20), //  rounded corners
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black38,
//             blurRadius: 10,
//             offset: Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           // Background Image with Full Cover
//           ClipRRect(
//             borderRadius: BorderRadius.circular(20),
//             child: Image.asset(
//               imagePath,
//               width: double.infinity,
//               height: double.infinity,
//               fit: BoxFit.cover,
//             ),
//           ),
          
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.black.withOpacity(0.6),
//                   Colors.transparent,
//                 ],
//                 begin: Alignment.bottomCenter,
//                 end: Alignment.topCenter,
//               ),
//             ),
//           ),
//           // Text and Details
//           Padding(
//             padding: const EdgeInsets.all(12.0), // Adjusted padding for text
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Title with bold, large text
//                 Text(
//                   title,
//                   style: GoogleFonts.lato(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20, // Larger title for more impact
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 SizedBox(
//                     height: 1), // Increased space between title and kcal/time
//                 // Kcal and Time in one row, with larger icons and bolder text
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Icon(Icons.local_fire_department,
//                         color: Colors.white70,
//                         size: 16), // Larger kcal icon
//                     SizedBox(width: 2), // More space between icon and kcal text
//                     Text(
//                       kcal, // Display kcal (e.g., "35 kcal")
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 12, // Larger font size for kcal
//                         fontWeight: FontWeight.bold, // Bold text for emphasis
//                       ),
//                     ),
//                     SizedBox(width: 8), // More space between kcal and time
//                     Icon(Icons.access_time,
//                         color: Colors.white70,
//                         size: 16), // Larger time icon
//                     SizedBox(width: 2), // More space between icon and time text
//                     Text(
//                       time, // Display time (e.g., "15 min")
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 12, // Larger font size for time
//                         fontWeight: FontWeight.bold, // Bold text for emphasis
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }


// // top workout plan card

// Widget _buildTopWorkoutPlanSlider() {
//   final workoutPlans = [
//     {
//       'title': 'Full Strength',
//       'imagePath': 'assets/HomeDash/image1.jpeg',
//       'kcal': '125 kcal',
//       'time': '50 min',
//       'date': 'Saturday, 10 Dec',
//     },
//     {
//       'title': 'Cardio Blast',
//       'imagePath': 'assets/HomeDash/img2.jpeg',
//       'kcal': '75 kcal',
//       'time': '30 min',
//       'date': 'Monday, 12 Dec',
//     },
//     {
//       'title': 'Yoga Flow',
//       'imagePath': 'assets/HomeDash/img3.jpeg',
//       'kcal': '100 kcal',
//       'time': '45 min',
//       'date': 'Wednesday, 14 Dec',
//     },
//      {
//       'title': 'Yoga Setup',
//       'imagePath': 'assets/HomeDash/img3.jpeg',
//       'kcal': '100 kcal',
//       'time': '45 min',
//       'date': 'Wednesday, 14 Dec',
//     },
//   ];

//   return Container(
//     height: 240, // Increased height for a more prominent card
//     child: PageView.builder(
//       controller: PageController(viewportFraction: 0.95),
//       itemCount: workoutPlans.length,
//       itemBuilder: (context, index) {
//         return GestureDetector(
//           onTap: () {
//             // Navigate to Workout Detail Page
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => WorkoutDetailPage(
//                   title: workoutPlans[index]['title']!,
//                   imagePath: workoutPlans[index]['imagePath']!,
//                   kcal: workoutPlans[index]['kcal']!,
//                   time: workoutPlans[index]['time']!,
//                   date: workoutPlans[index]['date']!,
//                 ),
//               ),
//             );
//           },
//           child: _buildWorkoutPlanCard(
//             workoutPlans[index]['title']!,
//             workoutPlans[index]['imagePath']!,
//             workoutPlans[index]['kcal']!,
//             workoutPlans[index]['time']!,
//             workoutPlans[index]['date']!,
//           ),
//         );
//       },
//     ),
//   );
// }

// Widget _buildWorkoutPlanCard(
//     String title, String imagePath, String kcal, String time, String date) {
//   return Container(
//     margin: EdgeInsets.symmetric(horizontal: 6.0, vertical: 10),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(16),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black26,
//           blurRadius: 10,
//           offset: Offset(0, 4),
//         ),
//       ],
//     ),
//     child: ClipRRect(
//       borderRadius: BorderRadius.circular(16),
//       child: Stack(
//         children: [
//           // Background Image
//           Image.asset(
//             imagePath,
//             width: double.infinity,
//             height: double.infinity,
//             fit: BoxFit.cover,
//           ),
//           // Gradient Overlay for better readability of text
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.black.withOpacity(0.8), Colors.transparent],
//                 begin: Alignment.bottomCenter,
//                 end: Alignment.topCenter,
//               ),
//             ),
//           ),
          
//           Positioned(
//             bottom: 20, 
//             left: 12,
//             right: 12,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Title
//                 Text(
//                   title,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 18,
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 // Date
//                 Text(
//                   date,
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 12,
//                   ),
//                 ),
//                 SizedBox(height: 6),
//                 // Kcal and Time Row
//                 Row(
//                   children: [
//                     // Kcal
//                     Icon(Icons.local_fire_department,
//                         color: Colors.white70, size: 16),
//                     SizedBox(width: 4),
//                     Text(
//                       kcal,
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: 12,
//                       ),
//                     ),
//                     SizedBox(width: 16), 
//                     // Time
//                     Icon(Icons.access_time, color: Colors.white70, size: 16),
//                     SizedBox(width: 4),
//                     Text(
//                       time,
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
          
//           Positioned(
//             bottom: 10,
//             right: 12,
//             child: OutlinedButton(
//               onPressed: () {
//                 // Add join functionality here
//               },
//               style: OutlinedButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 side: BorderSide(color: Colors.white),
//               ),
//               child: Text(
//                 'Join',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }


// }



















import 'package:aikyamm/authentication/DashBoards/HomeDashboard/resource.dart';
import 'package:aikyamm/authentication/DashBoards/HomeDashboard/resource1.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:google_fonts/google_fonts.dart';




class FitnessDashboard extends StatelessWidget {
  // final PageController _pageController = PageController(viewportFraction: 0.85);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // My Plans for Today Card
              _buildMyPlansCard(),

              // Top Resources Section
              _buildSectionHeader("Top Resources"),
              _buildTopResourcesSlider(),

              // Top Workout Plan Section
              _buildSectionHeader("Top Workout Plan"),
              _buildTopWorkoutPlanSlider(),

              //Fitness Blogs
              _buildSectionHeader("Fitness Blogs"),
              _buildTopWorkoutPlanSlider(),
            ],
          ),
        ),
      ),
    );
  }
Widget _buildMyPlansCard() {
  return Container(
    height: 200,
    margin: EdgeInsets.all(16),
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/HomeDash/myplanfor.jpeg"), // Replace with your background image
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Stack(
      children: [
        // Gradient overlay for better text visibility
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.4),
                Colors.black.withOpacity(0.2),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Adding a left margin to the title
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top:10 ), // Adjust the value for more or less space
                child: Text(
                  "My Plan for the Day",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
               SizedBox(width: 180),
              // Aligning progress bar to start from the same position as the text
              Row(
                children: [
                  // This will make the progress bar start exactly where the "M" in My Plan starts
                      // SizedBox(width: 10),
                  Container(
                    width: 160.0, // Set width for the progress bar
                    child: LinearPercentIndicator(
                      lineHeight: 17.0,
                      percent: 0.36,
                      center: Text(
                        "36%",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      backgroundColor: Colors.grey.shade300,
                      progressColor: const Color.fromRGBO(143, 0, 0, 1),
                      barRadius: Radius.circular(8),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),

              // Summary details with icons
              Row(
                children: [
                  SizedBox(width: 10),
                  Icon(Icons.check_circle, color: Colors.white70, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "12 Done of 18",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  SizedBox(width: 10),
                  Icon(Icons.local_fire_department, color: Colors.white70, size: 20),
                  SizedBox(width: 2),
                  Text(
                    "125 kcal",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.access_time, color: Colors.white70, size: 20),
                  SizedBox(width: 2),
                  Text(
                    "50 min",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

Widget _buildTopResourcesSlider() {
  final resources = [
    {
      'title': 'Resource 1',
      'imagePath': 'assets/HomeDash/image1.jpeg',
      'kcal': '35 kcal',
      'time': '15 min',
      'description': 'A great resource to help you burn calories quickly!',
    },
    {
      'title': 'Resource 2',
      'imagePath': 'assets/HomeDash/img2.jpeg',
      'kcal': '45 kcal',
      'time': '20 min',
      'description': 'Boost your fitness with this powerful workout routine.',
    },
    {
      'title': 'Resource 3',
      'imagePath': 'assets/HomeDash/img3.jpeg',
      'kcal': '50 kcal',
      'time': '25 min',
      'description': 'An intense exercise plan for muscle gain.',
    },
  ];

  return Container(
    height: 220,
    child: ListView.builder(
      controller: PageController(viewportFraction: 0.8),
      scrollDirection: Axis.horizontal,
      itemCount: resources.length,
      itemBuilder: (context, index) {
        // Add left margin for the first item
        double leftMargin = 0.0;
        if (index == 0) {
          leftMargin = 10.0; // Adjust as necessary to match the desired space
        }

        return GestureDetector(
          onTap: () {
            // Navigate to resource detail page with animation
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResourceDetailPage(
                  title: resources[index]['title']!,
                  imagePath: resources[index]['imagePath']!,
                  kcal: resources[index]['kcal']!,
                  time: resources[index]['time']!,
                  description: resources[index]['description']!, // Send description here
                ),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(
              left: leftMargin, // Apply left margin conditionally
              right: 0.0,
              top: 0.0,
              bottom: 0.0,
            ),
            child: _buildResourceCard(
              resources[index]['title']!,
              resources[index]['imagePath']!,
              resources[index]['kcal']!,
              resources[index]['time']!,
            ),
          ),
        );
      },
    ),
  );
}

  Widget _buildResourceCard(
      String title, String imagePath, String kcal, String time) {
    return Container(
      width: 180, 
      margin: EdgeInsets.symmetric(
          horizontal: 6.0, vertical: 12.0), 
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(20), //  rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Image with Full Cover
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          // Text and Details
          Padding(
            padding: const EdgeInsets.all(12.0), // Adjusted padding for text
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title with bold, large text
                Text(
                  title,
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20, // Larger title for more impact
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                    height: 1), // Increased space between title and kcal/time
                // Kcal and Time in one row, with larger icons and bolder text
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.local_fire_department,
                        color: Colors.white70,
                        size: 16), // Larger kcal icon
                    SizedBox(width: 2), // More space between icon and kcal text
                    Text(
                      kcal, // Display kcal (e.g., "35 kcal")
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12, // Larger font size for kcal
                        fontWeight: FontWeight.bold, // Bold text for emphasis
                      ),
                    ),
                    SizedBox(width: 8), // More space between kcal and time
                    Icon(Icons.access_time,
                        color: Colors.white70,
                        size: 16), // Larger time icon
                    SizedBox(width: 2), // More space between icon and time text
                    Text(
                      time, // Display time (e.g., "15 min")
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12, // Larger font size for time
                        fontWeight: FontWeight.bold, // Bold text for emphasis
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


// top workout plan card

Widget _buildTopWorkoutPlanSlider() {
  final workoutPlans = [
    {
      'title': 'Full Strength',
      'imagePath': 'assets/HomeDash/image1.jpeg',
      'kcal': '125 kcal',
      'time': '50 min',
      'date': 'Saturday, 10 Dec',
    },
    {
      'title': 'Cardio Blast',
      'imagePath': 'assets/HomeDash/img2.jpeg',
      'kcal': '75 kcal',
      'time': '30 min',
      'date': 'Monday, 12 Dec',
    },
    {
      'title': 'Yoga Flow',
      'imagePath': 'assets/HomeDash/img3.jpeg',
      'kcal': '100 kcal',
      'time': '45 min',
      'date': 'Wednesday, 14 Dec',
    },
     {
      'title': 'Yoga Setup',
      'imagePath': 'assets/HomeDash/img3.jpeg',
      'kcal': '100 kcal',
      'time': '45 min',
      'date': 'Wednesday, 14 Dec',
    },
  ];

  return Container(
    height: 240, // Increased height for a more prominent card
    child: PageView.builder(
      controller: PageController(viewportFraction: 0.95),
      itemCount: workoutPlans.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Navigate to Workout Detail Page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkoutDetailPage(
                  title: workoutPlans[index]['title']!,
                  imagePath: workoutPlans[index]['imagePath']!,
                  kcal: workoutPlans[index]['kcal']!,
                  time: workoutPlans[index]['time']!,
                  date: workoutPlans[index]['date']!,
                ),
              ),
            );
          },
          child: _buildWorkoutPlanCard(
            workoutPlans[index]['title']!,
            workoutPlans[index]['imagePath']!,
            workoutPlans[index]['kcal']!,
            workoutPlans[index]['time']!,
            workoutPlans[index]['date']!,
          ),
        );
      },
    ),
  );
}

Widget _buildWorkoutPlanCard(
    String title, String imagePath, String kcal, String time, String date) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 6.0, vertical: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          // Background Image
          Image.asset(
            imagePath,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          // Gradient Overlay for better readability of text
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          
          Positioned(
            bottom: 20, 
            left: 12,
            right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 4),
                // Date
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 6),
                // Kcal and Time Row
                Row(
                  children: [
                    // Kcal
                    Icon(Icons.local_fire_department,
                        color: Colors.white70, size: 16),
                    SizedBox(width: 4),
                    Text(
                      kcal,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 16), 
                    // Time
                    Icon(Icons.access_time, color: Colors.white70, size: 16),
                    SizedBox(width: 4),
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          Positioned(
            bottom: 10,
            right: 12,
            child: OutlinedButton(
              onPressed: () {
                // Add join functionality here
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(color: Colors.white),
              ),
              child: Text(
                'Join',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


}
