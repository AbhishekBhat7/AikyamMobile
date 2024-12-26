// import 'package:flutter/material.dart';

// void main() {
//   runApp(TeamPage());
// }

// class TeamPage extends StatelessWidget {
//   const TeamPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Fitness Dashboard',
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//         fontFamily: 'Roboto',
//       ),
//       home: TeamDashboard(),
//     );
//   }
// }

// class TeamDashboard extends StatelessWidget {
//   const TeamDashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: GridView.count(
//           crossAxisCount: 2,
//           crossAxisSpacing: 10,
//           mainAxisSpacing: 10,
//           children: [
//             TeamCard(
//               title: "Cricket Team",
//               description: "Trained by Rohan K, Nam...",
//               trainers: "Athlete 1, two, +9",
//               imagePath: "assets/images/cricket.png",
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => TeamDetailPage()),
//                 );
//               },
//             ),
//             TeamCard(
//               title: "Fitness GO",
//               description: "Trained by Trainer A",
//               trainers: "Athlete 1, 2, 3, +34",
//               imagePath: "assets/images/fitness.png",
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => TeamDetailPage()),
//                 );
//               },
//             ),
//             TeamCard(
//               title: "Join a Team",
//               description: "From 100's of existing teams. Get connected to top trainers",
//               imagePath: "assets/images/join.png",
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => JoinTeamPage()),
//                 );
//               },
//               trainers: '',
//             ),
//             TeamCard(
//               title: "Create New Team",
//               description: "Create teams and add athletes. *Only for Trainers",
//               imagePath: "assets/images/fitness.png",
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => CreateTeamPage()),
//                 );
//               },
//               trainers: '',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class TeamCard extends StatelessWidget {
//   final String title;
//   final String description;
//   final String trainers;
//   final String imagePath;
//   final VoidCallback onTap;

//   const TeamCard({super.key, 
//     required this.title,
//     required this.description,
//     required this.trainers,
//     required this.imagePath,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedScale(
//         scale: 1.0,
//         duration: Duration(milliseconds: 200),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             image: DecorationImage(
//               image: AssetImage(imagePath),
//               fit: BoxFit.cover,
//               colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.2),
//                 blurRadius: 10,
//                 offset: Offset(4, 8),
//               ),
//             ],
//           ),
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.black.withOpacity(0.8),
//                   Colors.transparent,
//                 ],
//                 begin: Alignment.bottomCenter,
//                 end: Alignment.center,
//               ),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     description,
//                     style: TextStyle(
//                       color: Colors.white70,
//                       fontSize: 14,
//                     ),
//                   ),
//                   if (trainers.isNotEmpty) ...[
//                     SizedBox(height: 5),
//                     Text(
//                       trainers,
//                       style: TextStyle(
//                         color: Colors.white54,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class TeamDetailPage extends StatelessWidget {
//   const TeamDetailPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Team Details"),
//         backgroundColor: Colors.green,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.sports_cricket, color: Colors.green, size: 80),
//             SizedBox(height: 20),
//             Text(
//               "Cricket Team",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
//             ),
//             SizedBox(height: 10),
//             Text(
//               "Details about the Cricket Team, trainers, and athletes.",
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16, color: Colors.black54),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class JoinTeamPage extends StatelessWidget {
//   const JoinTeamPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Join Team"),
//         backgroundColor: Colors.green,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.group_add, color: Colors.green, size: 80),
//             SizedBox(height: 20),
//             Text(
//               "Join a Team",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
//             ),
//             SizedBox(height: 10),
//             Text(
//               "Connect with trainers and join an existing team.",
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16, color: Colors.black54),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CreateTeamPage extends StatelessWidget {
//   const CreateTeamPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Create Team"),
//         backgroundColor: Colors.green,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.create, color: Colors.green, size: 80),
//             SizedBox(height: 20),
//             Text(
//               "Create a New Team",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
//             ),
//             SizedBox(height: 10),
//             Text(
//               "As a trainer, create and manage your own teams.",
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16, color: Colors.black54),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

 import 'package:flutter/material.dart';

void main() {
  runApp(const TeamPage());
}

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: Color.fromRGBO(143, 0, 0, 1), // Main Red Color
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const TeamDashboard(),
    );
  }
}

class TeamDashboard extends StatelessWidget {
  const TeamDashboard({super.key});

  // A single function to generate the cards dynamically
  Widget createTeamCard({
    required String title,
    required String description,
    required String trainers,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              spreadRadius: 4,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.6),
                            blurRadius: 6,
                            offset: const Offset(3, 3),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 6,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                    if (trainers.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        trainers,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 0.75,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return createTeamCard(
              title: index == 0
                  ? "Cricket Team"
                  : index == 1
                      ? "Fitness GO"
                      : index == 2
                          ? "Join a Team"
                          : "Create New Team",
              description: index == 0
                  ? "Trained by Rohan K, Nam..."
                  : index == 1
                      ? "Trained by Trainer A"
                      : index == 2
                          ? "From 100's of existing teams. Get connected to top trainers."
                          : "Create teams and add athletes. *Only for Trainers",
              trainers: index == 0 ? "Athlete 1, two, +9" : index == 1 ? "Athlete 1, 2, 3, +34" : '',
              imagePath: index == 0
                  ? "assets/images/cricket.png"
                  : index == 1
                      ? "assets/images/fitness.png"
                      : index == 2
                          ? "assets/images/join.png"
                          : "assets/images/fitness.png",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TeamDetailPage()),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class TeamDetailPage extends StatelessWidget {
  const TeamDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Team Details", style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromRGBO(143, 0, 0, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sports_cricket, color: Colors.redAccent, size: 80),
            const SizedBox(height: 20),
            Text(
              "Cricket Team",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Details about the Cricket Team, trainers, and athletes.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

class JoinTeamPage extends StatelessWidget {
  const JoinTeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Join Team", style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromRGBO(143, 0, 0, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.group_add, color: Colors.redAccent, size: 80),
            const SizedBox(height: 20),
            Text(
              "Join a Team",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Connect with trainers and join an existing team.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateTeamPage extends StatelessWidget {
  const CreateTeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Team", style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromRGBO(143, 0, 0, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.create, color: Colors.redAccent, size: 80),
            const SizedBox(height: 20),
            Text(
              "Create a New Team",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "As a trainer, create and manage your own teams.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
