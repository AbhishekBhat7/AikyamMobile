# aikyamm

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AppleSignInPage()),
        );
 Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupScreen()),
                  );


  android: "launcher_icon"
  ios: true
  image_path: "assets/images/logoforsplashrbg.png"
  min_sdk_android: 21 # android min sdk min:16, default 21
  web:
    generate: true
    image_path: "assets/images/logoforsplashrbg.png"
    background_color: "#hexcode"
    theme_color: "#hexcode"
  windows:
    generate: true
    image_path: "assets/images/logoforsplashrbg.png"
    icon_size: 48 # min:48, max:256, default: 48
  macos:
    generate: true
    image_path: "assets/images/logoforsplashrbg.png"


AikyamScret : N2O8Q~2X6sLtGA0XIUqsnPTFhfZKmAY_BnGRGdgh( Azure )


username and password for the postgresql singleserver.
name : abhi
password: Admin123@$%



file storage 
database
backend






  class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  DBHelper._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'login_state.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(''' 
          CREATE TABLE user_state (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            is_logged_in INTEGER
          )
        ''');
      },
    );
  }

  Future<void> setLoginState(bool isLoggedIn) async {
    final db = await database;

    // Clear previous state and set new state
    await db.delete('user_state');
    await db.insert('user_state', {'is_logged_in': isLoggedIn ? 1 : 0});
  }

  Future<bool> getLoginState() async {
    final db = await database;

    final result = await db.query('user_state');
    if (result.isNotEmpty) {
      return result.first['is_logged_in'] == 1;
    }
    return false;
  }

  Future<void> clearLoginState() async {
    final db = await database;
    await db.delete('user_state');
  }
}


Future<void> _handleGoogleSignIn(BuildContext context) async {
  try {
    // Attempt to sign in with Google
    var userCredential = await AuthMethods().signInWithGoogle(context);

    // Check if the userCredential and user are not null
    if (userCredential != null && userCredential.user != null) {
      // Store the login state in the cache (SQLite)
      await DBHelper().setLoginState(true);

      // User sign-in successful, navigate to the next screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChoiceScreen(
            userId: userCredential.user!.uid, // Ensure user is not null
          ),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google sign-in Successful.")),
      );
    } else {
      // Handle the case where the userCredential or user is null
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google sign-in failed. Please try again.")),
      );
    }
  } catch (e) {
    // Catch any errors during the sign-in process
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  }
}







Device Name


Manufacturer Data

Tx Power Level


1) Device Type 2)Advertising Type 3) Complete list of 16/128-bit Service UUIDs 4) Complete Local Name 5)Flags 6) Service Data 1/more (if there) 7)  Manufacturer data (Bluetooth Core 4.1):8) Company: 9) RSSI (Signal Strength) 10) TX Power 11)  Service UUIDs 12) Service Data 13)Company:-Type:, Length:, UUID: , Major:, Minor:  etc...


look at the code and make this code working like nrf connect there the arrows are pleced in the each sub cards and there in the read propertie  and  when are going to click on the down arrow that will show the values like times or any data that is sent. And when we click on the uparrow we can write / send the data to the device so similarly make my code to work like that to make it working. 

look at this code and look at nrf connect so there see how the arrows are kept dynamically like uparrow, downarrow, insome case both if necessary and if  i had clicked on the downarrow means read operation there i got when i click on the downarrow is properties, values . So similarly give me the code to work like a nrf connect. So this is the code so please give me updated full working code 

this is in the nrf connect Service Changed , uUid: 0x2a05, propertie: indicate if we click the arrow near this card in the nrf connect then the here its descriptor Cards uuid:0x2902 and this value will be updated value:indication enabled so please make this type of updated code 