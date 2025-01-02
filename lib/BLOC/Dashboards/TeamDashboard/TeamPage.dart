// Import statements
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// TeamDashboardEvent (BLoC Event)
abstract class TeamDashboardEvent {}
class LoadTeamDashboard extends TeamDashboardEvent {}

// TeamDashboardState (BLoC State)
abstract class TeamDashboardState {}
class TeamDashboardInitial extends TeamDashboardState {}
class TeamDashboardLoaded extends TeamDashboardState {}

// TeamDashboardBloc (BLoC Logic)
class TeamDashboardBloc extends Bloc<TeamDashboardEvent, TeamDashboardState> {
  TeamDashboardBloc() : super(TeamDashboardInitial()) {
    on<LoadTeamDashboard>((event, emit) {
      emit(TeamDashboardLoaded());
    });
  }
}

// Main App Entry
void main() {
  runApp(
    BlocProvider(
      create: (context) => TeamDashboardBloc()..add(LoadTeamDashboard()),
      child: const MyApp(),
    ),
  );
} 

// MyApp Widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<TeamDashboardBloc, TeamDashboardState>(
        builder: (context, state) {
          if (state is TeamDashboardLoaded) {
            return const TeamDashboard();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

// TeamDashboard Widget (UI remains unchanged)
class TeamDashboard extends StatelessWidget {
  const TeamDashboard({super.key});

  // Function to create dynamic team cards
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
                  ? "assets/images/Cricket.jpg"
                  : index == 1
                      ? "assets/images/fit.jpeg"
                      : index == 2
                          ? "assets/images/join1.jpeg"
                          : "assets/images/teaam.jpeg",
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

// Other Pages (Unchanged)

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

// Remaining pages (JoinTeamPage and CreateTeamPage) remain the same as in the original code.

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
