import 'package:aikyamm/authentication/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true; // State to manage Log In and Sign Up toggle

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    var screenSize = MediaQuery.of(context).size;
    var isTablet = screenSize.width > 600; // For responsiveness

    return Scaffold(
      body: Stack(
        children: [
          // Background pattern (SVG)
          Positioned(
            top: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/images/Vector.svg', // Your SVG pattern
              height: isTablet ? 350 : 250,
              width: isTablet ? 350 : 250,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    // Logo
                    SvgPicture.asset(
                      'assets/images/logoforsplash.svg',
                      height: isTablet ? 200 : 150,
                      width: isTablet ? 200 : 150,
                    ),
                    const SizedBox(height: 20),
                    // Title Text
                    Text(
                      "Get Started now",
                      style: TextStyle(
                        fontSize: isTablet ? 32 : 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isLogin
                          ? "Log in to continue"
                          : "Create an account to explore",
                      style: TextStyle(
                        fontSize: isTablet ? 20 : 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Login/Signup Toggle Tabs
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isLogin = true;
                            });
                          },
                          child: Text(
                            "Log In",
                            style: TextStyle(
                              fontSize: isTablet ? 22 : 18,
                              fontWeight: FontWeight.bold,
                              color: isLogin ? Colors.black : Colors.black54,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isLogin = false;
                            });
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: isTablet ? 22 : 18,
                              fontWeight: FontWeight.bold,
                              color: isLogin ? Colors.black54 : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Email Input
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Password Input
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: const Icon(Icons.visibility),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (isLogin)
                      // Remember Me & Forgot Password only for Log In
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: true,
                                onChanged: (newValue) {
                                  // Remember Me function
                                },
                              ),
                              const Text("Remember me"),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              // Forgot password function
                            },
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    // Log In/Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Log In/Sign Up function
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF8F0000), // Background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text(
                          isLogin ? "Log In" : "Sign Up",
                          style: TextStyle(
                            fontSize: isTablet ? 20 : 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("Or login with"),
                    const SizedBox(height: 10),
                    // Google & Apple Login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Image.asset(
                            'assets/images/google.png',
                            height: isTablet ? 40 : 30,
                            width: isTablet ? 40 : 30,
                          ),
                          onPressed: () {
                            // Google login function
                          },
                        ),
                        const SizedBox(width: 25),
                        IconButton(
                          icon: Image.asset(
                            'assets/images/applelogo.png',
                            height: isTablet ? 64 : 50,
                            width: isTablet ? 64 : 50,
                          ),
                          onPressed: () {
                            // Apple login function
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
