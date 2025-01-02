
import 'package:aikyamm/authentication/DashBoards/HomeDashboard/resource.dart';
import 'package:aikyamm/authentication/DashBoards/HomeDashboard/resource1.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aikyamm/authentication/Libraries/Colors.dart'; // Assuming you have this file

class FitnessDashboardState {
  final List<Map<String, String>> resources;
  final List<Map<String, String>> workoutPlans;

  FitnessDashboardState({
    required this.resources,
    required this.workoutPlans,
  });

  // Add copyWith method for state updates
  FitnessDashboardState copyWith({
    List<Map<String, String>>? resources,
    List<Map<String, String>>? workoutPlans,
  }) {
    return FitnessDashboardState(
      resources: resources ?? this.resources,
      workoutPlans: workoutPlans ?? this.workoutPlans,
    );
  }
}


abstract class FitnessDashboardEvent {}

class LoadFitnessDataEvent extends FitnessDashboardEvent {}




class FitnessDashboardBloc extends Bloc<FitnessDashboardEvent, FitnessDashboardState> {
  FitnessDashboardBloc() : super(FitnessDashboardState(resources: [], workoutPlans: []));

  @override
  Stream<FitnessDashboardState> mapEventToState(FitnessDashboardEvent event) async* {
    if (event is LoadFitnessDataEvent) {
      // Simulating a data fetch
      await Future.delayed(Duration(seconds: 1));

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

      yield state.copyWith(resources: resources, workoutPlans: workoutPlans);
    }
  }
}



class FitnessDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FitnessDashboardBloc()..add(LoadFitnessDataEvent()),
      child: Scaffold(
        backgroundColor: Color(0xFFF4F6FA),
        body: SafeArea(
          child: SingleChildScrollView(
            child: BlocBuilder<FitnessDashboardBloc, FitnessDashboardState>(
              builder: (context, state) {
                if (state.resources.isEmpty || state.workoutPlans.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMyPlansCard(),
                    
                    _buildSectionHeader("Top Resources"),
                    _buildTopResourcesSlider(state.resources),

                    _buildSectionHeader("Top Workout Plan"),
                    _buildTopWorkoutPlanSlider(state.workoutPlans),

                    _buildSectionHeader("Fitness Blogs"),
                    _buildTopWorkoutPlanSlider(state.workoutPlans),
                  ],
                );
              },
            ),
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
          image: AssetImage("assets/HomeDash/myplanfor.jpeg"),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [],
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.4), Colors.black.withOpacity(0.2)],
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
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 10),
                  child: Text(
                    "My Plan for the Day",
                    style: TextStyle(color: MainColors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 160.0,
                      child: LinearPercentIndicator(
                        lineHeight: 17.0,
                        percent: 0.36,
                        center: Text(
                          "36%",
                          style: TextStyle(color: MainColors.black, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        backgroundColor: Colors.grey.shade300,
                        progressColor: MainColors.primaryColor,
                        barRadius: Radius.circular(8),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                Row(
                  children: [
                    SizedBox(width: 10),
                    Icon(Icons.check_circle, color: MainColors.white, size: 20),
                    SizedBox(width: 8),
                    Text("12 Done of 18", style: TextStyle(color: MainColors.white, fontSize: 14)),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    SizedBox(width: 10),
                    Icon(Icons.local_fire_department, color: MainColors.white, size: 20),
                    SizedBox(width: 2),
                    Text("125 kcal", style: TextStyle(color: MainColors.white, fontSize: 13)),
                    SizedBox(width: 8),
                    Icon(Icons.access_time, color: MainColors.white, size: 20),
                    SizedBox(width: 2),
                    Text("50 min", style: TextStyle(color: MainColors.white, fontSize: 13)),
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
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Icon(Icons.arrow_forward_ios, size: 16, color: hint.customGray),
        ],
      ),
    );
  }

  Widget _buildTopResourcesSlider(List<Map<String, String>> resources) {
    return Container(
      height: 220,
      child: ListView.builder(
        controller: PageController(viewportFraction: 0.8),
        scrollDirection: Axis.horizontal,
        itemCount: resources.length,
        itemBuilder: (context, index) {
          double leftMargin = index == 0 ? 10.0 : 0.0;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResourceDetailPage(
                    title: resources[index]['title']!,
                    imagePath: resources[index]['imagePath']!,
                    kcal: resources[index]['kcal']!,
                    time: resources[index]['time']!,
                    description: resources[index]['description']!,
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(left: leftMargin, right: 0.0),
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

  Widget _buildResourceCard(String title, String imagePath, String kcal, String time) {
    return Container(
      width: 185,
      margin: EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [],
      ),
      child: Stack(
        children: [
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
                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.lato(
                    color: MainColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1),
                Row(
                  children: [
                    Icon(Icons.local_fire_department, color: MainColors.white, size: 16),
                    SizedBox(width: 2),
                    Text(kcal, style: TextStyle(color: MainColors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Icon(Icons.access_time, color: MainColors.white, size: 16),
                    SizedBox(width: 2),
                    Text(time, style: TextStyle(color: MainColors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopWorkoutPlanSlider(List<Map<String, String>> workoutPlans) {
    return Container(
      height: 240,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.95),
        itemCount: workoutPlans.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
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

  Widget _buildWorkoutPlanCard(String title, String imagePath, String kcal, String time, String date) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.0, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Image.asset(
              imagePath,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
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
                  Text(
                    title,
                    style: TextStyle(color: MainColors.white, fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  SizedBox(height: 4),
                  Text(date, style: TextStyle(color: MainColors.white, fontSize: 12)),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.local_fire_department, color: MainColors.white, size: 16),
                      SizedBox(width: 4),
                      Text(kcal, style: TextStyle(color: MainColors.white, fontSize: 12)),
                      SizedBox(width: 16),
                      Icon(Icons.access_time, color: MainColors.white, size: 16),
                      SizedBox(width: 4),
                      Text(time, style: TextStyle(color: MainColors.white, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              right: 12,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  side: BorderSide(color: MainColors.white),
                ),
                child: Text('Join', style: TextStyle(color: MainColors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
